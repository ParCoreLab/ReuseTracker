#! /bin/bash

ReuseTracker_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-openmp -p freqmine -i native -n 32
GOMP_CPU_AFFINITY="0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31" /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M"  parsec-3.0/pkgs/apps/freqmine/inst/amd64-linux.gcc-openmp/bin/freqmine parsec-3.0/pkgs/apps/freqmine/run/webdocs_250k.dat 11000 2>&1 | tee freqmine_log

rm -r freqmine_l3_output

rm -r freqmine_rd_l3_output

GOMP_CPU_AFFINITY="0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31" HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=true HPCRUN_WP_REUSE_BIN_SCHEME=4000,2 HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true OMP_NUM_THREADS=32 HPCRUN_THREAD_LOCALITY_MAPPING=0%2%4%6%8%10%12%14%16%18%20%22%24%26%28%30#1%3%5%7%9%11%13%15%17%19%21%23%25%27%29%31 /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o freqmine_overhead.tmp $ReuseTracker_path/bin/hpcrun -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@500000 -e MEM_UOPS_RETIRED:ALL_STORES@500000 -o freqmine_l3_output parsec-3.0/pkgs/apps/freqmine/inst/amd64-linux.gcc-openmp/bin/freqmine parsec-3.0/pkgs/apps/freqmine/run/webdocs_250k.dat 11000 2>&1 | tee freqmine_reusetracker_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat freqmine_overhead.tmp | tee -a $TRACE_FILE >/dev/null

rm freqmine_overhead.tmp

mkdir freqmine_rd_l3_output

mv *hpcrun freqmine_rd_l3_output

$ReuseTracker_path/bin/hpcstruct parsec-3.0/pkgs/apps/freqmine/inst/amd64-linux.gcc-openmp/bin/freqmine

$ReuseTracker_path/bin/hpcprof -S ./freqmine.hpcstruct -o freqmine_l3_database freqmine_l3_output

mv freqmine.hpcstruct freqmine_rd_l3_output

mv freqmine_l3_database freqmine_rd_l3_output
