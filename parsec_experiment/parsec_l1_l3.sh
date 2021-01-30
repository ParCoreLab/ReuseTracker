#! /bin/bash

./blackscholes_l1_run_cacheline_inv_gold.sh $1
./blackscholes_l1_run_cacheline_inv_gold_spatial.sh $1
./bodytrack_l1_run_cacheline_inv_gold.sh $1
./bodytrack_l1_run_cacheline_inv_gold_spatial.sh $1
./streamcluster_l3_run_cacheline_inv_gold.sh $1
./streamcluster_l3_run_cacheline_inv_gold_spatial.sh $1
./freqmine_l3_run_cacheline_inv_gold.sh $1
./freqmine_l3_run_cacheline_inv_gold_spatial.sh $1
