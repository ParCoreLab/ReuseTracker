
install:
	git clone https://github.com/WitchTools/hpctoolkit-externals
	cd hpctoolkit-externals && ./configure && make -j`nproc` && make install
	git clone https://github.com/WitchTools/libmonitor
	PWD=`pwd` && cd libmonitor && ./configure --prefix=$(PWD)/libmonitor-bin && make -j`nproc` && make install
	git clone https://github.com/msasongko17/hpctoolkit
	PWD=`pwd` && cd hpctoolkit && ./configure --prefix=$(PWD)/reusetracker-bin --with-externals=$(PWD)/hpctoolkit-externals/x86_64-unknown-linux-gnu --with-libmonitor=$(PWD)/libmonitor-bin && make -j`nproc` && make install
	#cd ..


short-rd-inc:
	PWD=`pwd` && HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true OMP_NUM_THREADS=32 GOMP_CPU_AFFINITY="0 20 1 21 2 22 3 23 4 24 5 25 6 26 7 27 10 30 11 31 12 32 13 33 14 34 15 35 16 36 17 37" HPCRUN_WP_REUSE_BIN_SCHEME=1100,2 /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" $(PWD)/reusetracker-bin/bin/hpcrun  -o short_rd_inc_output -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 reuse-invalidation-benchs/reuse-invalidation -outer 10 -a0 50 -a1 100000 -b0 40 -b1 200000 -c0 40 -c1 400000 -d0 10 -d1 800000 -e0 3 -e1 1600000 -inv 1 2>&1 | tee short_rd_inc_log
short-rd-dec:
short-rd-bell:
short-rd-multi-mod:
long-rd-inc:
long-rd-dec:
long-rd-bell:
long-rd-multi-mod:
