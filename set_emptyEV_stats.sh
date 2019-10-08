# !/bin/bash
subjdir=/jukebox/hasson/claire/tennis/subjects/${1}
scani='1 2 3 4 5 6'
for i in $scani
do
h=`cat ${subjdir}/design/emptyEV.txt |grep "feat0${i}"| awk 'BEGIN{FS="\t"}{ print $2 }'`
for ev in $h
do

# sed -i "s/set fmri(${shape}) 3/set fmri(${shape}) 10/g" "${subjdir}/fsf/stats0${i}.fsf"
 sed -i "s/set fmri(shape${ev}) 3/set fmri(shape${ev}) 10/g" "${subjdir}/fsf/stats0${i}.fsf"
 done
 done