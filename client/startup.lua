-- GlassChat 3 Client
-- By Tiiger87 and Alexandrov01


-- INITIALIZE SETTINGS
    clientV = "3.0.0 BETA";
    clientID = os.getComputerID()
    
    
    
    clientM = nil
    clientB = nil
    
    --Checks if computer is an advanced computer
    if term.isColor() == false then
        term.setTextColor(colors.red)
        print("ERROR: Not an advanced computer! Please check your computer setup.")
        term.setTextColor(colors.white)
        os.exit()
    end
    
    --Gets terminal bridge and wired modem side
sides = {"top", "bottom", "left", "right", "front", "back"}
    for v in sides do
        if peripheral.getType(v)==modem then
            clientM = peripheral.wrap(v)
        elseif peripheral.getType(v)==openperipheral_glassesbridge then
            clientB = peripheral.wrap(v)
        end
    end
    
    -- Checks if modem and bridge are present.
    if clientM == nil or clientB == nil then
        term.setTextColor(colors.red)
        print("ERROR: Missing modem or bridge! Please check your computer setup.")
        term.setTextColor(colors.white)
        os.exit()
    end
    
    
    -- Print basic info to screen
    term.setTextColor(colors.yellow)
    print("GlassChat 3 Client "..clientV)
    term.setTextColor(colors.white)
    print("ID: "..clientID)
