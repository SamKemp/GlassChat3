-- GlassChat 3 Client Update
-- By Tiiger87 and Alexandrov01

term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.yellow)
print("Client Updater")
term.setTextColor(colors.white)
print("")

print("Fetching /client/startup.lua from GitHub...")
    startupGet = http.get("https://raw.github.com/lesander/GlassChat3/master/client/startup.lua")
print("  Done!")

print("Updating startup...")
    file = fs.open("startup", "w")
    file.write( startupGet.readAll() )
    file.close()
print("  Done!")

print("startup file updated!")

print("Fetching /client/update.lua from GitHub...")
    updateGet = http.get("https://raw.github.com/lesander/GlassChat3/master/client/update.lua")
print("  Done!")

print("Updating update...")
    file = fs.open("update", "w")
    file.write( updateGet.readAll() )
    file.close()
print("  Done!")

print("update file updated!")

print("Rebooting!")
sleep(2)

os.reboot()