# !/bin/bash
# ls /jukebox/hasson/claire/tennis/subjects/dcm_notInterpolated/| grep "Pair[99]" > subjlist.txt
# for f in `cat subjlist.txt`; do ./dcm2niiT1.sh ${f}; done
# covert T1 dicom to nifti
subjdir=/jukebox/hasson/claire/tennis_raw/
schools='nccu nymu'

for sch in $schools
do
# dcm2nii
dcm2nii -v Y -e N -f N -p Y -d N -i N -o $subjdir/nifti/ $subjdir/dcm_notInterpolated/$1/T1_$sch/*

# echo `ls $subjdir/nii/MPRAGES*`
mv `ls $subjdir/nifti/mprage*` ${subjdir}/nifti/${1#*_}_${sch}_t1.nii.gz
mv `ls $subjdir/nifti/MPRAGE*` ${subjdir}/nifti/${1#*_}_${sch}_t1.nii.gz
mv `ls $subjdir/nifti/oMPRAGES*` $subjdir/nifti/${1#*_}_${sch}_ot1.nii.gz
mv `ls $subjdir/nifti/coMPRAGES*` $subjdir/nifti/${1#*_}_${sch}_cot1.nii.gz
done






