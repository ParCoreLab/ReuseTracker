#! /bin/bash

rm blackscholes_rd_l1_output/blackscholes-*.communication.reuse.hpcrun
rm blackscholes_rd_l1_output/blackscholes-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py blackscholes_rd_l1_output/blackscholes-*.reuse.hpcrun
rm blackscholes_rd_spatial_l1_output/blackscholes-*.communication.reuse.hpcrun
rm blackscholes_rd_spatial_l1_output/blackscholes-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py blackscholes_rd_spatial_l1_output/blackscholes-*.reuse.hpcrun
rm bodytrack_rd_l1_output/bodytrack-*.communication.reuse.hpcrun
rm bodytrack_rd_l1_output/bodytrack-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py bodytrack_rd_l1_output/bodytrack-*.reuse.hpcrun
rm bodytrack_rd_spatial_l1_output/bodytrack-*.communication.reuse.hpcrun
rm bodytrack_rd_spatial_l1_output/bodytrack-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py bodytrack_rd_spatial_l1_output/bodytrack-*.reuse.hpcrun

rm streamcluster_rd_l1_output/streamcluster-*.communication.reuse.hpcrun
rm streamcluster_rd_l1_output/streamcluster-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py streamcluster_rd_l1_output/streamcluster-*.reuse.hpcrun
rm streamcluster_rd_spatial_l1_output/streamcluster-*.communication.reuse.hpcrun
rm streamcluster_rd_spatial_l1_output/streamcluster-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py streamcluster_rd_spatial_l1_output/streamcluster-*.reuse.hpcrun

rm freqmine_rd_l1_output/freqmine-*.communication.reuse.hpcrun
rm freqmine_rd_l1_output/freqmine-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py freqmine_rd_l1_output/freqmine-*.reuse.hpcrun
rm freqmine_rd_spatial_l1_output/freqmine-*.communication.reuse.hpcrun
rm freqmine_rd_spatial_l1_output/freqmine-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py freqmine_rd_spatial_l1_output/freqmine-*.reuse.hpcrun

python3 ../time-to-stack-conversion/reuse_distance_histo.py blackscholes_rd_l3_output/blackscholes-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py blackscholes_rd_spatial_l3_output/blackscholes-*.shared.reuse.hpcrun

python3 ../time-to-stack-conversion/reuse_distance_histo.py bodytrack_rd_l3_output/bodytrack-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py bodytrack_rd_spatial_l3_output/bodytrack-*.shared.reuse.hpcrun

python3 ../time-to-stack-conversion/reuse_distance_histo.py freqmine_rd_l3_output/freqmine-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py freqmine_rd_spatial_l3_output/freqmine-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py streamcluster_rd_l3_output/streamcluster-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py streamcluster_rd_spatial_l3_output/streamcluster-*.shared.reuse.hpcrun
