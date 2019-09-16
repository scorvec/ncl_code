begin

;f=addfile("MRMS_prevday.grb","r")
;Z=f->CONUSPlusMergedReflectivityQC_P0_L102_GLL0
f=addfile("MRMS_prevday.nc","r")
Z=f->ConusPlusMergedReflectivityQC_1000mabovemeansealevel
Z@_FillValue = -999 ; set missing value  



lat2d=f->latitude
lon2d=f->longitude
;nlat  = dimsizes(lat2d(:,0))
;nlon  = dimsizes(lon2d(0,:))

Z@description = ""
Z@units = "" 
Z@long_name=""
wtype          = "png"
wtype@wkWidth  = 2500
wtype@wkHeight = 2500

wks  = gsn_open_wks(wtype, "mrms")     ; send graphics to PNG file~
res                        = True             ; plot mods desired
print(dimsizes(Z))
res@gsnMaximize            = True             ; maxmize plot in frame
res@cnFillOn               = True             ; turn on color 
res@cnLinesOn              = False            ; no contour lines
res@cnLineLabelsOn         = False            ; no contour labels

cmap=read_colormap_file("radar_1")
cmap(0:7,:)=1.
res@cnFillPalette          = cmap
res@lbOrientation          = "Vertical"       ; vertical labelbar
res@pmLabelBarOrthogonalPosF = 0.18           ; move lbar away from plot

res@gsnAddCyclic           = False

;------------------------------------------------------------
; Second frame: use lat2d/lon2d coordinates to plot 
; the data.
;------------------------------------------------------------
  res@sfXArray                 = lon2d(::2)    ; needed for non-native
  res@sfYArray                 = lat2d(::2)    ; contouring
  res@mpLimitMode="LatLon"
  res@mpMinLatF                = 35.0
  res@mpMaxLatF                = 50.0
  res@mpMaxLonF                = -60.0
  res@mpMinLonF                =-90.0
  res@mpGeophysicalLineThicknessF = 3.0
  res@pmLabelBarOrthogonalPosF = 0.05
 time=f->time
  res@gsnCenterString             = "MRMS merged QC'd 1km CAPPI " + time@reference_date
  res@gsnMaximize = True
  
   res@cnLevelSelectionMode = "ExplicitLevels" 
  ;res@cnLevels=(/-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75/)
   res@cnLevels=(/-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75/)
 res@trGridType="TriangularMesh"
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
  res@mpDataSetName= "Earth..4"
  res@cnRasterSmoothingOn="True"
  res@cnFillMode="RasterFill"	
  res@pmLabelBarOrthogonalPosF = -0.15
   plot_nonnative = gsn_csm_contour_map (wks,Z(0,::2,::2),res)
   
   delete(wks)
  cmd = "convert -trim -geometry 2500x2500 +repage -border 8 -bordercolor white -background white -flatten mrms.png mrms.png"
   system(cmd)
end
exit
