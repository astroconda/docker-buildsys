FROM centos:6.9

# Generic Globals
ENV OPT /opt
ENV HOME /home/jenkins

# Miniconda
ARG MC_VERSION
ENV MC_VERSION 4.3.21
ARG MC_PLATFORM
ENV MC_PLATFORM Linux
ARG MC_ARCH
ENV MC_ARCH x86_64
ARG MC_URL
ENV MC_URL https://repo.continuum.io/miniconda
ENV MC_INSTALLER Miniconda3-${MC_VERSION}-${MC_PLATFORM}-${MC_ARCH}.sh
ENV MC_PATH ${OPT}/conda

# Conda Root
ARG CONDA_VERSION
ENV CONDA_VERSION 4.3.25
ARG CONDA_BUILD_VERSION
ENV CONDA_BUILD_VERSION  3.0.14
ARG CONDA_PACKAGES
ENV CONDA_PACKAGES

ARG AGENT_VERSION=3.10
ARG AGENT_WORKDIR=${OPT}/agent

RUN yum install -y \
        openssh-server \
        curl \
        wget \
        git \
        subversion \
        hg \
        java-1.8.0-openjdk-devel \
        gcc \
        gcc-c++ \
        gcc-gfortran \
        glibc-devel \
        kernel-devel \
        bzip2-devel \
        zlib-devel \
        ncurses-devel \
        libX11-devel \
        mesa-libGL \
        mesa-libGLU \
    && yum clean all

RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
    && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa \
    && groupadd jenkins \
    && useradd -g jenkins -m -d $HOME -s /bin/bash jenkins \
    && echo "jenkins:jenkins" | chpasswd

WORKDIR ${OPT}

RUN curl -q -O ${MC_URL}/${MC_INSTALLER} \
    && bash ${MC_INSTALLER} -b -p ${MC_PATH} \
    && rm -rf ${MC_INSTALLER} \
    && echo export PATH="${MC_PATH}/bin:\${PATH}" > /etc/profile.d/conda.sh &&


ENV PATH "${MC_PATH}/bin:${PATH}"
RUN conda install --yes --quiet \
        conda=${CONDA_VERSION} \
        conda-build=${CONDA_BUILD_VERSION} \
        ${CONDA_PACKAGES} \
    && mkdir -p ${HOME}/.jenkins \
    && mkdir -p ${AGENT_WORKDIR} \
    && chown -R jenkins: ${OPT} ${HOME} ${AGENT_WORKDIR}

WORKDIR ${HOME}

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

