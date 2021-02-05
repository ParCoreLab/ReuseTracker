#! /bin/bash

ReuseTracker_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-pthreads -p vips -i native -n 32
/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/apps/vips/inst/amd64-linux.gcc-pthreads/bin/vips im_benchmark parsec-3.0/pkgs/apps/vips/run/orion_18000x18000.v parsec-3.0/pkgs/apps/vips/run/output.v 2>&1 | tee vips_log

rm -r vips_rd_spatial_l1_output

rm -r vips_spatial_l1_output

HPCRUN_WP_REUSE_PROFILE_TYPE="SPATIAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_REUSE_BIN_SCHEME=4000,2 HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true OMP_NUM_THREADS=32 /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o vips_overhead.tmp  $ReuseTracker_path/bin/hpcrun -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 -o vips_spatial_l1_output parsec-3.0/pkgs/apps/vips/inst/amd64-linux.gcc-pthreads/bin/vips im_benchmark parsec-3.0/pkgs/apps/vips/run/orion_18000x18000.v parsec-3.0/pkgs/apps/vips/run/output.v  2>&1 | tee vips_reusetracker_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat vips_overhead.tmp | tee -a $TRACE_FILE >/dev/null

#rm vips_overhead.tmp

mkdir vips_rd_spatial_l1_output

mv *hpcrun vips_rd_spatial_l1_output

$ReuseTracker_path/bin/hpcstruct parsec-3.0/pkgs/apps/vips/inst/amd64-linux.gcc-pthreads/bin/vips

$ReuseTracker_path/bin/hpcprof -S ./vips.hpcstruct -o vips_l1_database vips_spatial_l1_output

mv vips.hpcstruct vips_rd_spatial_l1_output

mv vips_l1_database vips_rd_spatial_l1_output

mv vips_overhead.tmp vips_rd_spatial_l1_output
