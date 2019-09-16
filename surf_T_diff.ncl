begin
   f=addfile("hrdps-hrrr_surfT.nc","r") 
   Z=f->I0(0,0,:,:)
   lat2d=f->lat(::4,::4)
   lon2d=f->lon(::4,::4)
   wtype          = "png"
   wtype@wkWidth  = 2500
   wtype@wkHeight = 2500

   wks  = gsn_open_wks(wtype, "surfT_diff")     ; send graphics to PNG file~ 
   res                        = True             ; plot mods desired
   res@gsnMaximize            = True             ; maxmize plot in frame
   res@cnFillOn               = True             ; turn on color 
   res@cnLinesOn              = False            ; no contour lines
   res@cnLineLabelsOn         = False            ; no contour labels
   res@gsnAddCyclic           = False


  res@mpProjection      = "Orthographic" 
  res@gsnMaximize        = True                   ; use full page
  res@vpYF = 0.85
  res@mpOutlineOn           = True
  res@mpOutlineBoundarySets = "AllBoundaries"
  res@mpDataBaseVersion     = "MediumRes"   ; necessary for mpDataSetName to be effective
  res@mpDataSetName= "Earth..4"
  res@cnRasterSmoothingOn="True"
    res@mpCenterLonF      = -100.             ; choose center lon
  res@mpCenterLatF      = 50.               ; choose center lat
     res@cnLevelSelectionMode = "ExplicitLevels" 
   res@cnLevels=(/-5,-4,-3.5,-3,-2.5,-2,-1.5,-1,-0.5,0.5,1,1.5,2,2.5,3,3.5,4,5/)
   res@cnFillColors=(/0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18/)
  res@sfXArray                 = lon2d    ; needed for non-native
  res@sfYArray                 = lat2d    ; contouring
    res@mpLimitMode="LatLon"

  res@mpMinLatF                = 37.0
  res@mpMaxLatF                = 50.0
  res@mpMaxLonF                = -60.0
  res@mpMinLonF                =-130.0
  res@trGridType="TriangularMesh"
  res@cnFillPalette          = "temp_19lev"
  
    date=getenv("ncldate")
    print(date)
    res@gsnCenterString             = "HRDPS minus HRRR surface skin temperature " + date
   plot_nonnative = gsn_csm_contour_map (wks,Z(::4,::4),res)
   print("done plotting")
   delete(wks)
   cmd = "convert -trim -geometry 2500x2500 +repage -border 8 -bordercolor white -background white -flatten surfT_diff.png surfT_diff.png"
   system(cmd)
  
   
end
exit
