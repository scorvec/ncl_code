#!/bin/bash

#Converts HRRR grib data to netCDF and extracts variables for EMET Puts data on 3km uniform lat/lon grid. Unit conversion done in convert_units.sh#
. ssmuse-sh -p eccc/crd/ccmr/EC-CAS/master/fstd2nc_0.20180821.0
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/smc001/hall1/lib

set -x
typeset -Z3 EXT
ulimit -s unlimited
mkdir -p /home/smc001/hall1/20190711/p3

cd /home/szh000/.suites/hrdps_national_510shawn/hub/eccc-ppp1/gridpt/prog/lam/2p5/model
for f in 20*12_0*; do
   cp ${f} /home/smc001/hall1/work
  # d.compute_pressure -s /home/smc001/hall1/work/${f} -d /home/smc001/hall1/work/${f} -var TT
  # fstd2nc --vars=WT1,UU,VV,GZ,ZET,P0,HU,TT,PX /home/smc001/hall1/work/${f} /home/smc001/hall1/20190711/p3/${f}_250m.nc
   fstd2nc --vars=WT1 --ignore-diag-level ${f} /home/smc001/hall1/20190711/op/${f}_wt1.nc
   cycle="${f%_*}"
   #d.compute_pressure -s ${f} -d /home/smc001/hall1/tmp1 -var TT
   #fstd2nc /home/smc001/hall1/tmp1 /home/smc001/hall1/tmp1.nc
   #ncks -A /home/smc001/hall1/tmp1.nc /home/smc001/hall1/20190711/p3/${f}_1km.nc
   #rm -f /home/smc001/hall1/tmp1
done
#/home/smc001/hall1/cdo/bin/cdo -v -mergetime /home/smc001/hall1/20190711/p3/*250m_zet.nc /home/smc001/hall1/20190711/p3/${cycle}_merged_250m_zet.nc
