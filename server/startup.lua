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
    
    -- Get monitor ID from file
    if fs.exists("data/monitor") then
        monn = fs.open("data/monitor", "r")
            serverMonitorIsSet = true
            monID = monn.readAll()
            monID = tonumber(monID)
        monn.close()
        if monID == "" then
            term.setTextColor(colors.red)
            print("ERROR: Empty monitor ID in data/monitor!")
            term.setTextColor(colors.white)
            error()
        end
    else
        serverMonitorIsSet = false
        term.setTextColor(colors.orange)
        print("WARNING: Missing monitor ID file in data/monitor!")
        term.setTextColor(colors.white)
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
    print("K: Kill server.")
    print("----------------------")
    
    -- Count conntected users/clients
    function count(input)
        if type(input)~='table' then
            return nil
        end
        local int=0
        for k,v in pairs(input) do
            int=int+1
        end
        return int
    end
    connectedUsersCount = count(names)
    
    -- Send status of server to monitor (if any)
    --[[if serverMonitorIsSet == true then
        print("Sending messages to monitor...")
        rednet.send(monID, "!sysmsg to-monitor status=OK")
        sleep(1)
        rednet.send(monID, "!sysmsg to-monitor users="..connectedUsersCount)
        sleep(3)
        print("Waiting for monitor response...")
        waitForMonitor = ""
        while waitForMonitor == "" do
            print("Waiting...")
            id, msg = rednet.receive()
            if id == monID and msg == "Monitor-OK" then
                print("Monitor ready!")
                waitForMonitor = true
            end
        end
    else
        
    end]]--
    
    -- Broadcast status of server to all clients
    rednet.broadcast("!sysmsg Chatroom is back online!")
    rednet.broadcast("!sysmsg "..connectedUsersCount.." connected users.")
    
   
    -- Functions
    
    -- Client Requests
    function clientRequests()
        while true do
            id, msg = rednet.receive()
            if string.len(msg) >= 1 then
                if string.match(msg, '^!gc') then
                    if string.match(msg, '^!gc username') then
                        names[id] = string.sub(msg, 14)
                        rednet.broadcast("!sysmsg "..names[id].." (ID "..id..") joined the chat.")
                        print(names[id].."("..id..") joined.")
                        file2 = fs.open("data/names","w")
                        file2.write( textutils.serialize( names ) )
                        file2.close()
                        
                    elseif string.match(msg, '^!gc newusername') then
                        newname = string.sub(msg, 17)
                        rednet.broadcast("!sysmsg "..names[id].." has changed his/her name to "..newname..".")
                        print(names[id].." has changed his/her name to "..newname..".")
                        names[id] = newname
                        file2 = fs.open("data/names","w")
                        file2.write( textutils.serialize( names ) )
                        file2.close()
                        
                    elseif string.match(msg, '^!gc leaving') then
                        print(names[id].."("..id..") has left.")
                        rednet.broadcast("!sysmsg "..names[id].." has left the chat.")
                        
                        
                    elseif string.match(msg, '^!gc updating') then
                        print(names[id].."("..id..") is updating.")
                        rednet.broadcast("!sysmsg "..names[id].." has left the chat (updating).")
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
                    rednet.broadcast("!sysmsg Server is updating and restarting.")
                shell.run("update")
                
            elseif c == "k" then
                print("Server - K pressed. Killing server.")
                    rednet.broadcast("!sysmsg Server is going down in 5...")
                    sleep(1)
                    rednet.broadcast("!sysmsg Server is going down in 4...")
                    sleep(1)
                    rednet.broadcast("!sysmsg Server is going down in 3...")
                    sleep(1)
                    rednet.broadcast("!sysmsg Server is going down in 2...")
                    sleep(1)
                    rednet.broadcast("!sysmsg Server is going down in 1...")
                    sleep(1)
                    rednet.broadcast("!sysmsg Server has been shut down.")
                error()
            end
	sleep(0)
      end
    end

    -- Wait for any...
    parallel.waitForAny(clientRequests, serverCommands)
