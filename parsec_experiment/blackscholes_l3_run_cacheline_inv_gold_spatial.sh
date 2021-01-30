#! /bin/bash

ReuseTracker_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-openmp -p blackscholes -i native -n 32
/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M"  parsec-3.0/pkgs/apps/blackscholes/inst/amd64-linux.gcc-openmp/bin/blackscholes 32 parsec-3.0/pkgs/apps/blackscholes/run/in_10M.txt parsec-3.0/pkgs/apps/blackscholes/run/prices.txt 2>&1 | tee blackscholes_log

rm -r blackscholes_l3_output

rm -r blackscholes_rd_l3_output

HPCRUN_WP_REUSE_PROFILE_TYPE="SPATIAL" HPCRUN_PROFILE_L3=true HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true HPCRUN_WP_REUSE_BIN_SCHEME=4000,2 HPCRUN_THREAD_LOCALITY_MAPPING=0%2%4%6%8%10%12%14%16%18%20%22%24%26%28%30#1%3%5%7%9%11%13%15%17%19%21%23%25%27%29%31 /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o blackscholes_overhead.tmp $ReuseTracker_path/bin/hpcrun --mapping 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31 -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 -o blackscholes_l3_output parsec-3.0/pkgs/apps/blackscholes/inst/amd64-linux.gcc-openmp/bin/blackscholes 32 parsec-3.0/pkgs/apps/blackscholes/run/in_10M.txt parsec-3.0/pkgs/apps/blackscholes/run/prices.txt 2>&1 | tee blackscholes_reusetracker_l3_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat blackscholes_overhead.tmp | tee -a $TRACE_FILE >/dev/null

mkdir blackscholes_rd_l3_output

mv *hpcrun blackscholes_rd_l3_output

$ReuseTracker_path/bin/hpcstruct parsec-3.0/pkgs/apps/blackscholes/inst/amd64-linux.gcc-openmp/bin/blackscholes

$ReuseTracker_path/bin/hpcprof -S ./blackscholes.hpcstruct -o blackscholes_l3_database blackscholes_l3_output

mv blackscholes.hpcstruct blackscholes_rd_l3_output

mv blackscholes_l3_database blackscholes_rd_l3_output
