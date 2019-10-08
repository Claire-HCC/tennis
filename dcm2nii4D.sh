# !/bin/bash
# ls /jukebox/hasson/claire/tennis/subjects/dcm/| grep "Pair[99]" > subjlist.txt
# for f in `cat subjlist.txt`; do ./dcm2nii4D.sh ${f}; done
# covert dicom to nifti
subjdir=/jukebox/hasson/claire/tennis_raw/

# dcm2nii
mkdir $subjdir/nifti3D/$1/
keywords=`ls $subjdir/dcm/$1/* | awk 'BEGIN{FS="_0"}{ print $1 }' | sort | uniq` 

for ks in $keywords; do
files=( $(ls ${ks}*IMA ) )

for f in ${files[@]:10:200}
do
dcm2nii -v N -e N -f Y -p N -d N -i N -o $subjdir/nifti3D/$1/ $f
done

done



# 3D nii to 4D nii
keywords=`ls $subjdir/nifti3D/$1/* | awk 'BEGIN{FS="_0"}{ print $1 }' | sort | uniq` 
for ks in $keywords 
do
fslmerge -t $ks `imglob -oneperimage $ks*`
mv $ks.nii.gz $subjdir/nifti/
done
