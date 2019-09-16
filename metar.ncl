begin

f=addfile("surface.nc","r")
f1=addfile("hrdps_screen.nc","r")

points=f->temperature
data=f1->TT

lat=f->latitude
lon=f->longitude
points@lat=lat
points@lon=lon

lon2d=f1->lon
lat2d=f1->lat

test=rcm2points(lat2d,lon2d,data,lat,lon,0)
print("done")

print(dimsizes(test))
print(dimsizes(points))
diff=test(0,0,:)-(points-273.15)
print(avg(diff))

end
exit
