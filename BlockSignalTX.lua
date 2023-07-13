----------------------------------------------------------
--                                                      --
-- Name: Block Signal Transmit & Operate Program        --
-- Version: 23.02.14.Dev2                               --
-- [Deprecated and will be removed in next version]     --
--                                                      --
-- DABRiXPERT, 2023                                     --
-- R.C.C x TEAM BRiXPERT, 2017-2023                     --
--                                                      --
----------------------------------------------------------

-- Modem & Route Initialize (Change these variables)
ModemPos = "top"
RouteID = {0, 1, 2, 3, 4, 5, 6, 7} -- At least 4 IDs, depend on your signal type
Channel = "CTC-Channel"
BlockName = "Block-"..os.getComputerID()

-- Frequently used functions
-- Find Position by Value
local function findPositionByValue(array, value)
    for k,v in pairs(array) do -- Invert table
      if v==value then return k end -- Find
    end
    return nil -- Lost
end



-- Main Function

-- Initialize modem & Establish Protocol
rednet.open(ModemPos)
rednet.host(Channel, BlockName)

-- Initialize Signal
redstone.setOutput("left", true) sleep(0.05) redstone.setOutput("left", false)
redstone.setOutput("right", false) sleep(0.05) redstone.setOutput("right", true)

-- Detect block occupation
while true do
    local occupied = redstone.getInput("back") -- Check Occupied
    term.write(os.date("[%d-%T] ")..BlockName.." is ") -- Log Timestamp & Display BlockName
    if occupied then
        --Print Log
        term.setTextColor(colors.red) print("OCCUPIED") term.setTextColor(colors.white)

        -- Summon variables
        local used_id = os.getComputerID()-- Sector computer's ID
        local used_pos = tonumber(findPositionByValue(RouteID, used_id)) -- Sector in track position

        -- Used(Emergency) Signal Transmit
        if used_pos > 0 then
            rednet.send(RouteID[used_pos], "STOP", Channel)
        end

        -- Warning Signal Transmit
        if used_pos-1 > 0 then
            rednet.send(RouteID[used_pos-1], "WARN", Channel)
        end

        -- Caution Signal Transmit
        if used_pos-2 > 0 then
            rednet.send(RouteID[used_pos-2], "CAUT", Channel)
        end
    else
        term.setTextColor(colors.lime) print("UNOCCUPIED") term.setTextColor(colors.white)
    end
    sleep(1.5) -- Transmit frequency (seconds), the larger the number is, the slower the signal being transmitted.
    -- However if the number is too small, it may cause the TPS lower and even cause the map from corrupting.
    -- DISCLAIMER: ALWAYS REMEMBER TO BACKUP YOUR MAP FILE IN %appdata%/.minecraft/saves/[YOUR MAP NAME]! WE WON'T BE RESPONSIBLE FOR THE CRITICAL ERROR/CORRUPTION OF YOUR MAP!

end