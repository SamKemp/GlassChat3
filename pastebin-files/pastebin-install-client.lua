-- GlassChat 3 Client Pastebin Updater/Installer
-- By Tiiger87 and Alexandrov01
getfile = http.get("https://raw.github.com/lesander/GlassChat3/master/client/update.lua")
print("Got update file from github...")
file = fs.open("temp-update", "w")
    file.write( getfile.readAll() )
file.close()
print("Created temp file...")
print("Running temp file...")
shell.run("temp-update")
sleep(1)
shell.run("rm", "temp-update")