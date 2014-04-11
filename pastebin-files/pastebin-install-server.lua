-- GlassChat 3 Server Pastebin Updater/Installer
-- By Tiiger87 and Alexandrov01

-- Change the variable branch to 'master' if you want to disable the dev-builds.
branch = "testing"
getfile = http.get("https://raw.github.com/AxTo/GlassChat3/"..branch.."/server/update.lua")
print("Got update file from github...")
file = fs.open("temp-update", "w")
    file.write( getfile.readAll() )
file.close()
print("Created temp file...")
print("Running temp file...")
shell.run("temp-update")
sleep(1)
shell.run("rm", "temp-update")
print("Temp file removed. Now rebooting...")
sleep(3)
os.reboot()