### Written by M. Siegfried & S. Adusumilli, 19 Oct 2018
### Takes an ATLXX file and dumps out the information in the right format for a ctl file
### siegfried@mines.edu

if [[ $# -ne 2 ]]; then
  echo "ERROR: Incorrect usage. Requires TWO inputs!"
  echo "USAGE: $0 /path/to/data/filename.h5 ${ASAS_BASE}"
  exit 1
fi
  

atl03file=$1
ASAS_BASE=$2

atlbase=`basename ${atl03file}`
atltype=${atlbase:0:5}

# grab release and version number from the HDF5 file
release=`h5ls -d ${atl03file}/ancillary_data/release | grep '(0)' | awk '{print $2}' | tr '"' ' '`
version=`h5ls -d ${atl03file}/ancillary_data/version | grep '(0)' | awk '{print $2}' | tr '"' ' '`

# get start cycle and end cycle
start_cycle=`h5ls -d ${atl03file}/ancillary_data/start_cycle | grep '(0)' | awk '{print $2}' | tr '"' ' '`
end_cycle=`h5ls -d ${atl03file}/ancillary_data/end_cycle | grep '(0)' | awk '{print $2}' | tr '"' ' '`

# get start orbit and end rgt
start_rgt=`h5ls -d ${atl03file}/ancillary_data/start_rgt | grep '(0)' | awk '{print $2}' | tr '"' ' '`
end_rgt=`h5ls -d ${atl03file}/ancillary_data/end_rgt | grep '(0)' | awk '{print $2}' | tr '"' ' '`

# get start and end region
start_orbit=`h5ls -d ${atl03file}/ancillary_data/start_orbit | grep '(0)' | awk '{print $2}' | tr '"' ' '`
end_orbit=`h5ls -d ${atl03file}/ancillary_data/end_orbit | grep '(0)' | awk '{print $2}' | tr '"' ' '`

# get start and end region
start_region=`h5ls -d ${atl03file}/ancillary_data/start_region | grep '(0)' | awk '{print $2}' | tr '"' ' '`
end_region=`h5ls -d ${atl03file}/ancillary_data/end_region | grep '(0)' | awk '{print $2}' | tr '"' ' '`

# grab UUID from the header
uuid=`h5dump -a /identifier_file_uuid ${atl03file} | grep '(0)' | tr '"' ' ' | awk '{print $2}'`

gran_times=`${ASAS_BASE}/asas/src/util/atlas_time/get_atlas_times ${atl03file} | head -3 | tail -1 | awk '{print $4,$5}'`
#gran_times=`python scripts/grab_atl_start_end_times.py ${atl03file}`
 
printf "${atltype}=${atl03file} $gran_times %3i %02d ${uuid} ${start_cycle} ${end_cycle} ${start_orbit} ${end_orbit} ${start_rgt} ${end_rgt} ${start_region} ${end_region} \n" ${release} ${version}



##### old start/end time code for ATL03
## grab start of granule in GPS seconds since 2018-01-01
#delta_time=`h5ls -d ${atl03file}/ancillary_data/delta_time | grep '(0)' | awk '{print $2}'`
## grap the standard data product offset for gps seconds from 1980 to 2018
#sdp_gps_epoch=`h5ls -d ${atl03file}/ancillary_data/atlas_sdp_gps_epoch | grep '(0)' | awk '{print $2}'`
## grab the granule duration in seconds
#granule_duration=`h5dump -a /time_coverage_duration ${atl03file} | grep '(0)' | awk '{print $2}'`
#
## atl03 granule start
#atl03_gran_start=`echo - | awk "{print ${sdp_gps_epoch} + ${delta_time}}"`
#atl03_gran_end=`echo - | awk "{print ${atl03_gran_start} + ${granule_duration}}"`
#
#atl03_gran_start=`echo "${sdp_gps_epoch}+${delta_time}" | bc -l`
#atl03_gran_end=`echo "${atl03_gran_start}+${granule_duration}" | bc -l`
