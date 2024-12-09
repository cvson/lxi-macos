#!/bin/bash

set -e

IPADDR=$1
NEVENT=$2
outputFile=$3
subrun=$4
beammode=$5

lxi scpi "*IDN?" -a $IPADDR
##Setup the oscilloscope base on the trigger mode
###SSEM IN
if [ "${beammode}" -eq 1 ]; then
lxi scpi "TRIG:A:SOUR CH1" -a $IPADDR
lxi scpi "CHAN1:THR -0.2" -a $IPADDR
lxi scpi "TRIG:A:EDGE:SLOP NEG" -a $IPADDR
lxi scpi "TRIG:A:LEV1:VAL -0.2 " -a $IPADDR
lxi scpi "TIM:SCAL 5e-7 " -a $IPADDR
lxi scpi "TIM:POS 36144e-9 " -a $IPADDR
lxi scpi "ACQ:POIN:VAL 5000" -a $IPADDR
lxi scpi "CHAN1:SCAL 5e-1" -a $IPADDR
lxi scpi "CHAN2:SCAL 5e-2" -a $IPADDR
lxi scpi "CHAN3:SCAL 5e-2" -a $IPADDR
lxi scpi "CHAN4:SCAL 1" -a $IPADDR
lxi scpi "CHAN2:OFFS -0.15" -a $IPADDR
lxi scpi "CHAN3:OFFS -0.15" -a $IPADDR
lxi scpi "CHAN4:OFFS -0.65" -a $IPADDR

#lxi scpi "CHAN1:SCAL 5e-1" -a $IPADDR
#lxi scpi "CHAN2:SCAL 2e-1" -a $IPADDR
#lxi scpi "CHAN3:SCAL 2e-1" -a $IPADDR
#lxi scpi "CHAN4:SCAL 2e-1" -a $IPADDR
#lxi scpi "CHAN2:OFFS -0.65" -a $IPADDR
#lxi scpi "CHAN3:OFFS -0.65" -a $IPADDR
#lxi scpi "CHAN4:OFFS -0.65" -a $IPADDR
lxi scpi "TRIG:A:MODE NORM" -a $IPADDR

fi

###SSEM OUT
if [ "${beammode}" -eq 2 ]; then
lxi scpi "TRIG:A:SOUR CH1" -a $IPADDR
lxi scpi "TRIG:A:EDGE:SLOP NEG" -a $IPADDR
lxi scpi "TRIG:A:LEV1:VAL -0.2 " -a $IPADDR
lxi scpi "TIM:SCAL 500e-9 " -a $IPADDR
lxi scpi "TIM:POS 36144e-9 " -a $IPADDR
lxi scpi "ACQ:POIN:VAL 5000" -a $IPADDR
lxi scpi "CHAN1:SCAL 2e-1" -a $IPADDR
#lxi scpi "CHAN2:SCAL 0.2" -a $IPADDR
#lxi scpi "CHAN3:SCAL 0.1" -a $IPADDR
#lxi scpi "CHAN4:SCAL 0.1" -a $IPADDR
#lxi scpi "CHAN2:OFFS -0.8" -a $IPADDR
#lxi scpi "CHAN3:OFFS -0.4" -a $IPADDR
#lxi scpi "CHAN4:OFFS -0.4" -a $IPADDR
###250kW
lxi scpi "CHAN2:SCAL 0.05" -a $IPADDR
lxi scpi "CHAN3:SCAL 0.05" -a $IPADDR
#lxi scpi "CHAN4:SCAL 0.05" -a $IPADDR
lxi scpi "CHAN4:SCAL 0.1" -a $IPADDR

lxi scpi "CHAN2:OFFS -0.160" -a $IPADDR
lxi scpi "CHAN3:OFFS -0.160" -a $IPADDR
#lxi scpi "CHAN4:OFFS -0.160" -a $IPADDR
lxi scpi "CHAN4:OFFS -0.320" -a $IPADDR
lxi scpi "TRIG:A:MODE NORM" -a $IPADDR

fi

###MR study
if [ "${beammode}" -eq 3 ]; then
lxi scpi "TRIG:A:SOUR CH2" -a $IPADDR
lxi scpi "TRIG:A:EDGE:SLOP NEG" -a $IPADDR
lxi scpi "TRIG:A:LEV2:VAL -0.1 " -a $IPADDR
lxi scpi "TIM:SCAL 500e-9 " -a $IPADDR
lxi scpi "TIM:POS 2e-6 " -a $IPADDR
lxi scpi "ACQ:POIN:VAL 5000" -a $IPADDR
lxi scpi "CHAN1:SCAL 2e-1" -a $IPADDR
lxi scpi "CHAN2:SCAL 0.2" -a $IPADDR
lxi scpi "CHAN3:SCAL 0.1" -a $IPADDR
lxi scpi "CHAN4:SCAL 0.1" -a $IPADDR
lxi scpi "CHAN2:OFFS -0.8" -a $IPADDR
lxi scpi "CHAN3:OFFS -0.4" -a $IPADDR
lxi scpi "CHAN4:OFFS -0.4" -a $IPADDR
lxi scpi "TRIG:A:MODE NORM" -a $IPADDR
fi

#for ivt in {1..$NEVENT};
for((ivt=1; ivt<=$NEVENT; ivt++))
do 
echo "subrun$subrun event $ivt/$NEVENT"
runnumber=`date +%Y%m%d`
tsecond=`date +%s`
tmsecond=`date +%s.%3N| cut -b12-15`

lxi scpi "RUNS" -a $IPADDR

ACQSTAT=`lxi scpi :ACQ:STAT? -a $IPADDR` 
echo  "$ACQSTAT"

while [ "$ACQSTAT" != "COMP" ] 
do
sleep 0.1
ACQSTAT=`lxi scpi :ACQ:STAT? -a $IPADDR`
echo  "$ACQSTAT"
done
tsecAcqStop=`date +%s`
tmsecAcqStop=`date +%s.%3N| cut -b12-15`
lxi scpi "STOP" -a $IPADDR

HEAD=`lxi scpi :CHAN1:DATA:HEAD? -a $IPADDR`
IFS=',' read -r -a infoSam <<< "$HEAD"

DAT1=`lxi scpi CHAN1:DATA? -a $IPADDR`
DAT2=`lxi scpi CHAN2:DATA? -a $IPADDR`
DAT3=`lxi scpi CHAN3:DATA? -a $IPADDR`
DAT4=`lxi scpi CHAN4:DATA? -a $IPADDR`

tsecAcqFin=`date +%s`
tmsecAcqFin=`date +%s.%3N| cut -b12-15`

if [ "${ivt}" -eq 1 ]; then 
	echo "run/L:subrun/L:eventid/L:tsecond/L:tmsecond:tstat/F:tstop/F:samples/L:id/L:tsecAcqStop/L:tmsecAcqStop/L:tsecAcqFin/L:tmsecAcqFin/L:chan1[${infoSam[2]}]/F:chan2[${infoSam[2]}]/F:chan3[${infoSam[2]}]/F:chan4[${infoSam[2]}]/F" | sed 's/,/ /g' >>${outputFile}_trigmode${beammode}_raw_p${subrun}.dat

fi

echo "${runnumber} ${subrun} ${ivt} ${tsecond} ${tmsecond} $HEAD ${tsecAcqStop} ${tmsecAcqStop} ${tsecAcqFin} ${tmsecAcqFin} $DAT1 $DAT2 $DAT3 $DAT4" | sed 's/,/ /g' >>${outputFile}_trigmode${beammode}_raw_p${subrun}.dat

done
mv ${outputFile}_trigmode${beammode}_raw_p${subrun}.dat rawdata/
##for file save
#sleep 0.1
#root -b -q read_rawdata.C\(\"${outputFile}_raw_p${subrun}\"\) 
#lxi scpi CHAN3:DATA? -a $IPADDR| sed 's/,/ /g' >>${outputFile}_channe1.dat
#readarray -t the_array < <(awk -F',' '{ for( i=1; i<=NF; i++ ) print $i }' <<<"$HEAD")
#IFS=',' read -r -a infoSam <<< "$HEAD"
#echo ${infoSam[0]}
#echo ${infoSam[1]}
#echo ${infoSam[2]}
#echo ${infoSam[3]}
##lxi scpi CHAN3:DATA? -a $IPADDR| sed 's/,/\n/g' |  ./decoder ${infoSam[2]}
#lxi scpi CHAN3:DATA? -a $IPADDR| sed 's/,/\n/g' |  ./decoder ${infoSam[2]} $outputFile

#DAT1=`lxi scpi :CHAN1:DATA? -a $IPADDR`
#IFS=',' read -r -a ArrDat1 <<< "$DAT1"

#NSAMPLE=${#ArrDat1[@]}
#echo "$NSAMPLE"

#lxi scpi "STOP" -a $IPADDR
#MDEPTH=`lxi scpi :acquire:mdepth? -a $IPADDR`

#lxi scpi ":waveform:mode raw" -a $IPADDR
#lxi scpi ":waveform:format ascii" -a $IPADDR
#lxi scpi ":waveform:start 1" -a $IPADDR
#lxi scpi ":waveform:stop $MDEPTH" -a $IPADDR

#lxi scpi waveform:data? -a $IPADDR | cut -c 12- | sed 's/,/\n/g' | ./decoder $MDEPTH
## lxi scpi :waveform:data? -a $IPADDR
