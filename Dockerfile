#install base ubuntu image
FROM ubuntu:16.04 

 #set a working directory
WORKDIR /code     

RUN apt-get update && \   
    apt-get install sudo && \
    apt-get install unzip -y

#install build essentials for cmake and other dependencies
RUN sudo apt-get install build-essential -y 

#install qiBuild and QTCreator

RUN sudo apt-get install qtcreator -y && \
    sudo apt-get install qt5-default -y

#copy current folder content to code directory
copy . /code 

#install cmake 2.8.
RUN cd intu_dependencies && \
    tar xzf cmake-2.8.12.2.tar.gz && \
    cd cmake-2.8.12.2 && \
    ./configure && make && sudo make install


RUN sudo apt-get install python-pip -y && \
    pip install --upgrade pip && \
    pip install qibuild 

RUN printf "%s\n" "1" "2" "Y" | qibuild config --wizard


#install Opencv repo

RUN cd intu_dependencies && \
    unzip opencv-2.4.9.zip && \
    sudo apt-get install git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev -y && \
    cd opencv-2.4.9 && \
    mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
    make -j7 && \
    sudo make install 

#install lib ssl for OpenSSL and libboost version 1.58
RUN sudo apt-get install libssl-dev -y && sudo apt-get install libboost-all-dev -y

RUN ./scripts/build_linux.sh

#expose image port 
EXPOSE 9443

CMD ["bin/linux/run_self.sh"]

