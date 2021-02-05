#! /bin/bash

ReuseTracker_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-openmp -p bodytrack -i native -n 32
/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/apps/bodytrack/inst/amd64-linux.gcc-openmp/bin/bodytrack parsec-3.0/pkgs/apps/bodytrack/run/sequenceB_261 4 261 4000 5 0 32 2>&1 | tee bodytrack_log

rm -r bodytrack_l3_output

rm -r bodytrack_rd_l3_output

HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=true HPCRUN_WP_REUSE_BIN_SCHEME=4000,2 HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o bodytrack_overhead.tmp $ReuseTracker_path/bin/hpcrun -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 -o bodytrack_l3_output parsec-3.0/pkgs/apps/bodytrack/inst/amd64-linux.gcc-openmp/bin/bodytrack parsec-3.0/pkgs/apps/bodytrack/run/sequenceB_261 4 261 4000 5 0 32 2>&1 | tee bodytrack_reusetracker_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat bodytrack_overhead.tmp | tee -a $TRACE_FILE >/dev/null

mkdir bodytrack_rd_l3_output

mv *hpcrun bodytrack_rd_l3_output

$ReuseTracker_path/bin/hpcstruct parsec-3.0/pkgs/apps/bodytrack/inst/amd64-linux.gcc-openmp/bin/bodytrack

$ReuseTracker_path/bin/hpcprof -S ./bodytrack.hpcstruct -o bodytrack_l3_database bodytrack_l3_output

mv bodytrack.hpcstruct bodytrack_rd_l3_output

mv bodytrack_l3_database bodytrack_rd_l3_output
