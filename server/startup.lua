-- GlassChat 3 Server
-- By Tiiger87 and Alexandrov01

-- INITIALIZE SETTINGS

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
            rednet.open(value1)
        end
    end
    
    -- Checks if modem and bridge are present.
    if serverM == nil then
        term.setTextColor(colors.red)
        print("ERROR: Missing modem! Please check your computer setup.")
        term.setTextColor(colors.white)
        error()
    end

    -- Variables
    serverV = "3.0.0 BETA";
    serverID = os.getComputerID()
    serverM = nil

    local names = {}
    if fs.exists("data/names") then
        file3 = fs.open("data/names","r")
            snames = file3.readAll()
            names = textutils.unserialize(snames)
        file3.close()
    end

    -- Print basic info to screen
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.yellow)
    print("GlassChat 3 Server "..serverV)
    term.setTextColor(colors.white)
    print("ID: "..serverID)
    print("U: Update all clients.")
    print("R: Restart all clients.")
    print("S: Update server.")
    print("----------------------")
    
    rednet.broadcast("Chatroom back online!")
   
   -- Functions
    
    -- Client Requests
    function clientRequests()
        while true do
            id, msg = rednet.receive()
            if string.len(msg) >= 1 then
                if string.match(msg, '^!gc') then
                    if string.match(msg, '^!gc username') then
                        names[id] = string.sub(msg, 14)
                        rednet.broadcast("Computer "..id.." joined under the name of "..names[id]..".")
                        print(names[id].."("..id..") joined.")
                        file2 = fs.open("data/names","w")
                        file2.write( textutils.serialize( names ) )
                        file2.close()
                        
                    elseif string.match(msg, '^!gc newusername') then
                        newname = string.sub(msg, 17)
                        rednet.broadcast(names[id].." has changed his/her name to "..newname..".")
                        print(names[id].." has changed his/her name to "..newname..".")
                        names[id] = newname
                        file2 = fs.open("data/names","w")
                        file2.write( textutils.serialize( names ) )
                        file2.close()
                        
                    elseif string.match(msg, '^!gc leaving') then
                        print(names[id].."("..id..") has left. ")
                        rednet.broadcast(names[id]..": has left")
                        
                        
                    elseif string.match(msg, '^!gc updating') then
                        print(names[id].."("..id..") is updating. ")
                        rednet.broadcast(names[id]..": is updating.")
                    else
                        
                    end
                elseif string.len( names[id] ) >= 1 then
                    print(names[id].."("..id..") - "..msg)
                    rednet.broadcast(names[id]..": "..msg)
                end
            end
        end
    end
    
    -- Server key commands
    function serverCommands()
      while true do
         local evt, c = os.pullEvent("char") -- wait for a key press
         c = string.lower(c) -- convert to lower case, to register both r & R.
            if c == "r" then
                print("Server - R pressed. Restarting all clients.")
                    rednet.broadcast("!gc reboot")
		    sleep(0.1)  -- Delay to stop all computers from connecting at the same time
                    
            elseif c == "u" then
                print("Server - U pressed. Updating all clients.")
                    rednet.broadcast("!gc update")
		    sleep(0.1) -- Delay to stop all computers from connecting at the same time
                    
            elseif c == "s" then
                print("Server - S pressed. Updating and Rebooting server.")
                    rednet.broadcast("Server is updating and restarting.")
                shell.run("update")
            end
	sleep(0)
      end
    end

    -- Wait for any...
    parallel.waitForAny(clientRequests, serverCommands)
