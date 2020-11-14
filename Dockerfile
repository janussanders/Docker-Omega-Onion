# Omega2 image environment for LEDE 17.01 project 

#Frequently Used Docker Commands
#docker build -t <repo name>/<repo branch>:tag .
#docker ps -a (views all containers)
#docker ps -s (views containers with size)
#docker rm <container ID> (removes a specific container)
#docker rmi <Image ID> (removes a specific image)
#docker daemon --storage-opt dm.basesize=30G (see web for current technique)
#docker system df (system partition sizes)
#docker stats -a (shows running statics of all containers)
#docker run -itd <image ID> (run container)
#docker attach <container ID>(use CTRL-p CTRL-Q to SIGKILL)
#docker rename <container ID> <new name>
#docker start -a -i <container ID>

*** Attach to an image that has no container running ***
docker run -it --rm --privileged --pid=host janussanders/janusinnovations:guncam_rebuild_1701

*** Attach to a Running Container ***
docker exec -it <container name> /bin/bash

*** mount Volume to an image ***
docker run -it --rm --privileged --pid=host -d -v /Users/janussanders/Documents/onion:/root/source/projects/ janussanders/janusinnovations:guncam_rebuild_1701

*** commit container changes to an image ***
Note: this will create a new image so make sure the new name is not the same as
      The original.

docker commit -m "commit message" <container id> janussanders/janusinnovations:Omega_Onion_All_Deps_1701 

*** Building the code ***
sh xCompile.sh -buildroot ~/source/ -lib ugpio

*** Compile individual Modules ***
a. ffmpeg
make V=s package/ffmpeg/{clean,prepare,install,compile} 2>&1 | tee ffmpeg.log
B. libbz2
make V=s package/libbz2/{clean,prepare,install,compile} 2>&1 | tee libbz2.log

*** FFMPEG Dependencies ***
1. libffmpeg-full_3.2.2-1_mipsel_24kc.ipk
2. libbz2_1.0.6-2_mipsel_24kc.ipk
3. alsa-lib_1.1.0-2_mipsel_24kc.ipk
4. libopus_1.1.4-1_mipsel_24kc.ipk
5. libx264_snapshot-20160815-2245-stable-3_mipsel_24kc.ipk
6. ffmpeg_3.2.2-1_mipsel_24kc.ipk

*** FFMPEG Commands ***
ffmpeg -i /dev/video0 -framerate 30 -video_size 1280x720 \
-b:v 2M -c:v mp4 -maxrate 221184k -bufsize 221184k -fs 2M \
-pix_fmt yuv420p -filter:v "setpts=0.9*PTS" -qscale:v 3 -deinterlace -g 30 /tmp/video/test_vid.mp4

ffmpeg -i /dev/video0 -framerate 30 -video_size 1280x720 out.mkv

*** LEDE 18.08 Packages ***
~/source_18.08/bin/targets/ramips/mt76x8/packages

*** Firmware 18.08 ***
~/source_18.08/bin/targets/ramips/mt76x8

#Docker Commands
FROM onion/omega2-source
MAINTAINER janussanders@gmail.com

****************************************************************************************
[Original Omega Onion Distro]
** remove any previous directories if upgrading versions **
rm -R source/ 

** Install required libraries **
apt-get install -y git wget subversion build-essential libncurses5-dev zlib1g-dev gawk flex quilt git-core unzip libssl-dev python-dev python-pip libxml-parser-perl


** download the latest Omega Onion GitHub repo **
git clone https://github.com/OnionIoT/source.git

****************************************************************************************
*** Alternative OpenWrt 18.06.8 Build (MultiMedia) ***
1.
apt-get install -y subversion build-essential libncurses5-dev zlib1g-dev gawk flex quilt git-core unzip libssl-dev

2.
git clone https://git.openwrt.org/openwrt/openwrt.git

3.
cd openwrt

4.
git checkout -b v18.06.8

5.
*Add line to feeds.conf.default file*
src-git onion https://github.com/OnionIoT/OpenWRT-Packages.git

6.
./scripts/feeds update -a
./scripts/feeds install -a
****************************************************************************************

** Configure the target and packages **
7. make menuconfig
8. For Target System, select MediaTek Ralink MIPS
9. For Subtarget, select MT7688 based boards
10. For Target Profile, select Multiple Devices
11. A new item will appear on the Main menu, Target Devices
   For Target Devices, select Onion Omega2 and Onion Omega2+
12. Exit and save your configuration

make -j8 -k V=s
