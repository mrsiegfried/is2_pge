# is2_pge repo
M. Siegfried, 20 Oct 2018
siegfried@mines.edu

Repository contains scripts to install the ICESat-2 Product Generating Executables (PGE) and then run ATL03+ATL09=>ATL06 in batch mode. Current version is not parallelized but it easily can be.

To install the PGE, set install path and tarball location (asaspath) in pge_install/install_asas.sh
I'll note here that this is not particularly robust; it has minor error checking, but you can still break it, so have fun.

To run the PGE in batch mode, run pge_batch/run_pge_atl06.sh. Error checking is much more robust here. If you run with no inputs, you'll see the instructions for using it. 
