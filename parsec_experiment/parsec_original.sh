#! /bin/bash

GOMP_CPU_AFFINITY="0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39" /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/apps/blackscholes/inst/amd64-linux.gcc-openmp/bin/blackscholes 32 parsec-3.0/pkgs/apps/blackscholes/run/in_10M.txt parsec-3.0/pkgs/apps/blackscholes/run/prices.txt 2>&1 | tee blackscholes_original_log

GOMP_CPU_AFFINITY="0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39" /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/apps/bodytrack/inst/amd64-linux.gcc-openmp/bin/bodytrack parsec-3.0/pkgs/apps/bodytrack/run/sequenceB_261 4 261 4000 5 0 32 2>&1 | tee bodytrack_original_log

/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" /home/msasongko17/research/likwid-install/bin/likwid-pin -c N:0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39  parsec-3.0/pkgs/kernels/dedup/inst/amd64-linux.gcc-pthreads/bin/dedup -c -p -v -t 32 -i parsec-3.0/pkgs/kernels/dedup/run/FC-6-x86_64-disc1.iso -o parsec-3.0/pkgs/kernels/dedup/run/output.dat.ddp 2>&1 | tee dedup_original_log

/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" /home/msasongko17/research/likwid-install/bin/likwid-pin -c N:0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39 parsec-3.0/pkgs/apps/ferret/inst/amd64-linux.gcc-pthreads/bin/ferret parsec-3.0/pkgs/apps/ferret/run/corel lsh parsec-3.0/pkgs/apps/ferret/run/queries 50 20 32 parsec-3.0/pkgs/apps/ferret/run/output.txt 2>&1 | tee ferret_original_log

/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" /home/msasongko17/research/likwid-install/bin/likwid-pin -c N:0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39 parsec-3.0/pkgs/apps/fluidanimate/inst/amd64-linux.gcc-pthreads/bin/fluidanimate 32 500 parsec-3.0/pkgs/apps/fluidanimate/run/in_500K.fluid parsec-3.0/pkgs/apps/fluidanimate/run/out.fluid 2>&1 | tee fluidanimate_original_log

GOMP_CPU_AFFINITY="0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39" /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" parsec-3.0/pkgs/apps/freqmine/inst/amd64-linux.gcc-openmp/bin/freqmine parsec-3.0/pkgs/apps/freqmine/run/webdocs_250k.dat 11000 2>&1 | tee freqmine_original_log

/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" /home/msasongko17/research/likwid-install/bin/likwid-pin -c N:0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39 parsec-3.0/pkgs/kernels/streamcluster/inst/amd64-linux.gcc-pthreads/bin/streamcluster 10 20 128 1000000 200000 5000 none output.txt 32 2>&1 | tee streamcluster_original_log

/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" /home/msasongko17/research/likwid-install/bin/likwid-pin -c N:0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39 parsec-3.0/pkgs/apps/swaptions/inst/amd64-linux.gcc-pthreads/bin/swaptions -ns 128 -sm 1000000 -nt 32  2>&1 | tee swaptions_original_log

/usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" /home/msasongko17/research/likwid-install/bin/likwid-pin -c N:0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39 parsec-3.0/pkgs/apps/vips/inst/amd64-linux.gcc-pthreads/bin/vips im_benchmark parsec-3.0/pkgs/apps/vips/run/orion_18000x18000.v parsec-3.0/pkgs/apps/vips/run/output.v  2>&1 | tee vips_original_log
