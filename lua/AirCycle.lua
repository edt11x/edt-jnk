print("Air Cycle Computation of HP")
cycles = 2
print("Number of Engine Cycles (2 or 4)")
cycles = io.read("*number")
press = 29.92
print("Barometric Pressure in inHg (29.92 std)")
press = io.read("*number")
press = press/(29.92)*14.695948775513
boost = 0
print("Super/Turbo Charger Boost in psi(0)")
boost = io.read("*number")
press = boost + press
intemp = 60
sv = 250
print("Engine Displacement in cc's")
sv = io.read("*number")
rpm = 6800
print("RPM for Horsepower")
rpm = io.read("*number")
intemp = 60
print("Intake Temperature in Farenheight (60 F)")
intemp = io.read("*number")
intemp = intemp + 460
cr = 10
print("Effective Compression Ratio (10)")
cr = io.read("*number")
print("Fuel Energy in BTUs/lb")
print("VP C-12  = 18,834 BTUs/lb")
print("Pump Gas = 17,920 BTUs/lb")
print("Methonal =  8,568 BTUs/lb")
btuslb = 18834
btuslb = io.read("*number")
