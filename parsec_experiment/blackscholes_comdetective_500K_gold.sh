#! /bin/bash

ComDetective_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-openmp -p blackscholes -i native -n 32
GOMP_CPU_AFFINITY="0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31"  /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/apps/blackscholes/inst/amd64-linux.gcc-openmp/bin/blackscholes 32 parsec-3.0/pkgs/apps/blackscholes/run/in_10M.txt parsec-3.0/pkgs/apps/blackscholes/run/prices.txt 2>&1 | tee blackscholes_log

rm -r blackscholes_output

rm -r blackscholes_comdetective_output

GOMP_CPU_AFFINITY="0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31" /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o blackscholes_overhead.tmp  $ComDetective_path/bin/hpcrun -e WP_COMDETECTIVE -e MEM_UOPS_RETIRED:ALL_LOADS@500000 -e MEM_UOPS_RETIRED:ALL_STORES@500000 -o blackscholes_output parsec-3.0/pkgs/apps/blackscholes/inst/amd64-linux.gcc-openmp/bin/blackscholes 32 parsec-3.0/pkgs/apps/blackscholes/run/in_10M.txt parsec-3.0/pkgs/apps/blackscholes/run/prices.txt 2>&1 | tee blackscholes_comdetective_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat blackscholes_overhead.tmp | tee -a $TRACE_FILE >/dev/null

rm blackscholes_overhead.tmp

mkdir blackscholes_comdetective_output

mv blackscholes_comdetective_log blackscholes_comdetective_output

$ComDetective_path/bin/hpcstruct parsec-3.0/pkgs/apps/blackscholes/inst/amd64-linux.gcc-openmp/bin/blackscholes

$ComDetective_path/bin/hpcprof -S ./blackscholes.hpcstruct -o blackscholes_comdetective_database blackscholes_output

mv blackscholes_output blackscholes_comdetective_output

mv blackscholes.hpcstruct blackscholes_comdetective_output

mv blackscholes_comdetective_database blackscholes_comdetective_output
