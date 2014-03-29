-- GlassChat 3 Server Update
-- By Tiiger87 and Alexandrov01

term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.yellow)
print("Server Updater")
term.setTextColor(colors.white)
print("")

print("Fetching /server/startup.lua from GitHub...")
    startupGet = http.get("https://raw.github.com/lesander/GlassChat3/master/server/startup.lua")
print("  Done!")

print("Updating startup...")
    file = fs.open("startup", "w")
    file.write( startupGet.readAll() )
    file.close()
print("  Done!")

print("startup file updated!")

print("Fetching /server/update.lua from GitHub...")
    updateGet = http.get("https://raw.github.com/lesander/GlassChat3/master/pastebin-files/pastebin-install-server.lua")
print("  Done!")

print("Updating update...")
    file = fs.open("update", "w")
    file.write( updateGet.readAll() )
    file.close()
print("  Done!")

print("update file updated!")

print("Creating data folder...")
    shell.run("mkdir", "data")
print("   Done!")

print("Enter computer monitor ID (leave empty to skip):")
    function readMonID()
        monID = read()
        if monID == nil then
            print("Computer monitor ID setup skipped.")
            print("   Done!")
        else
            print("Saved monitor ID!")
            file = fs.open("data/monitor", "w")
            file.write( monID.readAll() )
            file.close()
            print("   Done!")
        end
    end
    readMonID()

print("Update complete.")