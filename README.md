Requirement
===============
Linux kernel version 5.0.0 or higher

Installation
===============
1. Install hpctoolkit-externals from https://github.com/WitchTools/hpctoolkit-externals 
by typing the following command in the directory of hpctoolkit-externals:
	./configure && make && make install
2. Install the custom libmonitor from https://github.com/WitchTools/libmonitor 
by typing the following command in the directory of libmonitor:
	./configure --prefix=<libmonitor-installation directory> && make && make install 
3. Install HPCToolkit with ReuseTracker extensions from 
https://github.com/ParCoreLab/hpctoolkit pointing to the installations of 
hpctoolkit-externals and libmonitor from steps \#1 and \#2. 
Assuming that the underlying architecture is x86_64 and compiler is gcc, this step is performed with the following commands.

a. ./configure --prefix=<targeted installation directory for ComDetective> --with-externals=<directory of hpctoolkit externals>/x86_64-unknown-linux-gnu --with-libmonitor=<libmonitor-installation directory> 

b. make

c. make install
