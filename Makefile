
install:
	git clone https://github.com/WitchTools/hpctoolkit-externals
	cd hpctoolkit-externals && ./configure && make -j`nproc` && make install
	git clone https://github.com/WitchTools/libmonitor
	PWD=`pwd` && cd libmonitor && ./configure --prefix=$(PWD)/libmonitor-bin && make -j`nproc` && make install
	git clone https://github.com/msasongko17/hpctoolkit
	PWD=`pwd` && cd hpctoolkit && ./configure --prefix=$(PWD)/reusetracker-bin --with-externals=$(PWD)/hpctoolkit-externals/x86_64-unknown-linux-gnu --with-libmonitor=$(PWD)/libmonitor-bin && make -j`nproc` && make install
	#cd ..

no-invalidation: short-rd long-rd

short-rd:	short-rd-inc short-rd-dec short-rd-bell short-rd-multi-mod

short-rd-inc:
	PWD=`pwd` && HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true OMP_NUM_THREADS=32 HPCRUN_WP_REUSE_BIN_SCHEME=1100,2 /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" $(PWD)/reusetracker-bin/bin/hpcrun  -o short_inc_output -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 reuse-invalidation-benchs/reuse-invalidation -outer 10 -a0 20 -a1 1000 -b0 20 -b1 2000 -c0 20 -c1 4000 -d0 20 -d1 8000 -e0 20 -e1 16000 -inv 1 2>&1 | tee short_rd_inc_log
	mkdir short_rd_inc_output
	mv *hpcrun short_rd_inc_output 
short-rd-dec:
	PWD=`pwd` && HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true OMP_NUM_THREADS=32 HPCRUN_WP_REUSE_BIN_SCHEME=1100,2 /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" $(PWD)/reusetracker-bin/bin/hpcrun  -o short_dec_output -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 reuse-invalidation-benchs/reuse-invalidation -outer 10 -a0 200 -a1 1000 -b0 60 -b1 2000 -c0 15 -c1 4000 -d0 4 -d1 8000 -e0 2 -e1 16000 -inv 1 2>&1 | tee short_rd_dec_log
	mkdir short_rd_dec_output
	mv *hpcrun short_rd_dec_output
short-rd-bell:
	PWD=`pwd` && HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true OMP_NUM_THREADS=32 HPCRUN_WP_REUSE_BIN_SCHEME=1100,2 /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" $(PWD)/reusetracker-bin/bin/hpcrun  -o short_bell_output -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 reuse-invalidation-benchs/reuse-invalidation -outer 10 -a0 50 -a1 1000 -b0 40 -b1 2000 -c0 40 -c1 4000 -d0 10 -d1 8000 -e0 3 -e1 16000 -inv 1 2>&1 | tee short_rd_bell_log
	mkdir short_rd_bell_output
	mv *hpcrun short_rd_bell_output
short-rd-multi-mod:
	PWD=`pwd` && HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true OMP_NUM_THREADS=32 HPCRUN_WP_REUSE_BIN_SCHEME=1100,2 /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" $(PWD)/reusetracker-bin/bin/hpcrun  -o short_multi_mod_output -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 reuse-invalidation-benchs/reuse-invalidation -outer 10 -a0 100 -a1 1000 -b0 30 -b1 2000 -c0 24 -c1 4000 -d0 8 -d1 8000 -e0 7 -e1 16000 -inv 1 2>&1 | tee short_rd_multi_mod_log
	mkdir short_rd_multi_mod_output
	mv *hpcrun short_rd_multi_mod_output

long-rd:       long-rd-inc long-rd-dec long-rd-bell long-rd-multi-mod

long-rd-inc:
	PWD=`pwd` && HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true OMP_NUM_THREADS=32 HPCRUN_WP_REUSE_BIN_SCHEME=110000,2 /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" $(PWD)/reusetracker-bin/bin/hpcrun  -o long_inc_output -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 reuse-invalidation-benchs/reuse-invalidation -outer 10 -a0 10 -a1 100000 -b0 10 -b1 200000 -c0 10 -c1 400000 -d0 10 -d1 800000 -e0 10 -e1 1600000 -inv 1 2>&1 | tee long_rd_inc_log
		mkdir long_rd_inc_output
		mv *hpcrun long_rd_inc_output
long-rd-dec:
	PWD=`pwd` && HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true OMP_NUM_THREADS=32 HPCRUN_WP_REUSE_BIN_SCHEME=110000,2 /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" $(PWD)/reusetracker-bin/bin/hpcrun  -o long_dec_output -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 reuse-invalidation-benchs/reuse-invalidation -outer 10 -a0 100 -a1 100000 -b0 30 -b1 200000 -c0 12 -c1 400000 -d0 5 -d1 800000 -e0 2 -e1 1600000 -inv 1 2>&1 | tee long_rd_dec_log
	mkdir long_rd_dec_output
	mv *hpcrun long_rd_dec_output
long-rd-bell:
	PWD=`pwd` && HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true OMP_NUM_THREADS=32 HPCRUN_WP_REUSE_BIN_SCHEME=110000,2 /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" $(PWD)/reusetracker-bin/bin/hpcrun  -o long_bell_output -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 reuse-invalidation-benchs/reuse-invalidation -outer 10 -a0 50 -a1 100000 -b0 40 -b1 200000 -c0 40 -c1 400000 -d0 10 -d1 800000 -e0 3 -e1 1600000 -inv 1 2>&1 | tee long_rd_bell_log
	mkdir long_rd_bell_output
	mv *hpcrun long_rd_bell_output
long-rd-multi-mod:
	PWD=`pwd` && HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true OMP_NUM_THREADS=32 HPCRUN_WP_REUSE_BIN_SCHEME=110000,2 /usr/bin/time -f "Elapsed Time , %e, system, %S, user, %U, memory, %M" $(PWD)/reusetracker-bin/bin/hpcrun  -o long_multi_mod_output -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 reuse-invalidation-benchs/reuse-invalidation -outer 10 -a0 100 -a1 100000 -b0 30 -b1 200000 -c0 24 -c1 400000 -d0 8 -d1 800000 -e0 7 -e1 1600000 -inv 1 2>&1 | tee long_rd_multi_mod_log
	mkdir long_rd_multi_mod_output
	mv *hpcrun long_rd_multi_mod_output
