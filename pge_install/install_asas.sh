#### Written by M. Siegfried, 19 Oct 2018
#### Top level script for installing the PGE locally. 
#### siegfried@mines.edu

asaspath=/att/gpfsfs/atrepo01/data/IceSat/PGE_code/asasv4.3
installpath=$NOBACKUP/ASASv4.3
thispath=`pwd`

if [[ ! -e ${asaspath}/atlas_l3a_is_v3.3.tar ]]; then 
  echo ERROR: Cannot find main tarball at ${asaspath}
  echo Make sure asaspath variable is set correctly in $0
  exit 1
fi

# checking if the folder at the install path exists. 
# if it does, blow it away
${thispath}/scripts/prepare_install.sh ${installpath}

echo starting log at ./install_log.txt
echo open new window and tail -f ${thispath}/install_log.txt for updates
cd ${installpath}
# untar all the code as it is distributed
${thispath}/scripts/untar_code.sh ${asaspath} > ${thispath}/install_log.txt


#### THIS IS FOR THE MISSING SEGMENT PATCH
## but it doesn't seem to work, so leave it commented out
#cp -f ~/v43patch/*.f90 ${installpath}/asas/src/atlas_l3a_is/

# create ASAS_PATH file and get moving with the set up
${thispath}/scripts/setup_and_run.sh ${installpath} >> ${thispath}/install_log.txt



cd ${thispath}
echo ASAS v4.3 installed at ${installpath}
echo Check ${thispath}/install_log.txt for warnings and/or errors
