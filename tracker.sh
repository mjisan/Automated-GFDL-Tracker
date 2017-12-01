#!/bin/sh

for i in WRFPRS_.???; do /home/mjisan/Downloads/UPPV2.0/bin/copygb.exe '-xg255 0 366 304   42557   -103257 136  11533  -57053    126    102 0' $i $i.copygb; done
for i in WRFPRS_.??; do /home/mjisan/Downloads/UPPV2.0/bin/copygb.exe '-xg255 0 366 304   42557   -103257 136  11533  -57053    126    102 0' $i $i.copygb; done


for i in WRFPRS_.??.copygb; do mv $i arw.uncoupled.SIDR09L.2007111300.f0$(echo ${i:8:2}*60|bc); done
for i in WRFPRS_.???.copygb; do mv $i arw.uncoupled.SIDR09L.2007111300.f0$(echo ${i:8:3}*60|bc); done

mv arw.uncoupled.SIDR09L.2007111300.f00 arw.uncoupled.SIDR09L.2007111300.f00000
mv arw.uncoupled.SIDR09L.2007111300.f0180 arw.uncoupled.SIDR09L.2007111300.f00180
mv arw.uncoupled.SIDR09L.2007111300.f0360 arw.uncoupled.SIDR09L.2007111300.f00360
mv arw.uncoupled.SIDR09L.2007111300.f0540 arw.uncoupled.SIDR09L.2007111300.f00540
mv arw.uncoupled.SIDR09L.2007111300.f0720 arw.uncoupled.SIDR09L.2007111300.f00720
mv arw.uncoupled.SIDR09L.2007111300.f0900 arw.uncoupled.SIDR09L.2007111300.f00900

cp -a /mnt/cidstore1/sci3/mjisan/coupled/GFDL_Tracker/tracker_util/fort.1* .
cp -a /mnt/cidstore1/sci3/mjisan/coupled/GFDL_Tracker/tracker_util/tracker.exe .
cp -a /mnt/cidstore1/sci3/mjisan/coupled/GFDL_Tracker/tracker_util/namelist.multi .
cp -a /mnt/cidstore1/sci3/mjisan/coupled/GFDL_Tracker/tracker_util/grbindex.exe .

 rm fort.14
 touch fort.14

for i in arw.uncoupled.SIDR09L.2007111300.f0????; do grbindex.exe $i $i.ix; done

 



### END ###