-- Train Timetable Data
local trainSchedule = {
    {time = "07:45", destination = "South", platform = 1, delayed = false, delayMinutes = 0, cancelled = false},
    {time = "08:15", destination = "Central", platform = 2, delayed = true, delayMinutes = 5, cancelled = false},
    {time = "08:30", destination = "North", platform = 2, delayed = false, delayMinutes = 0, cancelled = false},
    {time = "09:00", destination = "East", platform = 2, delayed = false, delayMinutes = 0, cancelled = true},
    {time = "09:30", destination = "West", platform = 1, delayed = true, delayMinutes = 10, cancelled = false},
    {time = "10:00", destination = "Northeast", platform = 1, delayed = false, delayMinutes = 0, cancelled = false},
    {time = "10:30", destination = "Northwest", platform = 1, delayed = true, delayMinutes = 15, cancelled = false},
    {time = "11:00", destination = "Southeast", platform = 2, delayed = false, delayMinutes = 0, cancelled = false},
    {time = "11:30", destination = "Southwest", platform = 1, delayed = false, delayMinutes = 0, cancelled = true},
    {time = "12:00", destination = "Central", platform = 1, delayed = true, delayMinutes = 20, cancelled = false},
    {time = "12:30", destination = "North", platform = 2, delayed = false, delayMinutes = 0, cancelled = false},
    {time = "13:00", destination = "East", platform = 2, delayed = false, delayMinutes = 0, cancelled = true},
    {time = "13:30", destination = "West", platform = 1, delayed = true, delayMinutes = 5, cancelled = false},
    {time = "14:00", destination = "South", platform = 1, delayed = false, delayMinutes = 0, cancelled = false},
    {time = "14:30", destination = "Northeast", platform = 2, delayed = true, delayMinutes = 10, cancelled = false},
    {time = "15:00", destination = "Northwest", platform = 2, delayed = false, delayMinutes = 0, cancelled = true},
    {time = "15:30", destination = "Southeast", platform = 1, delayed = false, delayMinutes = 0, cancelled = false},
    {time = "16:00", destination = "Southwest", platform = 2, delayed = true, delayMinutes = 15, cancelled = false},
    {time = "16:30", destination = "Central", platform = 1, delayed = false, delayMinutes = 0, cancelled = false},
    {time = "17:00", destination = "North", platform = 2, delayed = false, delayMinutes = 0, cancelled = false},
}

-- Initialize the Monitor
local monitor = peripheral.wrap("top") -- Adjust if the monitor is on a different side
monitor.setTextScale(1) -- Reduce text size to fit more information
monitor.clear()

-- Set Colors
local colors = {
    header = colors.cyan,
    label = colors.orange,
    text = colors.white,
    currentTime = colors.green,
    delayed = colors.red,
    cancelled = colors.gray,
    arriving = colors.lime,
    scroll = colors.yellow,
}

-- Function to display text with color
local function coloredWrite(text, color)
    monitor.setTextColor(color)
    monitor.write(text)
    monitor.setTextColor(colors.text) -- Reset to default text color
end

-- Function to Convert Time String to Minutes
local function timeToMinutes(timeStr)
    local hours, minutes = timeStr:match("(%d+):(%d+)")
    return tonumber(hours) * 60 + tonumber(minutes)
end

-- Function to Display Current Time
local function displayCurrentTime()
    local time = textutils.formatTime(os.time(), true) -- Get current in-game time
    monitor.setCursorPos(1, 1)
    coloredWrite("Time: ", colors.label)
    coloredWrite(time, colors.currentTime)
end

-- Function to Display Next Trains
local function displayNextTrains()
    local currentTime = timeToMinutes(textutils.formatTime(os.time(), true))
    local displayedTrains = 0
    local maxTrains = 16

    monitor.setCursorPos(1, 2)
    coloredWrite("Status   Time   Dest          Plat Info", colors.header)

    for _, train in ipairs(trainSchedule) do
        local trainTime = timeToMinutes(train.time) + (train.delayed and train.delayMinutes or 0)
        if trainTime >= currentTime and displayedTrains < maxTrains then
            displayedTrains = displayedTrains + 1
            local row = 2 + displayedTrains
            monitor.setCursorPos(1, row)

            local status = ""
            local info = ""
            local timeDifference = trainTime - currentTime

            if timeDifference <= 10 and not train.cancelled then
                status = "Arriving"
            end

            if train.cancelled then
                info = "Cancelled"
            elseif train.delayed then
                info = string.format("Delayed %d min", train.delayMinutes)
            end

            local statusColor = status == "Arriving" and colors.arriving or colors.text
            coloredWrite(string.format("%-8s ", status), statusColor)
            coloredWrite(string.format("%-6s %-13s %-4d %-10s", train.time, train.destination, train.platform, info), train.cancelled and colors.cancelled or (train.delayed and colors.delayed or colors.text))
        end
    end
end

-- Scrolling Information Variables
local scrollText = "                                        This is scrolling information. It can be used to display additional details or updates. Scrolling continues... "
local scrollSpeed = 0.1 -- Slower scrolling speed for smaller text
local scrollPos = 1 -- Initial position for scrolling

-- Function to Update Scrolling Information
local function updateScrollingInfo()
    monitor.setCursorPos(1, 19) -- Adjust vertical position as per your monitor setup
    local displayWidth = monitor.getSize() -- Get monitor width
    local endIndex = scrollPos + displayWidth - 1
    local visibleText = scrollText:sub(scrollPos, endIndex)
    
    if endIndex > #scrollText then
        visibleText = visibleText .. scrollText:sub(1, endIndex - #scrollText)
    end
    
    coloredWrite(visibleText, colors.scroll)
    scrollPos = scrollPos % #scrollText + 1
end

-- Loop to Update the Display
while true do
    monitor.clear()
    displayCurrentTime()
    displayNextTrains()
    updateScrollingInfo()
    sleep(scrollSpeed) -- Adjust for scrolling speed
end
