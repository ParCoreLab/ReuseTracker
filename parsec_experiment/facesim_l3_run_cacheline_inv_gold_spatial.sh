#! /bin/bash

ReuseTracker_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-pthreads -p facesim -i native -n 32
cp -r parsec-3.0/pkgs/apps/facesim/run/* .
/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/apps/facesim/inst/amd64-linux.gcc-pthreads/bin/facesim -timing -threads 32 -lastframe 100 2>&1 | tee facesim_log

rm -r facesim_l3_output

rm -r facesim_rd_l3_output

HPCRUN_WP_REUSE_PROFILE_TYPE="SPATIAL" HPCRUN_PROFILE_L3=true HPCRUN_WP_REUSE_BIN_SCHEME=4000,2 HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o facesim_overhead.tmp $ReuseTracker_path/bin/hpcrun -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@500000 -e MEM_UOPS_RETIRED:ALL_STORES@500000 -o facesim_l3_output parsec-3.0/pkgs/apps/facesim/inst/amd64-linux.gcc-pthreads/bin/facesim -timing -threads 32 -lastframe 100 2>&1 | tee facesim_reusetracker_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat facesim_overhead.tmp | tee -a $TRACE_FILE >/dev/null

mkdir facesim_rd_l3_output

mv *hpcrun facesim_rd_l3_output

$ReuseTracker_path/bin/hpcstruct parsec-3.0/pkgs/apps/facesim/inst/amd64-linux.gcc-pthreads/bin/facesim

$ReuseTracker_path/bin/hpcprof -S ./facesim.hpcstruct -o facesim_l3_database facesim_l3_output

mv facesim.hpcstruct facesim_rd_l3_output

mv facesim_l3_database facesim_rd_l3_output
