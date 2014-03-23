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
    startx = 20
    x = startx
    starty = 9
    y = starty
    z = 9              --Space between lines
    maxlines = 10   --Maximum amount of messages allowed in chat before scrolling
   startscroll = 99
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
    
    
    -- Opens rednet modem
   -- clientM.open(clientM_side)
    
    
    -- Get username from server
    
    
    
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

function sendChat()
    while true do
        e, msg_raw = os.pullEvent("chat_command")
        msg_low = string.lower( msg_raw )

        if msg_low == "help" then
        -- soon to be help menu thingie still thinking about it
        
        elseif string.match(msg_low, "^gc") then
         
          if string.match(msg_low, 'reboot$') then
           text = clientB.addText(x, y, "GlassChat ".. clientV .." - Rebooting your client...", 0xDAA520)
           y = y + z
           rednet.send(clientS, "!gc leaving")
           sleep(1)
           shell.run("reboot")
         
          elseif string.match(msg_low, 'stop$') then
           text = clientB.addText(x, y, "GlassChat ".. clientV .." - Stopping your client...", 0xDAA520)
           y = y + z
           rednet.send(clientS, "!gc leaving")
           error("Exiting glasschat.")
           
          elseif string.match(msg_low, 'update$') then
           text = clientB.addText(x, y, "GlassChat ".. clientV .." - Updating your client", 0xFFFF00)
           y = y + z
           rednet.send(clientS, "!gc updating")
           shell.run("update")
          elseif string.match(msg_low, '^gc nick') then
           clientN = string.sub(msg_raw, 9)
           rednet.send(clientS, "!gc newusername "..clientN)
          else
           text = clientB.addText(x, y, "Invalid command! Do $$help", 0xDAA520)
           table.insert(scroll, "Invalid command! Do $$help")
           y = y + z
          end
        else
         rednet.send(clientS, msg_raw)
        end
     end
end

function receiveChat()
  while true do
   senderID, message = rednet.receive()
   print(message)
   table.insert(scroll, message)
   if y >= startscroll then
    refreshHUD()
    table.remove(scroll, 1)
      for key1, value1 in pairs(scroll) do
        text = clientB.addText(x, y, value1, 0xFFFFFF)
        y = y + z
      end
    else
     text = clientB.addText(x, y, message, 0xFFFFFF)
     y = y + z
    end
 end
end

--function autoscroll()
  
-- end


function refreshHUD()
 clientB.clear()
  y = starty
  x = startx
  text = clientB.addText(x, y, "GlassChat ".. clientV .." - Do $$(msg) to chat!", 0xFFFF00)
  y = y + z
end

--Sends name to server
rednet.send(clientS, "!gc username "..clientN)

refreshHUD()

parallel.waitForAny(sendChat, receiveChat)
