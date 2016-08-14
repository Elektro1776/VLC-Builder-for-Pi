#!/bin/bash
clear
mkdir building
cd building
echo "Removing VLC if installed..."
sudo apt-get purge vlc && sudo apt-get autoremove
clear
echo "Preparing your system..."
sudo apt-get update && sudo apt-get full-upgrade && sudo apt-get autoclean && sudo apt-get clean
echo "Updating gcc..."
sudo apt-get install gcc-4.7 g++-4.7
sudo update-alternatives --remove-all gcc
sudo update-alternatives --remove-all g++
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.6
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7
echo "Select gcc 4.7"
sudo update-alternatives --config gcc
echo "Preparing environment..."
sudo apt-get install git libtool build-essential pkg-config autoconf
echo "Downloading VLC from source..."
git clone git://git.videolan.org/vlc.git
cd vlc
./bootstrap
echo "Installing hardware acceleration modules..."
sudo apt-get install liba52-0.7.4-dev libdirac-dev libdvdread-dev libkate-dev libass-dev libbluray-dev libcddb2-dev libdca-dev libfaad-dev libflac-dev libmad0-dev libmodplug-dev libmpcdec-dev libmpeg2-4-dev libogg-dev libopencv-dev libpostproc-dev libshout3-dev libspeex-dev libspeexdsp-dev libssh2-1-dev liblua5.1-0-dev libopus-dev libschroedinger-dev libsmbclient-dev libtwolame-dev libx264-dev libxcb-composite0-dev libxcb-randr0-dev libxcb-xv0-dev libzvbi-dev
echo "Installing qt libs..."
sudo apt-get install qtcreator
echo "Now compiling, this will take about six hours..."
./configure --enable-rpi-omxil --enable-dvbpsi --enable-x264
make clean all
echo "Now installing..."
sudo make install
sudo ln -s /usr/local/lib/libvlc* /usr/lib/
sudo ln -s /usr/local/lib/libx264.a /usr/lib/
sudo ln -s /usr/local/lib/vlc /usr/lib/vlc
echo "Installation complete"
echo "Trying to run vlc..."
vlc --vout omxil_vout
read -p "Cleanup and delete source to save disk space?";
if [ $REPLY == "yes" ]; then
	cd ..
	sudo rm -rf building
fi
