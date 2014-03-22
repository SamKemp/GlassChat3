-- GlassChat 3 Client By tiiger87 and alexandrov01

clientM = nil
clientB = nil

--Gets terminal bridge and wired modem side
for k,v in pairs(redstone.getSides()) do
 if peripheral.getType(v)==modem then
  clientM = peripheral.wrap(v)
 elseif peripheral.getType(v)==openperipheral_glassesbridge then
  clientB = peripheral.wrap(v)
 end
end

if clientM == nil or clientB = nil then
 print("Missing modem or bridge! Please check your computer setup")
end
