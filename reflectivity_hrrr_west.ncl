begin

f1=addfile("hrrr_zet.grib2","r")

;varnames = getfilevarnames(f1)
;print(f1)
temp=f1->REFD_P0_L103_GLC0({1000},:,:)
print("hello")
;temp=f1->(0,:,:)
lat2d=f1->gridlat_0
lon2d=f1->gridlon_0
nlat  = dimsizes(lat2d(:,0))
nlon  = dimsizes(lon2d(0,:))

temp@description = ""
temp@units = ""
temp@long_name=""

wtype          = "png"
wtype@wkWidth  = 2500
wtype@wkHeight = 2500

wks  = gsn_open_wks(wtype, "hrrr_zet_1km_west")     ; send graphics to PNG file~
res                        = True             ; plot mods desired
print("hello")
res@gsnMaximize            = True             ; maxmize plot in frame
res@cnFillOn               = True             ; turn on color 
res@cnLinesOn              = False            ; no contour lines
res@cnLineLabelsOn         = False            ; no contour labels
;res@cnFillPalette          = "radar_1"
cmap=read_colormap_file("radar_1")
cmap(0:7,:)=1.
res@cnFillPalette          = cmap
res@lbOrientation          = "Vertical"       ; vertical labelbar
res@pmLabelBarOrthogonalPosF = 0.18           ; move lbar away from plot
 
res@mpDataBaseVersion      = "MediumRes"      ; use finer database
 
res@gsnAddCyclic           = False

;------------------------------------------------------------
; Second frame: use lat2d/lon2d coordinates to plot 
; the data.
;------------------------------------------------------------

  res@sfXArray                 = lon2d    ; needed for non-native
  res@sfYArray                 = lat2d    ; contouring
  res@mpLimitMode="LatLon"
  res@mpMinLatF                = 40.0
  res@mpMaxLatF                = 60.0
  res@mpMaxLonF                = -90.0
  res@mpMinLonF                =-125.0
  res@mpGeophysicalLineThicknessF = 3.0
  res@pmLabelBarOrthogonalPosF = 0.05
 res@gsnCenterString             = "HRRR 1km AGL reflectivity" + " t+" + temp@forecast_time + " initialized " + temp@initial_time
  res@gsnMaximize = True
  ;res@cnMaxLevelCount      = 10
  ;res@cnLevelSelectionMode = "EqualSpacedLevels" ; equally spaced contour levels
  ;res@cnLevelSelectionMode = "ManualLevels" ; manual levels
   res@cnLevelSelectionMode = "ExplicitLevels" 
  res@cnLevels=(/-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75/)
  ;res@cnLevelSpacingF = 0.5
  ;res@cnMaxLevelValF=5
  ;res@cnMinLevelValF=-5
;  res@lbTitleString    = "dam"
  res@gsnCenterStringFontHeightF = 0.012
  res@mpProjection      = "Orthographic" 
  res@lbOrientation =   "horizontal"      
  res@mpCenterLonF      = -100.             ; choose center lon
  res@mpCenterLatF      = 50.               ; choose center lat
;  res@vpHeightF            = 0.03
;  res@vpWidthF             = 0.4
   res@lbTitleFontHeightF= .015                ; make title smaller
   res@lbLabelFontHeightF   =0.005 
     res@gsnMaximize        = True                   ; use full page
;  res@gsnPanelBottom     = 0.02                   ; save space at bottom
;   res@mpMinLatF                = 15.0
;  res@mpMaxLatF                = 80.0
;  res@mpMaxLonF                = -30.0
;  res@mpMinLonF                =-170.0
  res@vpYF = 0.85
    res@mpOutlineOn           = True
  res@mpOutlineBoundarySets = "AllBoundaries"
  res@mpDataBaseVersion     = "MediumRes"   ; necessary for mpDataSetName to be effective
  res@mpLandFillColor       = "bisque2"
  res@mpDataSetName= "Earth..4"

  res@pmLabelBarOrthogonalPosF = -0.15
   plot_nonnative = gsn_csm_contour_map (wks,temp,res)
print("hello")
   delete(wks)
  cmd = "convert -trim -geometry 2500x2500 +repage -border 8 -bordercolor white -background white -flatten hrrr_zet_1km_west.png hrrr_zet_1km_west.png"
   system(cmd)
end
