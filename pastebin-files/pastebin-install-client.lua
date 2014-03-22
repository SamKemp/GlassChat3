-- GlassChat 3 Client Pastebin Updater/Installer
-- By Tiiger87 and Alexandrov01
getfile = http.get("https://raw.github.com/lesander/GlassChat3/master/pastebin-files/pastebin-install-client.lua")
file = fs.open("temp-update", "w")
    file.write( getfile.readAll() )
file.close()
shell.run("temp-update")
sleep(1)
shell.run("rm", "temp-update")