begin

f=addfile("/home/smc001/hall1/20190711/p3/2019071112_001_1km.nc","r")
p0=f->P0(:,:,:)
h=f->GZ(:,::-1,:,:)
q=f->HU_vgrid5(:,::-1,:,:)
t=f->TT_vgrid5(:,::-1,:,:)
p=f->PX_vgrid5(:,::-1,:,:)

t=273.15+t
h=10*h
p=p*100
q=q/1000
hsfc=h(0,0,:,:)

lat2d=f->lat
lon2d=f->lon
nlat  = dimsizes(lat2d(:,0))
nlon  = dimsizes(lon2d(0,:))

print("pressure")
print(dimsizes(p))
print("humidity")
print(dimsizes(q))
print("temp")
print(dimsizes(t))
print("height surface")
print(dimsizes(hsfc))
print("surface presusre")
print(dimsizes(p0))


cape=wrf_cape_3d(p(0,:,40:100,40:100),q(0,:,40:100,40:100),t(0,:,40:100,40:100),h(0,1:114:2,40:100,40:100),hsfc(40:100,40:100),p0(0,40:100,40:100),True)


print(max(cape))
print("done")



end
exit
