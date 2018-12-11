#Download base image Ubuntu 16.04
FROM ubuntu:16.04

SHELL ["/bin/bash", "-c"]

# virtualenv and virtualenvwrapper
ENV HOME /root
ENV WORKON_HOME $HOME/.virtualenvs
ENV VIRTUALENVWRAPPER_PYTHON /usr/bin/python3

# Install os updates
RUN	apt-get -y update && \
	apt-get -y upgrade && \
	apt-get -y install build-essential cmake unzip pkg-config wget && \
	apt-get -y install libjpeg-dev libpng-dev libtiff-dev && \
	apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev && \
	apt-get -y install libxvidcore-dev libx264-dev && \
	apt-get -y install libgtk-3-dev && \
	apt-get -y install libatlas-base-dev gfortran && \
	apt-get -y install python3-dev

# install pip
RUN	echo $HOME && \
	wget https://bootstrap.pypa.io/get-pip.py && \
	python3 get-pip.py && \
	pip install virtualenv virtualenvwrapper && \
	rm -rf ~/get-pip.py ~/.cache/pip ~/.bashrc && \
	source /usr/local/bin/virtualenvwrapper.sh && \
	echo -e '\n# virtualenv and virtualenvwrapper' >> ~/.bashrc && \
	echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.bashrc && \
	echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' >> ~/.bashrc && \
	echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc && \
	source ~/.bashrc && \
	cat ~/.bashrc && \
	mkvirtualenv cv -p python3

# Download opencv
RUN mkdir ~/source && \
	cd ~/source && \
	wget -O opencv.zip https://github.com/opencv/opencv/archive/4.0.0.zip && \
	wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.0.0.zip && \
	unzip opencv.zip && \
	unzip opencv_contrib.zip && \
	mv opencv-4.0.0 opencv && \
	mv opencv_contrib-4.0.0 opencv_contrib

# prep for opencv 
RUN source ~/.bashrc && \
	workon cv && \
	pip install numpy

# install opencv
RUN source ~/.bashrc && \
	workon cv && \
	cd ~/source/opencv && \
	mkdir build && \
	cd build && \

	cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D INSTALL_C_EXAMPLES=OFF \
	-D OPENCV_ENABLE_NONFREE=ON \
	-D OPENCV_EXTRA_MODULES_PATH=~/source/opencv_contrib/modules \
	-D PYTHON_EXECUTABLE=~/.virtualenvs/cv/bin/python \
	-D BUILD_EXAMPLES=ON .. && \

	make -j4 && \
	make install && \
	ldconfig

# check install and set links
RUN	source ~/.bashrc && \
	workon cv && \
	python --version && \

	# link python
	cd ~/.virtualenvs/cv/lib/python3.5/site-packages/ && \
	ln -s /usr/local/python/cv2 cv2 && \
	cd ~