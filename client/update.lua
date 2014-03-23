-- GlassChat 3 Client Update
-- By Tiiger87 and Alexandrov01

 sides = {"top", "bottom", "left", "right", "front", "back"}
    for key1, value1 in pairs(sides) do
        if peripheral.getType(value1)=="openperipheral_glassesbridge" then
            clientB = peripheral.wrap(value1)
        end
    end

clientB.clear()
text = clientB.addText(x, y, "GlassChat is updating!", 0xFFFF00)

term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.yellow)
print("Client Updater v2")
term.setTextColor(colors.white)
print("")

print("1. Fetching /client/startup.lua from GitHub...")
    startupGet = http.get("https://raw.github.com/lesander/GlassChat3/master/client/startup.lua")
print("   Done!")

print("2. Updating startup...")
    file = fs.open("startup", "w")
    file.write( startupGet.readAll() )
    file.close()
print("   Done!")

print("3. Fetching /client/update.lua from GitHub...")
    updateGet = http.get("https://raw.github.com/lesander/GlassChat3/master/pastebin-files/pastebin-install-client.lua")
print("   Done!")

print("4. Updating update...")
    file = fs.open("update", "w")
    file.write( updateGet.readAll() )
    file.close()
print("   Done!")

print("5. Creating data folder...")
    shell.run("mkdir", "data")
print("   Done!")

print("6. Username:")
function setUsername()
    print("   Enter a username: ")
    givenUser = read()
    if givenUser == "" then
        print("   No username given!")
        setUsername()
    else
        setUser = fs.open("data/username", "w")
        setUser.write(givenUser)
        setUser.close()
        print("   Username set to "..givenUser)
        print("   Done!")
    end
end
if fs.exists("data/username") then
    print("   Already exists!")
    print("   Done!")
else
    setUsername()
end

print("7. Server Cluster")
function setServer()
    print("   Enter Server ID: ")
    givenServer = read()
    if givenServer == "" then
        print("   No server ID given!")
        setServer()
    else
        setServer = fs.open("data/chatroom", "w")
        setServer.write(givenServer)
        setServer.close()
        print("   Server set to "..givenServer)
        print("   Done!")
    end
end
if fs.exists("data/chatroom") then
    print("   Already exists!")
    print("   Done!")
else
    setServer()
end
term.setTextColor(colors.yellow)
print("Update complete.")
term.setTextColor(colors.white)
