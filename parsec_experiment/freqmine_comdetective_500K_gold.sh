#! /bin/bash

ComDetective_path=$1

parsec-3.0/bin/parsecmgmt -a run -c gcc-openmp -p freqmine -i native -n 32
GOMP_CPU_AFFINITY="0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31" /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M"  parsec-3.0/pkgs/apps/freqmine/inst/amd64-linux.gcc-openmp/bin/freqmine parsec-3.0/pkgs/apps/freqmine/run/webdocs_250k.dat 11000 2>&1 | tee freqmine_log

rm -r freqmine_output

rm -r freqmine_comdetective_output

GOMP_CPU_AFFINITY="0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31" OMP_NUM_THREADS=32 /usr/bin/time -f "MAX_MEMORY: %M\nTIME: %e" -o freqmine_overhead.tmp  $ComDetective_path/bin/hpcrun -e WP_COMDETECTIVE -e MEM_UOPS_RETIRED:ALL_LOADS@500000 -e MEM_UOPS_RETIRED:ALL_STORES@500000 -o freqmine_output parsec-3.0/pkgs/apps/freqmine/inst/amd64-linux.gcc-openmp/bin/freqmine parsec-3.0/pkgs/apps/freqmine/run/webdocs_250k.dat 11000 2>&1 | tee freqmine_comdetective_log

TRACE_FILE=$(ls -lt | grep reuse.hpcrun | awk '{print $9}')

cat freqmine_overhead.tmp | tee -a $TRACE_FILE >/dev/null

rm freqmine_overhead.tmp

mkdir freqmine_comdetective_output

mv freqmine_comdetective_log freqmine_comdetective_output

$ComDetective_path/bin/hpcstruct parsec-3.0/pkgs/apps/freqmine/inst/amd64-linux.gcc-openmp/bin/freqmine

$ComDetective_path/bin/hpcprof -S ./freqmine.hpcstruct -o freqmine_comdetective_database freqmine_output

mv freqmine_output freqmine_comdetective_output

mv freqmine.hpcstruct freqmine_comdetective_output

mv freqmine_comdetective_database freqmine_comdetective_output
