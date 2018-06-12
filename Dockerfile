FROM ubuntu:latest
# Based on https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/docker/Dockerfile

# Pick up some TF dependencies
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libpng-dev \
    libzmq3-dev \
    pkg-config \
    python3 \
    python3-dev \
    rsync \ 
    unzip \
    python3-pip python3-numpy python3-scipy python3-matplotlib \
    ipython jupyter-notebook python3-notebook python3-pandas \
    python3-sympy python3-nose python3-setuptools

RUN pip3 --no-cache-dir install \
    https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.8.0-cp36-cp36m-linux_x86_64.whl

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

WORKDIR "/notebooks"

CMD ["/run_jupyter.sh", "--allow-root"]
