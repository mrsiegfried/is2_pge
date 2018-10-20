asaspath=/att/gpfsfs/atrepo01/data/IceSat/PGE_code/asasv4.3
installpath=$NOBACKUP/ASASv4.3
thispath=`pwd`

# checking if the folder at the install path exists. 
# if it does, blow it away
${thispath}/prepare_install.sh ${installpath}

echo starting log at ./install_log.txt
echo open new window and tail -f ${thispath}/install_log.txt for updates
cd ${installpath}
# untar all the code as it is distributed
${thispath}/untar_code.sh ${asaspath} > ${thispath}/install_log.txt


#### THIS IS FOR THE MISSING SEGMENT PATCH
#cp -f ~/v43patch/*.f90 ${installpath}/asas/src/atlas_l3a_is/

# create ASAS_PATH file and get moving with the set up
${thispath}/setup_and_run.sh ${installpath} >> ${thispath}/install_log.txt



cd ${thispath}
echo ASAS v4.3 installed at ${installpath}
echo Check ${thispath}/install_log.txt for warnings and/or errors
