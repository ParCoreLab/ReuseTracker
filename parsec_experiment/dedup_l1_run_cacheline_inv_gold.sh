#! /bin/bash

ReuseTracker_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-pthreads -p dedup -i native -n 32
/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/kernels/dedup/inst/amd64-linux.gcc-pthreads/bin/dedup -c -p -v -t 32 -i parsec-3.0/pkgs/kernels/dedup/run/FC-6-x86_64-disc1.iso -o parsec-3.0/pkgs/kernels/dedup/run/output.dat.ddp 2>&1 | tee dedup_log

HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_REUSE_BIN_SCHEME=4000,2 HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o dedup_overhead.tmp  $ReuseTracker_path/bin/hpcrun -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 -o dedup_l1_output parsec-3.0/pkgs/kernels/dedup/inst/amd64-linux.gcc-pthreads/bin/dedup -c -p -v -t 32 -i parsec-3.0/pkgs/kernels/dedup/run/FC-6-x86_64-disc1.iso -o parsec-3.0/pkgs/kernels/dedup/run/output.dat.ddp 2>&1 | tee dedup_reusetracker_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat dedup_overhead.tmp | tee -a $TRACE_FILE >/dev/null

rm dedup_overhead.tmp

mkdir dedup_rd_l1_output

mv *hpcrun dedup_rd_l1_output

$ReuseTracker_path/bin/hpcstruct parsec-3.0/pkgs/kernels/dedup/inst/amd64-linux.gcc-pthreads/bin/dedup

$ReuseTracker_path/bin/hpcprof -S ./dedup.hpcstruct -o dedup_l1_database dedup_l1_output

mv dedup.hpcstruct dedup_rd_l1_output

mv dedup_l1_database dedup_rd_l1_output
