#!/bin/sh

#SBATCH --partition=santee
#SBATCH --time=10:00:00
#SBATCH -n 48

module load intel/2011.0.013

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/sbao/netcdf/lib

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/sbao/esmf_intelmpi/lib/libO/Linux.intel.64.intelmpi.default/
export I_MPI_PROCESS_MANAGER=mpd


#For the South Carolina Region

#---------------------------------------------------Download GFS Data-------------------------------------------------------------

#cd /mnt/data/sci3/mjisan/WRF_Run/GFS_DATA/

#rm -r SC_GFS
#mkdir SC_GFS

#cd /mnt/data/sci3/mjisan/WRF_Run/GFS_DATA/SC_GFS/

sleep 2

#!/bin/bash
#for i in {20,21};do
#    for j in {00,06,12,18}; do
#    for k in {00,06,12,18,24,30,36,42,48,54,60,66,72,78,84}; do

#wget http://nomads.ncdc.noaa.gov/data/nam/201604/201604${i}/nam_218_201604${i}_${j}00_0${k}.grb

#done
#done
#done


#-----------------------------------------------------GET TODAYS DATE-------------------------------------------------------------

dir1=/mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/WPS/

cd $dir1


hours=00
DATE=`date +%Y%m%d`
Time= "00"

STARTDATESTRING=`date --date="0 days ago" +%Y-%m-%d`"_18:00:00"
ENDDATESTRING=`date --date="-2 days ago" +%Y-%m-%d`"_12:00:00"

echo "
Model Run Time Period:
"
echo $STARTDATESTRING
echo $ENDDATESTRING


YEAR=`date +%Y`
echo $YEAR

EYEAR=`date +%Y`
MONTH=`date +%m`
EMONTH=`date +%m`
SDAY=`date --date="0 days ago" +%d`
EDAY=`date --date="-2 days ago $hours hours" +%d`
echo $EHOUR
echo $SDAY
echo $EDAY
echo $EMONTH
#-----------------------------------------------------------------------------------------------------------------

#---------------------------------------------EDIT NAMELIST---------------------------------------------

cat namelist.wps | sed "s/^.* start_date =.*$/ start_date = '$STARTDATESTRING','$STARTDATESTRING', /" > namelist.wps.new
mv namelist.wps.new namelist.wps
wait
cat namelist.wps | sed "s/^.* end_date =.*$/ end_date = '$ENDDATESTRING','$ENDDATESTRING', /" > namelist.wps.new
mv namelist.wps.new namelist.wps

cd /mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/WRFV3/test/em_real/

cat namelist.input | sed "s/^.*start_year.*$/ start_year = $YEAR, $YEAR, $YEAR,/" > namelist.input.new
mv namelist.input.new namelist.input
cat namelist.input | sed "s/^.*start_month.*$/ start_month = $MONTH, $MONTH, $MONTH,/" > namelist.input.new
mv namelist.input.new namelist.input
cat namelist.input | sed "s/^.*start_day.*$/ start_day = $SDAY, $SDAY, $SDAY,/" > namelist.input.new
mv namelist.input.new namelist.input

cat namelist.input | sed "s/^.*end_day.*$/ end_day = $EDAY, $EDAY, $EDAY,/" > namelist.input.new
mv namelist.input.new namelist.input
cat namelist.input | sed "s/^.*end_year.*$/ end_year = $EYEAR, $EYEAR, $EYEAR,/" > namelist.input.new
mv namelist.input.new namelist.input
cat namelist.input | sed "s/^.*end_month.*$/ end_month = $EMONTH, $EMONTH, $EMONTH,/" > namelist.input.new
mv namelist.input.new namelist.input


#----------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------WPS RUN-------------------------------------------------------------------------

dir1=/mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/WPS/

cd $dir1

echo "REMOVING OLDER FILES"

rm PFILE*

rm FILE:*

rm met_em*

echo "CREATING VARIABLE TABLES"

ln -sf ungrib/Variable_Tables/Vtable.NAM Vtable

sleep 3

echo "DATA LINKUP"

./link_grib.csh /mnt/data/sci3/mjisan/WRF_Run/GFS_DATA/SC_GFS/nam.t*


echo "RUNNING geogrid.exe"

sleep 2

./geogrid.exe


echo "RUNNING ungrib.exe"

./ungrib.exe


echo "RUNNING metgrid.exe"

./metgrid.exe

### END ###

#----------------------------------------------------------------WRF RUN-----------------------------------------------------------------------------------

# wrf_real_run_sh

dir2=/mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/WRFV3/test/em_real/

cd $dir2

ln -sf /mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/WPS/met_em.d0* .

# run real.exe

dir3=/mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/WRFV3/test/em_real/

rm WRFV3/test/em_real/wrfout_d0*
echo "Running real.exe"

./real.exe

tail rsl.error.0000

dir4=/mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/WRFV3/test/em_real/

cd $dir4

module load intel/2011.0.013

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/sbao/netcdf/lib

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/sbao/esmf_intelmpi/lib/libO/Linux.intel.64.intelmpi.default/

cd /mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/WRFV3/test/em_real/


#mpirun -np 48 /mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/WRFV3/test/em_real/wrf.exe

#export I_MPI_PROCESS_MANAGER=mpd


sbatch run_wrf.sh

#mpirun -np 30 /mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/WRFV3/test/em_real/wrf.exe

#echo "Running wrf.exe"

#mpirun -np 30 /mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/WRFV3/test/em_real/wrf.exe


#echo $PostProcess


#dir5=/mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/

#mpirun -np 24 /mnt/data/sci3/mjisan/WRF_Run/SC_Daily_Weather/post-process-dbz.sh



### END ###