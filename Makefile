
install:
	git clone https://github.com/WitchTools/hpctoolkit-externals
	cd hpctoolkit-externals && ./configure && make -j`nproc` && make install
	git clone https://github.com/WitchTools/libmonitor
	PWD=`pwd` && cd libmonitor && ./configure --prefix=$(PWD)/libmonitor-bin && make -j`nproc` && make install
	git clone https://github.com/msasongko17/hpctoolkit
	PWD=`pwd` && cd hpctoolkit && ./configure --prefix=$(PWD)/reusetracker-bin --with-externals=$(PWD)/hpctoolkit-externals/x86_64-unknown-linux-gnu --with-libmonitor=$(PWD)/libmonitor-bin && make -j`nproc` && make install
	#cd ..


