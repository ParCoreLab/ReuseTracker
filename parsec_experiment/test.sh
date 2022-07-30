
rm freqmine_rd_l1_output/freqmine-*.communication.reuse.hpcrun
rm freqmine_rd_l1_output/freqmine-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py freqmine_rd_l1_output/freqmine-*.reuse.hpcrun
rm freqmine_rd_spatial_l1_output/freqmine-*.communication.reuse.hpcrun
rm freqmine_rd_spatial_l1_output/freqmine-*.shared.reuse.hpcrun
python3 ../time-to-stack-conversion/reuse_distance_histo.py freqmine_rd_spatial_l1_output/freqmine-*.reuse.hpcrun
