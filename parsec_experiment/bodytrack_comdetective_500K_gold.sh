#! /bin/bash

ComDetective_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-openmp -p bodytrack -i native -n 32
GOMP_CPU_AFFINITY="0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31" /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/apps/bodytrack/inst/amd64-linux.gcc-openmp/bin/bodytrack parsec-3.0/pkgs/apps/bodytrack/run/sequenceB_261 4 261 4000 5 0 32 2>&1 | tee bodytrack_log

rm -r bodytrack_output

rm -r bodytrack_comdetective_output

GOMP_CPU_AFFINITY="0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31" /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o bodytrack_overhead.tmp $ComDetective_path/bin/hpcrun -e WP_COMDETECTIVE -e MEM_UOPS_RETIRED:ALL_LOADS@500000 -e MEM_UOPS_RETIRED:ALL_STORES@500000 -o bodytrack_output parsec-3.0/pkgs/apps/bodytrack/inst/amd64-linux.gcc-openmp/bin/bodytrack parsec-3.0/pkgs/apps/bodytrack/run/sequenceB_261 4 261 4000 5 0 32 2>&1 | tee bodytrack_comdetective_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat bodytrack_overhead.tmp | tee -a $TRACE_FILE >/dev/null

rm bodytrack_overhead.tmp

mkdir bodytrack_comdetective_output

mv bodytrack_comdetective_log bodytrack_comdetective_output

$ComDetective_path/bin/hpcstruct parsec-3.0/pkgs/apps/bodytrack/inst/amd64-linux.gcc-openmp/bin/bodytrack

$ComDetective_path/bin/hpcprof -S ./bodytrack.hpcstruct -o bodytrack_comdetective_database bodytrack_output

mv bodytrack_output bodytrack_comdetective_output

mv bodytrack.hpcstruct bodytrack_comdetective_output

mv bodytrack_comdetective_database bodytrack_comdetective_output
