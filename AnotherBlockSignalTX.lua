----------------------------------------------------------
--                                                      --
-- Name: Another Block Signal Transmitter               --
-- Version: 23.07.13.Dev1                               --
--                                                      --
-- DABRiXPERT, 2023                                     --
-- R.C.C. x TEAM BRiXPERT, 2017-2023                    --
--                                                      --
----------------------------------------------------------
-- DISCLAIMER: THIS PROGRAM IS STILL IN DEV!
-- ALWAYS REMEMBER TO BACKUP YOUR MAP FILE IN %appdata%/.minecraft/saves/[YOUR MAP NAME]! 
-- WE WON'T BE RESPONSIBLE FOR THE CRITICAL ERROR & CORRUPTION FOR YOUR MAP!


-- Modem & Route Initialize (Change these variables if needed)
ModemPos = "top"
DetectorInputPos = "left"
BlockName = "Block-" .. os.getComputerID()

-- Initialize modem & create protocol
rednet.open(ModemPos)
Channel = BlockName
rednet.host(Channel, BlockName)


-- Signal Initialization
redstone.setAnalogOutput("back", 15)
sleep(0.05)

-- Deteck block occupation
while true do
    -- Check if occupied
    local occupied = redstone.getInput(DetectorInputPos)
    -- Log Timestamp & Display BlockName
    term.write(os.date("[%d-%T] ")..BlockName.." is ")
    -- Display status & Broadcasting
    if occupied then
        term.setTextColor(colors.red) print("OCCUPIED") term.setTextColor(colors.white)
        rednet.broadcast(BlockName.." Used", Channel)
    else
        term.setTextColor(colors.lime) print("UNOCCUPIED") term.setTextColor(colors.white)
        rednet.broadcast(BlockName.." Unused", Channel)
    end
    --Transmisson Period (Change if needed, Default = 0.1s = 2ticks)
    sleep(0.1)
end