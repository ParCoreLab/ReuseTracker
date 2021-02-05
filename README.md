Requirement
===============
- Linux kernel version 5.0.0 or higher
- Python 3.x
- Python's scipy module installed with "pip3 install scipy" command
- Python's termcolor module installed with "pip3 install termcolor" command

Installation
===============
To install ReuseTracker and all of its dependences, type "make install".

Reproducing Results from The Paper
===============
1. To reproduce the results presented in the "Accuracy without Invalidation" 
and "Accuracy with Invalidation" subsections in the paper, ensure that you have enough 
maximum stack size by typing "ulimit -s 4194304" and run the experiment by typing "make accuracy".
The resulting histograms can be found in each *_output folder with file name 
reuse-invalidation-PID.reuse.hpcrun.
2. To reproduce the results presented in the "Reuse Distances of PARSEC Benchmarks" 
section, type "make parsec".  The resulting histograms are in the following files.
	- parsec_experiment/blackscholes_rd_l1_output/blackscholes-PID.reuse.hpcrun.bin
	- parsec_experiment/blackscholes_rd_spatial_l1_output/blackscholes-PID.reuse.hpcrun.bin 
	- parsec_experiment/bodytrack_rd_l1_output/bodytrack-PID.reuse.hpcrun.bin
	- parsec_experiment/bodytrack_rd_spatial_l1_output/bodytrack-PID.reuse.hpcrun.bin
	- parsec_experiment/streamcluster_rd_l3_output/streamcluster-PID.reuse.hpcrun.bin
        - parsec_experiment/streamcluster_rd_spatial_l1_output/streamcluster-PID.reuse.hpcrun.bin 
        - parsec_experiment/freqmine_rd_l1_output/freqmine-PID.reuse.hpcrun.bin
        - parsec_experiment/freqmine_rd_spatial_l1_output/freqmine-PID.reuse.hpcrun.bin

Running ReuseTracker to profile An Individual Application 
===============
- To profile the private cache temporal reuse distance of an application, run the following command.

HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=false HPCRUN_WP_REUSE_BIN_SCHEME=4000,2 HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true reusetracker-bin/bin/hpcrun -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 <application's name> <command line arguments>

- To profile the shared cache temporal reuse distance of an application, run the following command.

HPCRUN_WP_REUSE_PROFILE_TYPE="TEMPORAL" HPCRUN_PROFILE_L3=true HPCRUN_WP_REUSE_BIN_SCHEME=4000,2 HPCRUN_WP_CACHELINE_INVALIDATION=true HPCRUN_WP_DONT_FIX_IP=true HPCRUN_WP_DONT_DISASSEMBLE_TRIGGER_ADDRESS=true reusetracker-bin/bin/hpcrun -e WP_REUSETRACKER -e MEM_UOPS_RETIRED:ALL_LOADS@100000 -e MEM_UOPS_RETIRED:ALL_STORES@100000 <application's name> <command line arguments>
