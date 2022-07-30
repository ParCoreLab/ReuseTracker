#! /bin/bash

ComDetective_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-pthreads -p streamcluster -i native -n 32
/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/kernels/streamcluster/inst/amd64-linux.gcc-pthreads/bin/streamcluster 10 20 128 1000000 200000 5000 none output.txt 32 2>&1 | tee streamcluster_log

rm -r streamcluster_output

rm -r streamcluster_comdetective_output

/usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o streamcluster_overhead.tmp $ComDetective_path/bin/hpcrun --mapping 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31  -e WP_COMDETECTIVE -e MEM_UOPS_RETIRED:ALL_LOADS@500000 -e MEM_UOPS_RETIRED:ALL_STORES@500000 -o streamcluster_output parsec-3.0/pkgs/kernels/streamcluster/inst/amd64-linux.gcc-pthreads/bin/streamcluster 10 20 128 1000000 200000 5000 none output.txt 32 2>&1 | tee streamcluster_comdetective_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat streamcluster_overhead.tmp | tee -a $TRACE_FILE >/dev/null

rm streamcluster_overhead.tmp

mkdir streamcluster_comdetective_output

mv streamcluster_comdetective_log streamcluster_comdetective_output

$ComDetective_path/bin/hpcstruct parsec-3.0/pkgs/apps/streamcluster/inst/amd64-linux.gcc-openmp/bin/streamcluster

$ComDetective_path/bin/hpcprof -S ./streamcluster.hpcstruct -o streamcluster_comdetective_database streamcluster_output

mv streamcluster_output streamcluster_comdetective_output

mv streamcluster.hpcstruct streamcluster_comdetective_output

mv streamcluster_comdetective_database streamcluster_comdetective_output
