begin

f=addfile("1hr_pr_accum_hrdps_east_201906102000.nc","r")
f1=addfile("1hr_MRMS_qpe_masked_east_201906102000.nc","r")

hrdps=f->PR(3,:,:)
mrms=f1->GaugeCorrQPE01H_0mabovemeansealevel(0,:,:)

hrdps=1000*hrdps ; convert HRDPS data to mm

;;;Apply MRMS missing value mask to HRDPS data!!!! Very important!;;;
maskedhrdps=mask(hrdps,mrms,-999)
;;;

hitsarray=new((/dimsizes(hrdps)/),integer) ; hits array
faarray=new((/dimsizes(hrdps)/),integer) ; false-alarms array
missesarray=new((/dimsizes(hrdps)/),integer) ; misses array

hitsarray=where(maskedhrdps.ge.1.0 .and. mrms.ge.1.0, 1,0)
hits=num(hitsarray.eq.1)

faarray=where(maskedhrdps.ge.1.0 .and. mrms.lt.1.0, 1,0)
fa=num(faarray.eq.1)

missesarray=where(mrms.ge.1.0 .and. maskedhrdps.lt.1.0, 1,0)
misses=num(missesarray.eq.1)

print(hits)
print(fa)
print(misses)

ts=tofloat(hits)/(hits+misses+fa)
fbi=(num(maskedhrdps.gt.1.0))/(num(mrms.gt.1.0))
far=fa/(hits+fa)

print(ts)
print(fbi)
print(far)

end 
exit 
