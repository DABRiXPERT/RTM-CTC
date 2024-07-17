----------------------------------------------------------
--                                                      --
-- Name: Another Block Signal Reciver & Displayer       --
-- Version: 23.07.13.Dev1                               --
--                                                      --
-- DABRiXPERT, 2023                                     --
-- R.C.C x TEAM BRiXPERT, 2017-2023                     --
--                                                      --
----------------------------------------------------------
-- DISCLAIMER: THIS PROGRAM IS STILL IN DEV!
-- ALWAYS REMEMBER TO BACKUP YOUR MAP FILE IN %appdata%/.minecraft/saves/[YOUR MAP NAME]! 
-- WE WON'T BE RESPONSIBLE FOR THE CRITICAL ERROR & CORRUPTION FOR YOUR MAP!

-- Modem & Route Initialize (Change these variables if needed)
ModemPos = "top"
DetectorInputPos = "left"
SignalOutputPos = "back"
BlockName = "Block-" .. os.getComputerID()
Timeout = 3 -- Reciving time limit (seconds)
rednet.open(ModemPos)

-- Connection (Must change these variables, example below:)

-- 1. Fill the computer ID into these variables: 
CurrentBlkID = os.getComputerID()
FirstBlkID = 1 -- ID of the first block ahead
SecondBlkID = 2 -- ID of the second block ahead
-- Uncomment if needed for 5 or more signal status:
-- ThirdBlkID = ?
-- FourthBlkID = ? 
-- FifthBlkID = ? 
-- SixthBlkID = ? 
-- SeventhBlkID = ? 

-- 2. Set the RS output strength for each signal status (Uncomment if needed):
-- (R = Red, Y = Yellow, G = Green, B = Blinking)

-- HiSpeed = ? (GG)
AllRight = 15 --(G)
-- Reduce = ? (BYG)
-- Slow = ? (YG)
Caution = 14 --(Y)
-- Restrict = ? --(BY)
Warning = 13 -- (YY)
Danger = 12 -- (R)

-- 3. Display Signal Result (Copy & Modify the samples if needed):

while true do
    local chn_name
    local id
    local received
    local nearest = -1
    -- 7th block ahead: NULL
    -- 6th block ahead: NULL
    -- 5th block ahead: NULL
    -- 4th block ahead: NULL
    -- 3rd block ahead: NULL
    -- 2nd block ahead:
    chn_name = "Block-"..SecondBlkID
    id, received = rednet.receive(chn_name, Timeout)
    term.write(os.date("[%d-%T] ")..chn_name.." is ")
    if id == SecondBlkID and received == chn_name.." Used" then
        nearest = SecondBlkID
        term.setTextColor(colors.orange)
        print("Used")
        term.setTextColor(colors.white)
    elseif id == SecondBlkID and received == chn_name.." Unused" then
        term.setTextColor(colors.lime)
        print("Unused")
        term.setTextColor(colors.white)
    else
        term.setTextColor(colors.red)
        print("Out of order")
        term.setTextColor(colors.white)
    end
    -- 1st block ahead:
    chn_name = "Block-"..FirstBlkID
    id, received = rednet.receive(chn_name, Timeout)
    term.write(os.date("[%d-%T] ")..chn_name.." is ")
    if id == FirstBlkID and received == chn_name.." Used" then
        nearest = FirstBlkID
        term.setTextColor(colors.orange)
        print("Used")
        term.setTextColor(colors.white)
    elseif id == FirstBlkID and received == chn_name.." Unused" then
        term.setTextColor(colors.lime)
        print("Unused")
        term.setTextColor(colors.white)
    else
        term.setTextColor(colors.red)
        print("Out of order")
        term.setTextColor(colors.white)
    end
    -- Current block:
    local occupied = redstone.getInput(DetectorInputPos)
    if occupied then
        nearest = CurrentBlkID
        term.setTextColor(colors.orange)
        print("Used")
        term.setTextColor(colors.white)
    else
        term.setTextColor(colors.lime)
        print("Unused")
        term.setTextColor(colors.white)
    end

    -- Result output:
    term.write(os.date("[%d-%T] ").."Result: ")
    if nearest == CurrentBlkID then
        redstone.setAnalogOutput(SignalOutputPos, Danger)
        term.setTextColor(colors.red)
        print("Danger!")
        term.setTextColor(colors.white)
    end
    if nearest == FirstBlkID then
        redstone.setAnalogOutput(SignalOutputPos, Warning)
        term.setTextColor(colors.orange)
        print("Warning.")
        term.setTextColor(colors.white)
    end
    if nearest == SecondBlkID then
        redstone.setAnalogOutput(SignalOutputPos, Caution)
        term.setTextColor(colors.yellow)
        print("Caution.")
        term.setTextColor(colors.white)
    end
    if nearest == -1 then
        redstone.setAnalogOutput(SignalOutputPos, AllRight)
        term.setTextColor(colors.lime)
        print("All-Right!")
        term.setTextColor(colors.white)
    end

    --Refresh Period (Change if needed, Default = 0.2s = 4ticks)
    sleep(0.2)
end