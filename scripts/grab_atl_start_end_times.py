import h5py

import numpy as np
import sys
from astropy.time import Time

h5_09 = h5py.File(sys.argv[1],'r')

t_off = np.array(h5_09['ancillary_data']['atlas_sdp_gps_epoch']).transpose()

start_granule_utc = np.array(h5_09['ancillary_data']['granule_start_utc']).transpose()
start_granule_time = Time(start_granule_utc,format='isot',scale='utc')
start_granule_gps = Time(start_granule_time,format='gps').value

end_granule_utc = np.array(h5_09['ancillary_data']['granule_end_utc']).transpose()
end_granule_time = Time(end_granule_utc,format='isot',scale='utc')
end_granule_gps = Time(end_granule_time,format='gps').value

print('%10.10f %10.10f' % (start_granule_gps,end_granule_gps))
