begin

f=addfile("MRMS_QPE_HRDPS_grid_prevday_west_masked_qi.nc","r")
Z=f->RadarQualityIndex_0mabovemeansealevel(0,:,:)

Z@_FillValue = -3 ; set missing value  

;nlat  = dimsizes(lat2d(:,0))
;nlon  = dimsizes(lon2d(0,:))
Z@long_name=""
Z@units=""

lat2d=f->lat
lon2d=f->lon

wtype          = "png"
wtype@wkWidth  = 2500
wtype@wkHeight = 2500

wks  = gsn_open_wks(wtype, "mrms_west")     ; send graphics to PNG file~
res                        = True             ; plot mods desired
print(dimsizes(Z))
res@gsnMaximize            = True             ; maxmize plot in frame
res@cnFillOn               = True             ; turn on color 
res@cnLinesOn              = False            ; no contour lines
res@cnLineLabelsOn         = False            ; no contour labels
cmap=read_colormap_file("NCV_jaisnd")
cmap(0:1,:)=1.
res@cnFillPalette          = cmap

;res@cnFillPalette          = "NCV_jaisnd"
res@lbOrientation          = "Vertical"       ; vertical labelbar
res@pmLabelBarOrthogonalPosF = 0.18           ; move lbar away from plot

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
  
   date=getenv("ncldateprevrad")
   print(date)
  
  res@gsnCenterString             = "MRMS 1 hour radar estimated precipitation (gauge corrected) valid " + date + " (mm) "
  res@gsnMaximize = True
  
   res@cnLevelSelectionMode = "ExplicitLevels" 
  ;res@cnLevels=(/-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75/)
   res@cnLevels=(/0.1,1,2.5,5,7.5,10,12.5,15,20,25,30,40,50,75,100/)
 res@trGridType="TriangularMesh"
res@cnMissingValFillColor="grey78"
  res@gsnCenterStringFontHeightF = 0.01
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

  res@pmLabelBarOrthogonalPosF = -0.15
  print("plotting")
   plot_nonnative = gsn_csm_contour_map (wks,Z,res)
   print("done plotting")
   delete(wks)
   cmd = "convert -trim -geometry 2500x2500 +repage -border 8 -bordercolor white -background white -flatten mrms_west.png mrms_west.png"
   system(cmd)
   
   f1=addfile("1hr_pr_accum_hrdps_west.nc","r") 
   Z1=f1->PR(3,:,:)

   Z1@long_name=""
   ;Z1=Z1*1000 ; convert metres to mm
   lat2d_hrdps=f1->lat
   lon2d_hrdps=f1->lon
  
   wtype          = "png"
   wtype@wkWidth  = 2500
   wtype@wkHeight = 2500

   wks  = gsn_open_wks(wtype, "hrdps_1hr_pr_west")     ; send graphics to PNG file~ 
   
   res@sfXArray                 = lon2d_hrdps    ; needed for non-native
   res@sfYArray                 = lat2d_hrdps   ; contouring
   date=getenv("ncldateprev")
   print(date)
   
   res@gsnCenterString             = "HRDPS 1 hour QPF " + date + " (mm) "
   
   plot_nonnative = gsn_csm_contour_map (wks,Z1,res)
   print("done plotting")
   delete(wks)
   cmd = "convert -trim -geometry 2500x2500 +repage -border 8 -bordercolor white -background white -flatten hrdps_1hr_pr_west.png hrdps_1hr_pr_west.png"
   system(cmd)
  
   f2=addfile("hrdps_mrms_1hr_qpe_west_diff_masked.nc","r") 
   Z2=f2->PR(0,:,:)
   
   wtype          = "png"
   wtype@wkWidth  = 2500
   wtype@wkHeight = 2500

   wks  = gsn_open_wks(wtype, "mrms_verif_1hr_west")     ; send graphics to PNG file~ 
   
   res@sfXArray                 = lon2d_hrdps    ; needed for non-native
   res@sfYArray                 = lat2d_hrdps   ; contouring
   delete(res@cnFillPalette)
   delete(res@cnLevels)
   delete(cmap)
   res@cnFillPalette          = "temp_19lev"
   
   ;;;Apply MRMS missing value mask to HRDPS data!!!! Very important!;;;
   maskedhrdps=mask(Z1,(Z.lt.1e30),True)
   ;;;
   
   hitsarray=new((/dimsizes(Z1)/),integer) ; hits array
   faarray=new((/dimsizes(Z1)/),integer) ; false-alarms array
   missesarray=new((/dimsizes(Z1)/),integer) ; misses array
   noeventarray=new((/dimsizes(Z1)/),integer) ; no event obs or fcst array

   hitsarray=where(maskedhrdps.ge.1.0 .and. Z.ge.1.0, 1,0)
   hits=num(hitsarray.eq.1)

   faarray=where(maskedhrdps.ge.1.0 .and. Z.lt.1.0, 1,0)
   fa=num(faarray.eq.1)

   missesarray=where(Z.ge.1.0 .and. maskedhrdps.lt.1.0, 1,0)
   misses=num(missesarray.eq.1)
   
   noeventarray=where(Z.lt.1.0 .and. maskedhrdps.lt.1.0, 1,0)
   nil=num(noeventarray.eq.1)
   
   if((hits+misses+fa).eq.0) then
    ts1=0
   else
    ts1=tofloat(hits)/(hits+misses+fa)
   end if
   
   if(num(Z.gt.1.).eq.0) then
    fbi1=0
   else
    fbi1=tofloat((num(maskedhrdps.gt.1.)))/(num(Z.gt.1.))
   end if
   
   if((hits+fa).eq.0) then
    far1=0
   else
    far1=tofloat(fa)/(hits+fa)
   end if
   
   pod1=tofloat(nil)/(fa+nil)
   
   hitsarray=where(maskedhrdps.ge.10. .and. Z.ge.10., 1,0)
   hits=num(hitsarray.eq.1)

   faarray=where(maskedhrdps.ge.10. .and. Z.lt.10., 1,0)
   fa=num(faarray.eq.1)

   missesarray=where(Z.ge.10. .and. maskedhrdps.lt.10., 1,0)
   misses=num(missesarray.eq.1)
   
   noeventarray=where(Z.lt.10. .and. maskedhrdps.lt.10., 1,0)
   nil10=num(noeventarray.eq.1)
   
   if((hits+misses+fa).eq.0) then
    ts10=0
   else
    ts10=tofloat(hits)/(hits+misses+fa)
   end if
   
   if(num(Z.gt.10.).eq.0) then
    fbi10=0
   else
    fbi10=tofloat((num(maskedhrdps.gt.10.)))/(num(Z.gt.10.))
   end if
   
   if((hits+fa).eq.0) then
    far10=0
   else
    far10=tofloat(fa)/(hits+fa)
   end if
   
   pod10=tofloat(nil)/(fa+nil)
   
   
   largeerrors=num(Z2.gt.25.)
   allerrors=num(Z2.gt.0.1)  
   
   dx=10 ; dx
   i = dx
   j = dx
   ndims=dimsizes(Z1)
   numpoints=dx^2
   pobstot=0
   pfcsttot=0
   fbsarray=new(ndims,float)
   pfcstarray=new(ndims,float)
   pobsarray=new(ndims,float)
   thresh=1.0
   
   do while(j.lt.(ndims(1)-dx)) ; 
    i=dx
    do while(i.lt.(ndims(0)-dx)) ;  
      pobs=num(Z(i-dx:i+dx,j-dx:j+dx).ge.thresh)/numpoints ; count of event is observed in window
      pfcst=num(maskedhrdps(i-dx:i+dx,j-dx:j+dx).ge.thresh)/numpoints ; count of event forecast in window
      fbsloc=(pfcst-pobs)^2
      fbsarray(i,j)=fbsloc
      pfcstarray(i,j)=pfcst^2
      pobsarray(i,j)=pobs^2
      i=i+1
    end do
    j=j+1
   end do 
   fss=1-(avg(ndtooned(fbsarray)))/(avg(ndtooned(pfcstarray))+avg(ndtooned(pobsarray)))
   fobs=num(Z.ge.thresh)/num(Z.ge.0)
   
   print(fss)
   print(fobs)
   print(num(Z.ge.thresh))
   print(num(Z.ge.0))
   print(fobs/2 + 0.5)
   
   
      

   res@gsnCenterString          = "HRDPS 1 hour QPF minus MRMS gauge corrected radar estimate from HRDPS forecast: " + date + " ~C~ bias: " + avg(Z2) + " mm" + " FBI1: " + fbi1 + " ETS1: " + ts1 + " FAR1: " +far1 +"~C~" + " FBI10: " + fbi10 + " ETS10: " + ts10 + " FAR10: " +far10 + " Pattern cor: " + pattern_cor(maskedhrdps,Z,1.0,1) + " ~C~ RMSE: " + sqrt(avg(Z2^2)) + " mm " + " var(hrdps)/var(mrms): " + variance(maskedhrdps)/variance(Z) + " ~C~ large error ratio (>25mm): " + tofloat(largeerrors)/allerrors + " ~C~ FSS (1.0 mm threshold using 10 dx neighbourhood): " + fss + " FSS skillful above: " + (fobs/2 + 0.5)  
   
   res@gsnCenterStringFontHeightF = 0.005
   res@cnLevels=(/-50,-25,-20,-15,-10,-7.5,-5,-2.5,-1,1,2.5,5,7.5,10,15,20,25,50/)
   res@cnFillColors=(/0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18/)
   
   plot_nonnative = gsn_csm_contour_map (wks,Z2,res)
   print("done plotting")
   delete(wks)
   cmd = "convert -trim -geometry 2500x2500 +repage -border 8 -bordercolor white -background white -flatten mrms_verif_1hr_west.png mrms_verif_1hr_west.png"
   system(cmd)
  
   
end
exit
