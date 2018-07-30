FROM ubuntu:18.04
MAINTAINER Lihan Li <llihan673@gmail.com>

# Configure environment
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Install Tini that necessary to properly run the notebook service in docker
# http://jupyter-notebook.readthedocs.org/en/latest/public_server.html#docker-cmd
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
# for further interaction with kubernetes
ADD https://storage.googleapis.com/kubernetes-release/release/v1.10.3/bin/linux/amd64/kubectl /usr/sbin/kubectl
RUN chmod +x /usr/bin/tini && chmod 0500 /usr/sbin/kubectl

# Create a non-priviledge user that will run the client and workers
ENV BASICUSER basicuser
ENV BASICUSER_UID 1000
RUN useradd -m -d /work -s /bin/bash -N -u $BASICUSER_UID $BASICUSER \
 && chown $BASICUSER /work \
 && chown $BASICUSER:users -R /work


RUN apt-get update -y && \
  apt-get install -y \
    bzip2 \
    git \
    wget \
    graphviz \
    vim \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*


RUN pip3 install --no-cache-dir \
  jupyter \
  jupyterlab \
  jupyter_dashboards \
  ipywidgets \
  numpy \
  pandas \
  dask[complete] \
  dask-kubernetes \
  distributed \
  dask-searchcv \
  lightgbm \
  plotly \
  seaborn \
  bokeh \
  psutil \
  holoviews \
  tensorflow \
  keras \
  chainer \
  graphviz \
  gcsfs  \
  s3fs   \
  jgscm

COPY config /work/config

ENTRYPOINT ["/usr/bin/tini", "--"]
