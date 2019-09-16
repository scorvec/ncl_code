begin

f=addfile("zz_hrdps.nc","r")
ZZ=f->ZZ(:,:,:,:)
lat2d=f->lat
lon2d=f->lon
nlat  = dimsizes(lat2d(:,0))
nlon  = dimsizes(lon2d(0,:))

ZZmaxtime=dim_max_n(ZZ,0)
ZZmax=dim_max_n(ZZmaxtime,0)

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
 date=getenv("ncldate")
 print(date)
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
  res@gsnCenterString             = "Max upward velocity in past hour (m/s) - max value = " + max(ZZmax) + " m/s " + date
  res@gsnMaximize = True
   res@cnLevelSelectionMode = "ExplicitLevels" 
  res@cnLevels=(/0,1,2,3,4,5,10,15,20,25,30,35,40,45,50,60,70,80/)
  cmap=read_colormap_file("radar_1")
cmap(0:5,:)=1.
res@cnFillPalette          = cmap
  res@gsnCenterStringFontHeightF = 0.008
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
   plot_nonnative = gsn_csm_contour_map (wks,ZZmax,res)
   delete(wks)
  cmd = "convert -trim -geometry 2500x2500 +repage -border 8 -bordercolor white -background white -flatten uh_west.png uh_west.png"
   system(cmd)
end
