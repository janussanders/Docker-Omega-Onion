# Omega2 image environment for LEDE 17.01 project 

#Frequently Used Docker Commands
#docker build -t <repo name>/<repo branch>:tag .
#docker ps -a (views all containers)
#docker ps -s (views containers with size)
#docker rm <container ID> (removes a specific container)
#docker rmi <Image ID> (removes a specific image)
#docker daemon --storage-opt dm.basesize=30G
#docker system df (system partition sizes)

#docker run -itd <image ID> (run container)
#docker attach <container ID>(attaches CTRL-p CTRL-Q to SIGKILL)

#docker rename <container ID> <new name>
#docker start -a -i <container ID>


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
