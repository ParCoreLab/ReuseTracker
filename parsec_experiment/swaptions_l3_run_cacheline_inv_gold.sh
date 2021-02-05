#! /bin/bash

ReuseTracker_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-pthreads -p swaptions -i native -n 32
/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/apps/swaptions/inst/amd64-linux.gcc-pthreads/bin/swaptions -ns 128 -sm 1000000 -nt 32 2>&1 | tee swaptions_log

rm -r swaptions_l3_output

rm -r swaptions_rd_l3_output

HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=true HPCRUN_WP_REUSE_BIN_SCHEME=4000,2 HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o swaptions_overhead.tmp $ReuseTracker_path/bin/hpcrun -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 -o swaptions_l3_output parsec-3.0/pkgs/apps/swaptions/inst/amd64-linux.gcc-pthreads/bin/swaptions -ns 128 -sm 1000000 -nt 32  2>&1 | tee swaptions_reusetracker_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat swaptions_overhead.tmp | tee -a $TRACE_FILE >/dev/null

mkdir swaptions_rd_l3_output

mv *hpcrun swaptions_rd_l3_output

$ReuseTracker_path/bin/hpcstruct parsec-3.0/pkgs/apps/swaptions/inst/amd64-linux.gcc-pthreads/bin/swaptions

$ReuseTracker_path/bin/hpcprof -S ./swaptions.hpcstruct -o swaptions_l3_database swaptions_l3_output

mv swaptions.hpcstruct swaptions_rd_l3_output

mv swaptions_l3_database swaptions_rd_l3_output
