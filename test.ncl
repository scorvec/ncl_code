begin

f1=addfile("gdps-rdps_par_diff_spring_2019_pr.nc","r")
;temp=f1->UU(0,{250},:,:)
print("hello")
temp=f1->PR(0,:,:)
lat2d=f1->lat
lon2d=f1->lon
nlat  = dimsizes(lat2d(:,0))
nlon  = dimsizes(lon2d(0,:))

wtype          = "png"
wtype@wkWidth  = 2500
wtype@wkHeight = 2500

wks  = gsn_open_wks(wtype, "PR_diff_NA")     ; send graphics to PNG file~
res                        = True             ; plot mods desired
print("hello")
res@gsnMaximize            = True             ; maxmize plot in frame
res@cnFillOn               = True             ; turn on color 
res@cnLinesOn              = False            ; no contour lines
res@cnLineLabelsOn         = False            ; no contour labels
res@cnFillPalette          = "MPL_BrBG"
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
  res@mpMinLatF                = 30.0
  res@mpMaxLatF                = 60.0
  res@mpMaxLonF                = -50.0
  res@mpMinLonF                =-130.0
  res@mpGeophysicalLineThicknessF = 3.0
  res@pmLabelBarOrthogonalPosF = 0.05
  res@gsnCenterString             = "GDPS-RDPS PAR PR difference - 48 hour forecasts (mm) - March 5 - May 15, 2019"
  res@gsnMaximize = True
  ;res@cnMaxLevelCount      = 10
  ;res@cnLevelSelectionMode = "EqualSpacedLevels" ; equally spaced contour levels
  res@cnLevelSelectionMode = "ManualLevels" ; manual levels
 ;  res@cnLevelSelectionMode = "ExplicitLevels" 
;  res@cnLevels=(/-10,-7.5,-5,-4.5,-4,-3.5,-3,-2.75,-2.5,-2.25,-2.0,-1.75,-1.5,-1.25,-1.0,-0.75,-0.5,0,0.5,0.75,1.0,1.25,1.5,1.75,2.0,2.25,2.5,2.75,3.0,3.25,3.5,4.0,4.5,5.0,7.5,10.0/)
  res@cnLevelSpacingF = 0.5
  res@cnMaxLevelValF=5
  res@cnMinLevelValF=-5
;  res@lbTitleString    = "dam"
  res@gsnCenterStringFontHeightF = 0.012
  res@mpProjection      = "Orthographic" 
  res@lbOrientation =   "horizontal"      
  res@mpCenterLonF      = -100.             ; choose center lon
  res@mpCenterLatF      = 50.               ; choose center lat
;  res@vpHeightF            = 0.03
;  res@vpWidthF             = 0.4
   res@lbTitleFontHeightF= .015                ; make title smaller
   res@lbLabelFontHeightF   =0.01 
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
  cmd = "convert -trim -geometry 2500x2500 +repage -border 8 -bordercolor white -background white -flatten PR_diff.png PR_diff.png"
   system(cmd)
end
