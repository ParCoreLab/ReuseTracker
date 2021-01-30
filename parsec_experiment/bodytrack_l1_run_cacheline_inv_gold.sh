#! /bin/bash

ReuseTracker_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-openmp -p bodytrack -i native -n 32
/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/apps/bodytrack/inst/amd64-linux.gcc-openmp/bin/bodytrack parsec-3.0/pkgs/apps/bodytrack/run/sequenceB_261 4 261 4000 5 0 32 2>&1 | tee bodytrack_log

rm -r bodytrack_l1_output

rm -r bodytrack_rd_l1_output

HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_REUSE_BIN_SCHEME=4000,2 HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true HPCRUN_THREAD_LOCALITY_MAPPING=0%2%4%6%8%10%12%14%16%18%20%22%24%26%28%30#1%3%5%7%9%11%13%15%17%19%21%23%25%27%29%31 /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o bodytrack_overhead.tmp $ReuseTracker_path/bin/hpcrun --mapping 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31 -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 -o bodytrack_l1_output parsec-3.0/pkgs/apps/bodytrack/inst/amd64-linux.gcc-openmp/bin/bodytrack parsec-3.0/pkgs/apps/bodytrack/run/sequenceB_261 4 261 4000 5 0 32 2>&1 | tee bodytrack_reusetracker_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat bodytrack_overhead.tmp | tee -a $TRACE_FILE >/dev/null

rm bodytrack_overhead.tmp

mkdir bodytrack_rd_l1_output

mv *hpcrun bodytrack_rd_l1_output

$ReuseTracker_path/bin/hpcstruct parsec-3.0/pkgs/apps/bodytrack/inst/amd64-linux.gcc-openmp/bin/bodytrack

$ReuseTracker_path/bin/hpcprof -S ./bodytrack.hpcstruct -o bodytrack_l1_database bodytrack_l1_output

mv bodytrack.hpcstruct bodytrack_rd_l1_output

mv bodytrack_l1_database bodytrack_rd_l1_output
