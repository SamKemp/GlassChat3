-- GlassChat 3 Client
-- By Tiiger87 and Alexandrov01


-- INITIALIZE SETTINGS
    --[[
        Variables explained:
        clientV = version
        clientID = PC ID
        clientM = modem
        clientB = bridge
        clientN = name
        clientS = chatroom
    ]]--

    clientV = "3.0.0 BETA"
    clientID = os.getComputerID()
   
    scroll = {}
    scrollEntries = 0

    startx = 20
    x = startx
    starty = 9
    y = starty
    z = 9               -- Space between lines
    maxlines = 10       -- Maximum amount of messages allowed in chat before scrolling
    startscroll = 99    -- start scroll at .. ?
    clientM = nil
    clientB = nil
    
    -- Checks if computer is an advanced computer
    if term.isColor() == false then
        print("ERROR: Not an advanced computer! Please check your computer setup.")
        error()
    end
    
    -- Gets terminal bridge and wired modem side
    sides = {"top", "bottom", "left", "right", "front", "back"}
    for key1, value1 in pairs(sides) do
        if peripheral.getType(value1)=="modem" then
            clientM = peripheral.wrap(value1)
            rednet.open(value1)
        elseif peripheral.getType(value1)=="openperipheral_glassesbridge" then
            clientB = peripheral.wrap(value1)
            clientB_side = value1
        end
    end
    
    -- Checks if modem and bridge are present.
    if clientM == nil or clientB == nil then
        term.setTextColor(colors.red)
        print("ERROR: Missing modem or bridge! Please check your computer setup.")
        term.setTextColor(colors.white)
        error()
    end
    clientB.clear()
    
    -- Get username from file
    if fs.exists("data/username") then
        usern = fs.open("data/username", "r")
            clientN = usern.readAll()
        usern.close()
        if clientN == "" then
            term.setTextColor(colors.red)
            print("ERROR: Empty username in data/username!")
            term.setTextColor(colors.white)
            error()
        end
    else
        term.setTextColor(colors.red)
        print("ERROR: Missing username file in data/username!")
        term.setTextColor(colors.white)
        error()
    end

    -- Get server cluster from file
    if fs.exists("data/chatroom") then
        servern = fs.open("data/chatroom", "r")
            clientS = tonumber ( servern.readAll() )
        servern.close()
        if clientS == "" then
            term.setTextColor(colors.red)
            print("ERROR: Empty server ID in data/chatroom!")
            term.setTextColor(colors.white)
            error()
        end
    else
        term.setTextColor(colors.red)
        print("ERROR: Missing server ID file in data/chatroom!")
        term.setTextColor(colors.white)
        error()
    end
    
    -- Print basic info to screen
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.yellow)
    print("GlassChat 3 Client "..clientV)
    term.setTextColor(colors.white)
    print("ID: "..clientID)
    print("Server: "..clientS)
    print("Name: "..clientN)
    print("----------------------")
    print("U: Update this client.")
    print("R: Restart this client.")
    print("K: Kill this client.")
    print("----------------------")
    
    -- Send Chat function
    function sendChat()
        while true do
            e, msg_raw = os.pullEvent("chat_command")
            msg_low = string.lower( msg_raw )
    
            if msg_low == "help" then
            -- soon to be help menu thingie still thinking about it
            
            elseif string.match(msg_low, "^gc") then
             
              if string.match(msg_low, 'reboot$') then
              	autoscroll("0xDAA520", "Rebooting your client...")
               rednet.send(clientS, "!gc leaving")
               sleep(1)
               shell.run("reboot")
             
              elseif string.match(msg_low, 'stop$') then
              	autoscroll("0xDAA520", "Stopping your client...")
               rednet.send(clientS, "!gc leaving")
               error("Exiting glasschat.")
               
              elseif string.match(msg_low, 'update$') then
              	autoscroll("0xDAA520", "Updating your client...")
               rednet.send(clientS, "!gc updating")
               shell.run("update")

              elseif string.match(msg_low, '^gc nick') then
               clientN = string.sub(msg_raw, 9)
               rednet.send(clientS, "!gc newusername "..clientN)

              else
              	autoscroll("0xDAA520", "Invalid command! Do $$help")
                table.insert(scroll, "Invalid command! Do $$help")
              end

            else
             rednet.send(clientS, msg_raw)
            end
         end
    end
    
    -- Receive Chat function
    function receiveChat()
      while true do
       senderID, message = rednet.receive()
       print(senderID.." - "..message)
       if string.match(message, "^!gc") then
        table.insert(scroll, "0xFFFF00"..message)
         if string.match(message, 'update$') then
         	autoscroll("0xFFFF00", "GlassChat Server - Updating your client...")
               rednet.send(clientS, "!gc updating")
               shell.run("update")
         elseif string.match(message, 'reboot$') then
         	autoscroll("0xFFFF00", "GlassChat Server - Rebooting your client...")
               rednet.send(clientS, "!gc leaving")
               sleep(1)
               shell.run("reboot")
          else
         end
       --elseif string.match(message, "^!sysmsg") then
        --table.insert(scroll, "0xFFFF00"..string.sub(message, 9))
        --text = clientB.addText(x, y, string.sub(message, 9), 0xFFFF00)
        --y = y + z
        --autoscroll()
       else
           autoscroll(message) --Passes the user message onto autoclear()
       end
     end
    end
    
    -- Autoscroll function
    function autoscroll(color, msg)
    	table.insert(scroll, color..msg)
        if scrollEntries >= maxlines then
         table.remove(scroll, 1)
          for key1, value1 in pairs(scroll) do
            _G[key1].setText( string.sub(value1, 9) )
          end
        else
        	newLine("0xFFFFFF", message)
        end
    end

    function newLine(color, msg)
    	_G[scrollEntries] = clientB.addText(x, y, msg, tonumber(color) )
    	scrollEntries = scrollEntries + 1
    	y = y + z
    end

    function changeTitle(title)
    	title.setText("GlassChat ".. clientV .." - "..title)
    end
    
    -- Refresh HUD function
    function refreshHUD()
      clientB.clear()
      y = starty
      x = startx
      scrollEntries = 0
      sleep(0.1)
      title = clientB.addText(x, y, "GlassChat ".. clientV .." - Do $$(msg) to chat!", 0xFFFF00)
      y = y + z
    end
    
    -- Local commands function
    function localCommands()
        while true do
             local evt, c = os.pullEvent("char") -- wait for a key press
             c = string.lower(c) -- convert to lower case, to register both r & R.
                if c == "r" then
                    print("Client - R pressed. Restarting this client.")
                        rednet.send(clientS, "!gc leaving")
                        sleep(1)
                        os.reboot()
                elseif c == "u" then
                    print("Client - U pressed. Updating this client.")
                        rednet.send(clientS, "!gc updating")
                        sleep(1)
                        shell.run("update")
                elseif c == "k" then
                    print("Client - K pressed. Killing this client.")
                        rednet.send(clientS, "!gc leaving")
                        sleep(1)
                        error()
                end
            sleep(0)
        end
    end
    
    --Send name to server
    rednet.send(clientS, "!gc username "..clientN)
    
    -- Refresh HUD
    refreshHUD()
    
    -- Wait for any function
    parallel.waitForAny(sendChat, receiveChat, localCommands)



-- End of GlassChat Client file...