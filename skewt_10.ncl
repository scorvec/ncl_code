;**************************************************
; skewt_10.ncl
;
; Concepts illustrated:
;   - Read from WRF netCDF and extracting necessary variables
;   - Using 'wrf_user_ll_to_ij' get indices (subscripts) near specified location
;   - Using NCL's 'wind_component' to convert wind speed and direvtion to u,v
;   - Adjusting the fortran 1-based subscripts to NCL 0-based subscripts 
;   - Plotting a hodograph onto a skew-T plot
;**************************************************
; Author: Joesph Grim
;         Project Scientist
;         Aviation Applications Program
;         Research Application Laboratory 
;**************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/skewt_func.ncl"

begin
;---Set parameters

 snd_lat =  45.5     ; latitude of model profile
 snd_lon = -73.6     ; longitude of model profile
 hodo_top_pres = 150. ; top of hodograph in hPa

 in_dir  = "./"
 in_file = "2019060700_024"  ; WRF output file

;---Read in WRF data

 in_path    = in_dir + in_file                   
 ncdf_in    = addfile(in_path+".nc","r")             ; add .nc extension      

 
 P_tot      = ncdf_in->pres  ; model 3D pressure
 z_tot      = ncdf_in->GZ(0,:,:,:)        ; model 3D height
 z_tot = 10.0*z_tot
 U          = ncdf_in->UU_vgrid2(0,:,:,:)                       ; Earth-relative U wind on mass points
 V          = ncdf_in->VV_vgrid2(0,:,:,:)                       ; Earth-relative V wind on mass points
 lat         = ncdf_in->lat_1
 lon        =ncdf_in->lon_1
 TC         = ncdf_in->TT_vgrid2(0,:,:,:)       ; model temperature in Celsius
 TD         = ncdf_in->TD_vgrid2(0,:,:,:)       ; model dewpoint in Celsius



;---Determine the model i,j indices for the given lat/lon
loc=getind_latlon2d(lat,lon,snd_lat,snd_lon)
; loc = wrf_user_ll_to_ij(ncdf_in,snd_lon,snd_lat,True)  ; model i,j indices for the given lat/lon
; locX = loc(0) - 1                           ; subtract 1, since WRF is base 1, but NCL is base 0
; locY = loc(1) - 1                           ; subtract 1, since WRF is base 1, but NCL is base 0
print(loc)
locY=loc(0,0)
locX=loc(0,1)
;***********************
;---Begin to create plot
;***********************
 PlotType = "png"
;PlotName = "skewT_hodograph"
 PlotName = "skewt"

 PlotType@wkWidth  = 800     ; large  
 PlotType@wkHeight = 800 

 wks = gsn_open_wks(PlotType,PlotName)                   ; open workstation

;---Draw skewT background
 skewtOpts          = True
 skewtOpts@DrawColLine       = True    ; draw background lines in color, (False for all black lines)
 skewtOpts@DrawFahrenheit    = False   ; True for deg F, False for deg C
 skewtOpts@tiMainString      = "Sounding at "+snd_lat+","+snd_lon+": "+in_file
 skewtOpts@tiMainFontHeightF = 0.0155

 skewtOpts@vpHeightF         = 0.85    ; controls height of plot
 skewtOpts@vpWidthF          = 0.85    ; controls width of plot
 skewtOpts@vpXF              = 0.07    ; controls off-set from left
 skewtOpts@vpYF              = 0.92    ; controls off-set from top
 skewt_bkgd                  = skewT_BackGround (wks, skewtOpts)

;---Draw a blank square where the hodograph will go

 poly_res = True
 poly_res@gsFillColor = "white"    ; set fill color to white
 gsn_polygon (wks,skewt_bkgd,(/-19.,-5.5,-5.5,-19.,-19./),(/44.,44.,30.75,30.75,44./),poly_res)


; Draw the skewT plot background with all the overlays
 draw (skewt_bkgd)

; Draw the skew-T data on top of everything else
 dataOpts = True
 dataOpts@colTemperature  = "red"  ; temperature line color
 dataOpts@colDewPt        = "blue" ; dewpoint line color
 dataOpts@DrawWindBarbThk = 2.     ; wind barb thickness
 dataOpts@Parcel          = 1      ; subscript corresponding to initial parcel
 dataOpts@WspdWdir        = False  ; True = use wind speed and dir, False = use U & V
 dataOpts@Wthin           = 0      ; 0 = draw wind barbs at all levels, 1 = draw every other, 2 = every 3rd, etc.
 skewT_data = skewT_PlotData(wks, skewt_bkgd, P_tot(:), \
                                               TC(:,locY,locX), \
                                               TD(:,locY,locX), \
                                            z_tot(:,locY,locX), \
                                                  U(:,locY,locX), \
                                                  V(:,locY,locX), \
                                             dataOpts)
 frame(wks)  ; advance frame
 print("Created plot: "+PlotName+"."+PlotType)
end
