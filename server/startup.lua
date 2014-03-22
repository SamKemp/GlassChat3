-- GlassChat 3 Server
-- By Tiiger87 and Alexandrov01

-- INITIALIZE SETTINGS
    serverV = "3.0.0 BETA";
    serverID = os.getComputerID()
    
    serverM = nil
    
    --Checks if computer is an advanced computer
    if term.isColor() == false then
        print("ERROR: Not an advanced computer! Please check your computer setup.")
        error()
    end
    
    --Gets terminal bridge and wired modem side
    sides = {"top", "bottom", "left", "right", "front", "back"}
    for key1, value1 in pairs(sides) do
        if peripheral.getType(value1)=="modem" then
            serverM = peripheral.wrap(value1)
        end
    end
    
    -- Checks if modem and bridge are present.
    if serverM == nil then
        term.setTextColor(colors.red)
        print("ERROR: Missing modem! Please check your computer setup.")
        term.setTextColor(colors.white)
        error()
    end
    
    
    -- Print basic info to screen
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.yellow)
    print("GlassChat 3 Server "..serverV)
    term.setTextColor(colors.white)
    print("ID: "..serverID)
