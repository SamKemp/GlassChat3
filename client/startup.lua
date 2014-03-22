-- GlassChat 3 Client By tiiger87 and alexandrov01

--Checks if computer is an advnaced computer, if not then the script gets halted
if term.isColor() == false then
 print("Not an advanced computer! Please check your computer setup")
 os.exit()
end

clientM = nil
clientB = nil

--Gets terminal bridge and wired modem side, if one of them is not detected the script gets halted
for k,v in pairs(redstone.getSides()) do
 if peripheral.getType(v)==modem then
  clientM = peripheral.wrap(v)
 elseif peripheral.getType(v)==openperipheral_glassesbridge then
  clientB = peripheral.wrap(v)
 end
end

if clientM == nil or clientB = nil then
 print("Missing modem or bridge! Please check your computer setup")
 os.exit()
end
