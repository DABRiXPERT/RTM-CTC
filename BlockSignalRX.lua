----------------------------------------------------------
--                                                      --
-- Name: Block Signal Receive & Display Program         --
-- Version: 23.02.13.Dev1                               --
--                                                      --
-- DABRiXPERT, 2023                                     --
-- R.C.C x TEAM BRiXPERT, 2017-2023                     --
--                                                      --
----------------------------------------------------------

-- Modem & Route Initialize (Change these variables)
ModemPos = "top"
Channel = "CTC-Channel"
BlockName = "Block-"..os.getComputerID()
Timeout = 5 -- No response timeout



-- Main Function

-- Initialize modem & Establish Protocol
rednet.open(ModemPos)
rednet.host(Channel, BlockName)

-- Initialize Signal
redstone.setOutput("left", true) sleep(0.05) redstone.setOutput("left", false)
redstone.setOutput("right", false) sleep(0.05) redstone.setOutput("right", true)

-- Receive signal data from other block & Display signal
while true do
    local id, display = rednet.receive(Channel, Timeout)
    local init = 0 -- Initialize while not received any caution/stop signal for 5 period
    term.write(os.date("[%d-%T] ")..BlockName.." is ") -- Log Timestamp & Display BlockName
    if id == nil then
        if init >= 5 then
            redstone.setOutput("left", true) sleep(0.05) redstone.setOutput("left", false)
            redstone.setOutput("right", false) sleep(0.05) redstone.setOutput("right", true) -- SAFE-INIT signal
            term.setTextColor(colors.green) print("SAFE-INIT") term.setTextColor(colors.white)
            init = 0
        else
            redstone.setOutput("right", true) -- SAFE signal
            init = init + 1 -- Initialize Counter
            term.setTextColor(colors.lime) print("SAFE") term.setTextColor(colors.white)
        end
    else
        if display == "STOP" then
            redstone.setOutput("right", false) -- STOP signal
            term.setTextColor(colors.red) print("STOP") term.setTextColor(colors.white)
        end
        if display == "WARN" then
            redstone.setOutput("left", true) -- WARN signal
            term.setTextColor(colors.orange) print("WARNING") term.setTextColor(colors.white)
        end
        if display == "CAUT" then
            redstone.setOutput("left", false) -- CAUTION signal
            term.setTextColor(colors.yellow) print("CAUTION") term.setTextColor(colors.white)

        end
    end
    sleep(4) -- Receive frequency (seconds)
end