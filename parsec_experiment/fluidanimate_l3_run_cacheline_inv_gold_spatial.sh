#! /bin/bash

ReuseTracker_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-pthreads -p fluidanimate -i native -n 32
/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/apps/fluidanimate/inst/amd64-linux.gcc-pthreads/bin/fluidanimate 32 500 parsec-3.0/pkgs/apps/fluidanimate/run/in_500K.fluid parsec-3.0/pkgs/apps/fluidanimate/run/out.fluid 2>&1 | tee fluidanimate_log

HPCRUN_WP_REUSE_PROFILE_TYPE="SPATIAL" HPCRUN_PROFILE_L3=true HPCRUN_WP_REUSE_BIN_SCHEME=4000,2 HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o fluidanimate_overhead.tmp $ReuseTracker_path/bin/hpcrun -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@500000 -e MEM_UOPS_RETIRED:ALL_STORES@500000 -o fluidanimate_l3_output parsec-3.0/pkgs/apps/fluidanimate/inst/amd64-linux.gcc-pthreads/bin/fluidanimate 32 500 parsec-3.0/pkgs/apps/fluidanimate/run/in_500K.fluid parsec-3.0/pkgs/apps/fluidanimate/run/out.fluid 2>&1 | tee fluidanimate_reusetracker_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat fluidanimate_overhead.tmp | tee -a $TRACE_FILE >/dev/null

mkdir fluidanimate_rd_l3_output

mv *hpcrun fluidanimate_rd_l3_output

$ReuseTracker_path/bin/hpcstruct parsec-3.0/pkgs/apps/fluidanimate/inst/amd64-linux.gcc-pthreads/bin/fluidanimate

$ReuseTracker_path/bin/hpcprof -S ./fluidanimate.hpcstruct -o fluidanimate_l3_database fluidanimate_l3_output

mv fluidanimate.hpcstruct fluidanimate_rd_l3_output

mv fluidanimate_l3_database fluidanimate_rd_l3_output
