----------------------------------------------------------
--                                                      --
-- Name: Block Signal Receive & Display Program         --
-- Version: 23.02.14.Dev2                               --
-- [Deprecated and will be removed in next version]     --
--                                                      --
-- DABRiXPERT, 2023                                     --
-- R.C.C x TEAM BRiXPERT, 2017-2023                     --
--                                                      --
----------------------------------------------------------

-- Modem & Route Initialize (Change these variables)
ModemPos = "top"
Channel = "CTC-Channel"
BlockName = "Block-"..os.getComputerID()
Timeout = 3 -- No response timeout



-- Main Function

-- Initialize modem & Establish Protocol
rednet.open(ModemPos)
rednet.host(Channel, BlockName)

-- Initialize Signal
redstone.setOutput("left", true) sleep(0.05) redstone.setOutput("left", false)
redstone.setOutput("right", false) sleep(0.05) redstone.setOutput("right", true)
local interval = 5 -- Initialize while not received any caution/stop signal for [interval] period (or Refresh certain signal if not displayed), preventing the signal from refreshing too frequently that the driver can't figure out the current signal.
local init = 0 -- Stores initialize interval
local signal = 4 -- Signal status, if init >= 5 then this value will be changed, the refersh rate can be replaced at line 36.

-- Receive signal data from other block & Display signal
while true do
    local id, display = rednet.receive(Channel, Timeout)
    term.write(os.date("[%d-%T] ")..BlockName.." is ") -- Log Timestamp & Display BlockName
    if id == nil then -- Receive no signal
        if init >= interval and signal == 4 then -- Line 28
            redstone.setOutput("left", true) sleep(0.05) redstone.setOutput("left", false)
            redstone.setOutput("right", false) sleep(0.05) redstone.setOutput("right", true) -- SAFE-INIT signal
            term.setTextColor(colors.lime) print("SAFE-INIT") term.setTextColor(colors.white)
            init = 0
            signal = 4
        else
            redstone.setOutput("right", true) -- SAFE signal
            init = init + 1 -- Initialize Counter + 1 period
            term.setTextColor(colors.lime) print("SAFE-"..init) term.setTextColor(colors.white)
            signal = 4
        end
    else
        -- STOP SIGNAL
        if display == "STOP" then
            if init >= interval and signal == 1 then -- Line 28
                redstone.setOutput("left", true) sleep(0.05) redstone.setOutput("left", false)
                redstone.setOutput("right", true) sleep(0.05) redstone.setOutput("right", false) -- STOP-INIT signal
                term.setTextColor(colors.red) print("STOP-INIT") term.setTextColor(colors.white)
                init = 0
                signal = 1
            else
                redstone.setOutput("right", false) -- STOP signal
                init = init + 1 -- Initialize Counter + 1 period
                term.setTextColor(colors.red) print("STOP-"..init) term.setTextColor(colors.white)
                signal = 1
            end
        end
        -- WARNING SIGNAL
        if display == "WARN" then
            if init >= interval and signal == 2 then -- Line 28
                redstone.setOutput("right", false) sleep(0.05) redstone.setOutput("right", true)
                redstone.setOutput("left", false) sleep(0.05) redstone.setOutput("left", true) -- WARN-INIT signal
                term.setTextColor(colors.orange) print("WARN-INIT") term.setTextColor(colors.white)
                init = 0
                signal = 2
            else
                redstone.setOutput("left", true) -- WARN signal
                init = init + 1 -- Initialize Counter + 1 period
                term.setTextColor(colors.orange) print("WARNING-"..init) term.setTextColor(colors.white)
                signal = 2
            end
        end
        -- CAUTION SIGNAL
        if display == "CAUT" then
            if init >= interval and signal == 3 then -- Line 28
                redstone.setOutput("right", false) sleep(0.05) redstone.setOutput("right", true)
                redstone.setOutput("left", true) sleep(0.05) redstone.setOutput("left", false) -- CAUT-INIT signal
                term.setTextColor(colors.yellow) print("CAUT-INIT") term.setTextColor(colors.white)
                init = 0
                signal = 3
            else
                redstone.setOutput("left", false) -- CAUTION signal
                init = init + 1 -- Initialize Counter + 1 period
                term.setTextColor(colors.yellow) print("CAUTION-"..init) term.setTextColor(colors.white)
                signal = 3
            end
        end
    end
    sleep(1.5) -- Receive frequency (seconds), the larger the number is, the slower the signal refershes.
    -- However if the number is too small, it may cause the TPS lower and even cause the map being corrupted.
    -- DISCLAIMER: ALWAYS REMEMBER TO BACKUP YOUR MAP FILE IN %appdata%/.minecraft/saves/[YOUR MAP NAME]! WE WON'T BE RESPONSIBLE FOR THE CRITICAL ERROR/CORRUPTION OF YOUR MAP!
end