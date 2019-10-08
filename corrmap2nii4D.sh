# !/bin/bash
# trans_filtered_func trans_res4d
for input_type in trans_filtered_func #trans_res4d
do
datadir="/jukebox/hasson/claire/tennis/intersubj/${input_type}/corrmap"
cd ${datadir}
for ks in coop comp basecoop basecomp
do
fslmerge -t $ks `imglob -oneperimage *_$ks*.nii`
fslchfiletype NIFTI ${ks}.nii.gz ${datadir}/../group/${ks}.nii
rm -f ${ks}.nii.gz
done;
done;