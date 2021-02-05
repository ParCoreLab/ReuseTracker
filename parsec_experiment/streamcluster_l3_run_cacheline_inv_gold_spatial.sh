#! /bin/bash

ReuseTracker_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-pthreads -p streamcluster -i native -n 32
/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/kernels/streamcluster/inst/amd64-linux.gcc-pthreads/bin/streamcluster 10 20 128 1000000 200000 5000 none output.txt 32 2>&1 | tee streamcluster_log

rm -r streamcluster_l3_output

rm -r streamcluster_rd_spatial_l3_output

HPCRUN_WP_REUSE_PROFILE_TYPE="SPATIAL" HPCRUN_PROFILE_L3=true HPCRUN_WP_REUSE_BIN_SCHEME=4000,2 HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o streamcluster_overhead.tmp $ReuseTracker_path/bin/hpcrun -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 -o streamcluster_l3_output parsec-3.0/pkgs/kernels/streamcluster/inst/amd64-linux.gcc-pthreads/bin/streamcluster 10 20 128 1000000 200000 5000 none output.txt 32 2>&1 | tee streamcluster_reusetracker_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat streamcluster_overhead.tmp | tee -a $TRACE_FILE >/dev/null

rm streamcluster_overhead.tmp

mkdir streamcluster_rd_spatial_l3_output

mv *hpcrun streamcluster_rd_spatial_l3_output

$ReuseTracker_path/bin/hpcstruct parsec-3.0/pkgs/kernels/streamcluster/inst/amd64-linux.gcc-pthreads/bin/streamcluster

$ReuseTracker_path/bin/hpcprof -S ./streamcluster.hpcstruct -o streamcluster_l3_database streamcluster_l3_output

mv streamcluster.hpcstruct streamcluster_rd_spatial_l3_output

mv streamcluster_l3_database streamcluster_rd_spatial_l3_output
