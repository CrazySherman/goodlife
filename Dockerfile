FROM nvidia/cuda:9.0-cudnn7-devel

RUN apt-get update
RUN apt-get -qq install -y python2.7 libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libatlas-base-dev unzip zip cmake
RUN apt-get -qq install --no-install-recommends libboost1.58-all-dev libgflags-dev libgoogle-glog-dev liblmdb-dev wget python-pip git-all libzip-dev
RUN apt-get install -y \
    curl \
    libibverbs-dev \
    libibverbs1 \
    librdmacm1 \
    librdmacm-dev \
    rdmacm-utils \
    libibmad-dev \
    libibmad5 \
    byacc \
    libibumad-dev \
    libibumad3 \
    flex && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# RUN PYTHON INSTALL
RUN pip install --upgrade pip setuptools wheel
RUN pip install numpy scipy sklearn scikit-image

RUN apt-get -qq install libopencv-dev build-essential checkinstall cmake pkg-config yasm libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils

RUN apt-get -qq install libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libatlas-base-dev
RUN apt-get -qq install --no-install-recommends libboost1.58-all-dev
RUN apt-get -qq install libgflags-dev libgoogle-glog-dev liblmdb-dev

# install Dense_Flow dependencies
RUN apt-get -qq install libzip-dev

WORKDIR /app

ADD . /app

# install openmpi
ENV MPI_VERSION 2.0.1
ADD ./install-openmpi.sh /tmp/install-openmpi.sh
RUN /bin/bash -x /tmp/install-openmpi.sh && rm -rf /tmp/install-openmpi.sh

# Get code
RUN nvcc --version

ENV LIBRARY_PATH=/usr/local/cuda/lib64

# install with openmpi support
RUN MPI_PREFIX=/usr/local/openmpi/ bash build_all.sh MPI_ON

RUN bash scripts/get_reference_models.sh
RUN bash scripts/get_init_models.sh

RUN pip install ipython protobuf
RUN pip install http://download.pytorch.org/whl/cu90/torch-0.3.1-cp27-cp27mu-linux_x86_64.whl
RUN pip install torchvision

RUN apt-get -qq install -y vim

CMD ["ipython"]