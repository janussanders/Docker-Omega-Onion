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

docker run -it --rm --privileged --pid=host janussanders/janusinnovations:guncam_rebuild_1701

docker exec -it <container name> /bin/bash

docker run -it --rm --privileged --pid=host -d -v /Users/janussanders/Documents/onion:/root/source/projects/ janussanders/janusinnovations:guncam_rebuild_1701

*** Building the code ***
sh xCompile.sh -buildroot ~/source/ -lib ugpio

*** Compile individual Modules ***
make V=s package/ffmpeg-custom/{clean,prepare,compile} 2>&1 | tee ffmpeg-custom.log


*** LEDE 18.08 Packages ***
~/source_18.08/bin/targets/ramips/mt76x8/packages

*** Firmware 18.08 ***
~/source_18.08/bin/targets/ramips/mt76x8

#Docker Commands
FROM onion/omega2-source
MAINTAINER janussanders@gmail.com

RUN apt-get update
RUN apt-get -f install -y
RUN apt-get install apt-utils time -y
RUN git checkout .config
RUN git checkout lede-17.01
RUN git pull
RUN ./scripts/feeds update -a
RUN ./scripts/feeds install -a

RUN make -j1 V=s
