begin

f=addfile("3dwind_hrdps.nc","r")
ZZ=f->ZZ(0,::-1,:,:)
GZ=f->GZ(0,::-1,:,:)
VV=f->VV_grid_44033_34538_1_0(0,::-1,:,:)
UU=f->UU_grid_44033_34538_1_0(0,::-1,:,:)

ZZ1=f->ZZ(1,::-1,:,:)
GZ1=f->GZ(1,::-1,:,:)
VV1=f->VV_grid_44033_34538_1_0(1,::-1,:,:)
UU1=f->UU_grid_44033_34538_1_0(1,::-1,:,:)

lat2d=f->lat_1
lon2d=f->lon_1
nlat  = dimsizes(lat2d(:,0))
nlon  = dimsizes(lon2d(0,:))

mapfact=new((/1310,2560/),float,1.0) ; 

opt         = True
opt@uhmnhgt = 1000.
opt@uhmxhgt = 6000.

uh=1E-3*wrf_updraft_helicity(98*GZ(1:124:2,:,:),mapfact,0.51444*UU,0.51444*VV,ZZ,2500,2500,opt)
uh1=1E-3*wrf_updraft_helicity(98*GZ1(1:124:2,:,:),mapfact,0.51444*UU1,0.51444*VV1,ZZ1,2500,2500,opt)
uh2=where(uh.gt.uh1,uh,uh1)

print(max(uh))
print(max(uh1))
print(max(uh2))
print(max(ZZ))

wtype          = "png"
wtype@wkWidth  = 2500
wtype@wkHeight = 2500

wks  = gsn_open_wks(wtype, "uh_west")     ; send graphics to PNG file~
res                        = True             ; plot mods desired

res@lbOrientation          = "Vertical"       ; vertical labelbar
res@pmLabelBarOrthogonalPosF = 0.18           ; move lbar away from plot
 
res@mpDataBaseVersion      = "MediumRes"      ; use finer database
 
res@gsnAddCyclic           = False

;------------------------------------------------------------
; Second frame: use lat2d/lon2d coordinates to plot 
; the data.
;------------------------------------------------------------

res@cnFillOn               = True             ; turn on color 
res@cnLinesOn              = False            ; no contour lines
res@cnLineLabelsOn         = False            ; no contour labels
  res@sfXArray                 = lon2d    ; needed for non-native
  res@sfYArray                 = lat2d    ; contouring
  res@mpLimitMode="LatLon"
  
  res@mpMinLatF                = 40.0
  res@mpMaxLatF                = 60.0
  res@mpMaxLonF                = -90.0
  res@mpMinLonF                =-125.0
  res@mpGeophysicalLineThicknessF = 3.0
  res@pmLabelBarOrthogonalPosF = 0.05
  res@gsnCenterString             = "Updraft helicity"
  res@gsnMaximize = True
   res@cnLevelSelectionMode = "ExplicitLevels" 
  res@cnLevels=(/0,2,5,10,20,40,60,80,100,120,150,200/)
  cmap=read_colormap_file("radar_1")
cmap(0:2,:)=1.
res@cnFillPalette          = cmap
  res@gsnCenterStringFontHeightF = 0.012
  res@mpProjection      = "Orthographic" 
  res@lbOrientation =   "horizontal"      
  res@mpCenterLonF      = -100.             ; choose center lon
  res@mpCenterLatF      = 50.               ; choose center lat
   res@lbTitleFontHeightF= .015                ; make title smaller
   res@lbLabelFontHeightF   =0.005 
     res@gsnMaximize        = True                   ; use full page
  res@vpYF = 0.85
    res@mpOutlineOn           = True
  res@mpOutlineBoundarySets = "AllBoundaries"
  res@mpDataBaseVersion     = "MediumRes"   ; necessary for mpDataSetName to be effective
  res@mpLandFillColor       = "bisque2"
  res@mpDataSetName= "Earth..4"

  res@pmLabelBarOrthogonalPosF = -0.15
   plot_nonnative = gsn_csm_contour_map (wks,uh2,res)
end