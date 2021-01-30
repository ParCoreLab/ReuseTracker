#! /bin/bash
grep -rl "HUGE" parsec-3.0/pkgs/apps/ferret | xargs sed -i "s/HUGE/DBL_MAX/g"
grep -rl "HUGE" parsec-3.0/pkgs/netapps/netferret | xargs sed -i "s/HUGE/DBL_MAX/g"

