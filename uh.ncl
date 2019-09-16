begin

fili = systemfunc("ls *20*.nc")
nfili = dimsizes(fili)
subhourly=4
nj=1310
ni=2560
uharray=new((/(nfili*subhourly)+1,nj,ni/),float,0.0) ; create array of 0's to put 2-d UH field for all times

do nf=0,nfili-1 ; loop over all hourly files 

f=addfile(fili(nf),"r")
ZZ=f->ZZ(:,::-1,:,:)
GZ=f->GZ(:,::-1,:,:)
VV=f->VV(:,::-1,:,:)
UU=f->UU(:,::-1,:,:)

lat2d=f->lat
lon2d=f->lon
nlat  = dimsizes(lat2d(:,0))
nlon  = dimsizes(lon2d(0,:))

ntimes=dimsizes(ZZ(:,1,200,200)) ; determine amount of sub-hourly data
mapfact=new((/ntimes,1310,2560/),float,1.0) ; 

opt         = True
opt@uhmnhgt = 2000.
opt@uhmxhgt = 5000.

uh=1E-3*wrf_updraft_helicity(98*GZ(:,1:124:2,:,:),mapfact,0.51444*UU,0.51444*VV,ZZ,2500,2500,opt) ; calculate UH for this hourly file (including at all sub-hourly times)

print(dimsizes(uh))

uharray(nf:nf+(subhourly-1),:,:)=uh
delete(f)
delete(GZ)
delete(UU)
delete(VV)
delete(ZZ)
end do


maxuh=dim_max_n(uharray,0)

print(max(maxuh))

wtype          = "png"
wtype@wkWidth  = 2500
wtype@wkHeight = 2500

wks  = gsn_open_wks(wtype, "uh")     ; send graphics to PNG file~
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
  res@mpMinLatF                = 35.0
  res@mpMaxLatF                = 47.0
  res@mpMaxLonF                = -70.0
  res@mpMinLonF                =-85.0
  res@mpGeophysicalLineThicknessF = 3.0
  res@pmLabelBarOrthogonalPosF = 0.05
  res@gsnCenterString             = "Max 2-5km updraft helicity in past hour (m^2/s^2)"
  res@gsnMaximize = True
   res@cnLevelSelectionMode = "ExplicitLevels" 
  res@cnLevels=(/10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260,270,280,290,300/)
  cmap=read_colormap_file("BlGrYeOrReVi200")
cmap(0:3,:)=1.
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
   plot_nonnative = gsn_csm_contour_map (wks,maxuh,res)
end
exit
