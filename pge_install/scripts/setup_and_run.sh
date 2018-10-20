#### Written by M. Siegfried, 19 Oct 2018
#### Sets up the ASAS_PATHS file and does the PGE install
#### siegfried@mines.edu

#### NOTE: The `sed -i` line is for installing on VMs! 

installpath=$1



echo making ASAS_PATHS file
pathsfile=.ASAS_PATHS.$USER
echo "#!/bin/bash" > ${pathsfile}
echo "# " >> ${pathsfile}
echo "# Sets ASAS default directories (fully qualified paths)" >> ${pathsfile}
echo "# " >> ${pathsfile}
echo "MASTER_REPO=${installpath}" >> ${pathsfile}
echo "ASAS_BASE=${installpath}/asas" >> ${pathsfile}
echo "ANC_DIR=${installpath}/anc_data" >> ${pathsfile}
echo "ANC_TEST=${installpath}/anc_test" >> ${pathsfile}
echo "UTEST_DIR=${installpath}/unit_test" >> ${pathsfile}

bash gen_cntl.sh

cd base_libs
##### NEED TO FIX THE OpenBLAS INSTALL ERROR WHEN INSTALLING ON VMs
##### Change line 36 of base_libs/install/install_openblas.sh to:
##### make TARGET=NEHALEM >> ${LOG} 2>&1
sed -i '36s/.*/make TARGET=NEHALEM >> ${LOG} 2>\&1/' ${installpath}/base_libs/install/install_openblas.sh
bash install.sh

cd ..
make clean && make all

cd asas/src/atlas_libs/atlas_const_lib/
make clean && make all

cd ../../util/gen_cntl_util
make clean && make all

