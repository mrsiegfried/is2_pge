ASASPATH=${NOBACKUP}/ASASv4.3

#### Written by M. Siegfried, 19 Oct 2018
#### Runs an automatic ATL03+ATL09=>ATL06 conversion given folders filled with data
#### siegfried@mines.edu

usageline="$0 /path/to/atl03 /path/to/atl09 /out/path/for/atl06 [num_cores]"
if [[ ! -d ${ASASPATH}/asas ]]; then 
  echo  "ERROR: Path to top-level folder does not exist"
  echo  "       Edit Line 1 of this script to direct to the right folder!"
  exit 1
fi

if [[ $# -eq 0 ]]; then
  echo ' '
  echo ' ' 
  echo 'Welcome to the PGE batch run script.'
  echo 'Written by M. Siegfried, 19 Oct 2018 (siegfried@mines.edu)'
  echo ' '
  echo USAGE: ${usageline}
  echo ' ' 
  echo ' '
  exit 0
fi

if [[ $# -lt 3 || $# -gt 4 ]]; then
  echo ERROR: Wrong number of inputs
  echo USAGE: ${usageline}
  exit 1
fi

if [[ ! -d $1 ]]; then
  echo ERROR: ATL03 directory does not exist
  echo USAGE: ${usageline}
  exit 1
fi

if [[ ! -d $2 ]]; then
  echo ERROR: ATL09 directory does not exist
  echo USAGE: ${usageline}
  exit 1
fi

if [[ ! -d $3 ]]; then
  echo ERROR: Directory to save ATL06 does not exist
  echo USAGE: ${usageline}
  exit 1
fi

echo processing started at `date`

atl03fold=$1
atl09fold=$2
atl06fold=$3

if [[ $4 -gt 0 ]]; then
  num_core=$4
else
  num_core=0
fi

count=`ls -1 control/*.ctl 2> /dev/null | wc -l `
if [[ $count != 0 ]]; then
  echo Deleting old .ctl files in control
  rm control/*.ctl
fi

if [[ -e control/atl03_index.txt ]]; then
  echo Deleting old atl03_index.txt file
  rm control/atl03_index.txt
fi

if [[ -e control/atl09_index.txt ]]; then
  echo Deleting old atl09_index.txt file
  rm control/atl09_index.txt
fi


echo ' '
echo 'Making control/atl03_index.txt'

echo '#' > control/atl03_index.txt
echo "# Created by : $0 on `date`" >> control/atl03_index.txt
echo '#' >> control/atl03_index.txt
echo '=atl03_index' >> control/atl03_index.txt

for file in `ls ${atl03fold}/ATL03*.h5`
do
  echo ... adding $file
  scripts/make_atl_ctrl_line.sh ${file} ${ASASPATH} >> control/atl03_index.txt
done

echo ' '
echo 'Making control/atl09_index.txt'

echo '#' > control/atl09_index.txt
echo "# Created by : $0 on `date`" >> control/atl09_index.txt
echo '#' >> control/atl09_index.txt
echo '=atl09_index' >> control/atl09_index.txt

for file in `ls ${atl09fold}/ATL09*.h5`
do
  echo ... adding $file
  scripts/make_atl_ctrl_line.sh ${file} ${ASASPATH} >> control/atl09_index.txt
done

echo ' '
echo 'Making cf_gen_is_cntl.ctl'

file=cf_gen_is_cntl.ctl
echo '#' > ${file}
echo "# gen_is_cntl for ATL06 (land ice) control files" >> ${file}
echo '#' >> ${file}
echo "# Created by $0 on `date`" >> ${file}
echo '#' >> ${file}
echo '=gen_is_cntl' >> ${file}
echo '#' >> ${file}
echo '# Pass along environment settings based on normal directory structure' >> ${file}
echo '#' >> ${file}
echo ASAS_DIR=${ASASPATH} >> ${file}
echo ANC_DIR=${ASASPATH}/anc_data >> ${file}
echo CNTL_DIR=control >> ${file}
echo '#' >> ${file}
echo '# Ancillary Files' >> ${file}
echo '#' >> ${file}
echo IN_ANC19=${ASASPATH}/anc_data/anc19/tai-utc.dat >> ${file}
echo '#' >> ${file}
echo '# File paths & indices' >> ${file}
echo '#' >> ${file}
echo ATL03_PATH=${atl03fold} >> ${file}
echo 'ATL03_INDEX=control/atl03_index.txt' >> ${file}
echo ' ' >> ${file}
echo ATL09_PATH=${atl09fold} >> ${file}
echo 'ATL09_INDEX=control/atl09_index.txt' >> ${file}
echo ' ' >> ${file}
echo ATL06_PATH=${atl06fold} >> ${file}
echo ' ' >> ${file}
echo PROCESS_APIDS=NO >> ${file}

echo ' '
echo 'Running control file generation'
${ASASPATH}/asas/src/util/gen_cntl_util/gen_is_cntl cf_gen_is_cntl.ctl

echo ' '
echo 'Processing data based on new control file'

if [[ ${num_core} -eq 0 ]]; then
  for ctlfile in `ls control/*.ctl`
  do
    echo ... processing ${ctlfile}
    ${ASASPATH}/asas/src/atlas_l3a_is/atlas_l3a_is ${ctlfile}
  done 
else
  ## simple parallelization using parallel
  ls -1 control/*.ctl > filelist
  parallel --eta -j $num_core ${ASASPATH}/asas/src/atlas_l3a_is/atlas_l3a_is :::: filelist
fi
rm filelist

echo ' '
echo ' '
echo done processing at `date`
