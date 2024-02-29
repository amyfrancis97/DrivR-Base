ARG BRANCH=release/111

###################################################
# Stage 1 - docker container to build ensembl-vep #
###################################################
FROM ubuntu:22.04 as builder

# Update aptitude and install some required packages
# a lot of them are required for Bio::DB::BigFile
RUN apt-get update && apt-get -y install \
    build-essential \
    git \
    libpng-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    perl \
    perl-base \
    unzip \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Setup VEP environment
ENV OPT /opt/vep
ENV OPT_SRC $OPT/src
ENV HTSLIB_DIR $OPT_SRC/htslib
ARG BRANCH

# Working directory
WORKDIR $OPT_SRC

# Clone/download repositories/libraries
RUN if [ "$BRANCH" = "main" ]; \
    then export BRANCH_OPT=""; \
    else export BRANCH_OPT="-b $BRANCH"; \
    fi && \
    # Get ensembl cpanfile in order to get the list of the required Perl libraries
    wget -q "https://raw.githubusercontent.com/Ensembl/ensembl/$BRANCH/cpanfile" -O "ensembl_cpanfile" && \
    # Clone ensembl-vep git repository
    git clone $BRANCH_OPT --depth 1 https://github.com/Ensembl/ensembl-vep.git && chmod u+x ensembl-vep/*.pl && \
    # Clone ensembl-variation git repository and compile C code
    git clone $BRANCH_OPT --depth 1 https://github.com/Ensembl/ensembl-variation.git && \
    mkdir var_c_code && \
    cp ensembl-variation/C_code/*.c ensembl-variation/C_code/Makefile var_c_code/ && \
    rm -rf ensembl-variation && \
    chmod u+x var_c_code/* && \
    # Clone bioperl-ext git repository - used by Haplosaurus
    git clone --depth 1 https://github.com/bioperl/bioperl-ext.git && \
    # Download ensembl-xs - it contains compiled versions of certain key subroutines used in VEP
    wget https://github.com/Ensembl/ensembl-xs/archive/2.3.2.zip -O ensembl-xs.zip && \
    unzip -q ensembl-xs.zip && mv ensembl-xs-2.3.2 ensembl-xs && rm -rf ensembl-xs.zip && \
    # Clone/Download other repositories: bioperl-live is needed so the cpanm dependencies installation from the ensembl-vep/cpanfile file takes less disk space
    ensembl-vep/travisci/get_dependencies.sh && \
    # Only keep the bioperl-live "Bio" library
    mv bioperl-live bioperl-live_bak && mkdir bioperl-live && mv bioperl-live_bak/Bio bioperl-live/ && rm -rf bioperl-live_bak && \
    ## A lot of cleanup on the imported libraries, in order to reduce the docker image ##
    rm -rf Bio-HTS/.??* Bio-HTS/Changes Bio-HTS/DISCLAIMER Bio-HTS/MANIFEST* Bio-HTS/README Bio-HTS/scripts Bio-HTS/t Bio-HTS/travisci \
           bioperl-ext/.??* bioperl-ext/Bio/SeqIO bioperl-ext/Bio/Tools bioperl-ext/Makefile.PL bioperl-ext/README* bioperl-ext/t bioperl-ext/examples \
           ensembl-vep/.??* ensembl-vep/docker \
           ensembl-xs/.??* ensembl-xs/TODO ensembl-xs/Changes ensembl-xs/INSTALL ensembl-xs/MANIFEST ensembl-xs/README ensembl-xs/t ensembl-xs/travisci \
           htslib/.??* htslib/INSTALL htslib/NEWS htslib/README* htslib/test && \
    # Only keep needed kent-335_base libraries for VEP - used by Bio::DB::BigFile (bigWig parsing)
    mv kent-335_base kent-335_base_bak && mkdir -p kent-335_base/src && \
    cp -R kent-335_base_bak/src/lib kent-335_base_bak/src/inc kent-335_base_bak/src/jkOwnLib kent-335_base/src/ && \
    cp kent-335_base_bak/src/*.sh kent-335_base/src/ && \
    rm -rf kent-335_base_bak

# Setup bioperl-ext
WORKDIR bioperl-ext/Bio/Ext/Align/
RUN perl -pi -e"s|(cd libs.+)CFLAGS=\\\'|\$1CFLAGS=\\\'-fPIC |" Makefile.PL

# Install htslib binaries (for 'bgzip' and 'tabix')
# htslib requires the packages 'zlib1g-dev', 'libbz2-dev' and 'liblzma-dev'
WORKDIR $HTSLIB_DIR
RUN make install && rm -f Makefile *.c

# Compile Variation LD C scripts
WORKDIR $OPT_SRC/var_c_code
RUN make && rm -f Makefile *.c


###################################################
# Stage 2 - docker container to build ensembl-vep #
###################################################
FROM ubuntu:22.04

# Install essential packages
RUN apt-get update && apt-get -y install \
    build-essential \
    cpanminus \
    curl \
    libmysqlclient-dev \
    libdbd-mysql-perl \
    libpng-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    locales \
    openssl \
    perl \
    perl-base \
    wget \
    unzip \
    vim && \
    apt-get -y purge manpages-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Update locale settings
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install Miniconda
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

# Update PATH to include Conda binaries
ENV PATH /opt/conda/bin:$PATH

# Copy Conda environment file
COPY DrivR-Base.yml /tmp/

RUN conda env create -f /tmp/DrivR-Base.yml && \
    echo "Environment creation successful!" && \
    conda list -n DrivR-Base

# Setup VEP environment
ENV OPT /opt/vep
ENV OPT_SRC $OPT/src
ENV PERL5LIB_TMP $PERL5LIB:$OPT_SRC/ensembl-vep:$OPT_SRC/ensembl-vep/modules
ENV PERL5LIB $PERL5LIB_TMP:$OPT_SRC/bioperl-live
ENV KENT_SRC $OPT/src/kent-335_base/src
ENV HTSLIB_DIR $OPT_SRC/htslib
ENV DEPS $OPT_SRC
ENV PATH $OPT_SRC/ensembl-vep:$OPT_SRC/var_c_code:$PATH
ENV LANG_VAR en_US.UTF-8
ARG BRANCH

# Create vep user
RUN useradd -r -m -U -d "$OPT" -s /bin/bash -c "VEP User" -p '' vep && \
    chmod a+rx $OPT && \
    usermod -a -G sudo vep && \
    mkdir -p $OPT_SRC
USER vep

# Copy downloaded libraries (stage 1) to this image (stage 2)
COPY --chown=vep:vep --from=builder $OPT_SRC $OPT_SRC
#############################################################

# Change user to root for the following complilations/installations
USER root

# Install bioperl-ext, faster alignments for haplo (XS-based BioPerl extensions to C libraries)
WORKDIR $OPT_SRC/bioperl-ext/Bio/Ext/Align/
RUN perl Makefile.PL && make && make install && rm -f Makefile*

# Install ensembl-xs, faster run using re-implementation in C of some of the Perl subroutines
WORKDIR $OPT_SRC/ensembl-xs
RUN perl Makefile.PL && make && make install && rm -f Makefile* cpanfile

WORKDIR $OPT_SRC
# Install/compile more libraries
RUN export MACHTYPE=$(uname -m) &&\
    ensembl-vep/travisci/build_c.sh && \
    # Remove unused Bio-DB-HTS files
    rm -rf Bio-HTS/cpanfile Bio-HTS/Build.PL Bio-HTS/Build Bio-HTS/_build Bio-HTS/INSTALL.pl && \
    # Install ensembl perl dependencies (cpanm)
    cpanm --installdeps --with-recommends --notest --cpanfile ensembl_cpanfile . && \
    cpanm --installdeps --with-recommends --notest --cpanfile ensembl-vep/cpanfile . && \
    # Delete bioperl and cpanfiles after the cpanm installs as bioperl will be reinstalled by the INSTALL.pl script
    rm -rf bioperl-live ensembl_cpanfile ensembl-vep/cpanfile && \
    # Configure "locale", see https://github.com/rocker-org/rocker/issues/19
    echo "$LANG_VAR UTF-8" >> /etc/locale.gen && locale-gen en_US.utf8 && \
    /usr/sbin/update-locale LANG=$LANG_VAR && \
    # Copy htslib executables. It also requires the packages 'zlib1g-dev', 'libbz2-dev' and 'liblzma-dev'
    cp $HTSLIB_DIR/bgzip $HTSLIB_DIR/tabix $HTSLIB_DIR/htsfile /usr/local/bin/ && \
    # Remove CPAN cache
    rm -rf /root/.cpanm

ENV LC_ALL $LANG_VAR
ENV LANG $LANG_VAR

# Switch back to vep user
# Create /data directory and set proper permissions
#RUN mkdir -p /data/tmp && \
 #   chown -R vep:vep /data

USER vep
ENV PERL5LIB $PERL5LIB_TMP

# Setup Docker environment for when users run VEP and INSTALL.pl in Docker image:
#   - skip VEP updates in INSTALL.pl
ENV VEP_NO_UPDATE 1
#   - avoid Faidx/HTSLIB installation in INSTALL.pl
ENV VEP_NO_HTSLIB 1
#   - skip plugin installation in INSTALL.pl
ENV VEP_NO_PLUGINS 1
#   - set plugins directory for VEP and INSTALL.pl
ENV VEP_DIR_PLUGINS /plugins
ENV VEP_PLUGINSDIR $VEP_DIR_PLUGINS
WORKDIR $VEP_DIR_PLUGINS

# Update bash profile
WORKDIR $OPT_SRC/ensembl-vep
RUN echo >> $OPT/.profile && \
    echo PATH=$PATH:\$PATH >> $OPT/.profile && \
    echo export PATH >> $OPT/.profile && \
    # Install Ensembl API and plugins
    ./INSTALL.pl --auto ap --plugins all --pluginsdir $VEP_DIR_PLUGINS --no_update --no_htslib && \
    # Remove the ensemb-vep tests and travis
    rm -rf t travisci .travis.yml

# Install dependencies for VEP plugins:
USER root
ENV PLUGIN_DEPS "https://raw.githubusercontent.com/Ensembl/VEP_plugins/$BRANCH/config"
#   - Ubuntu packages
RUN curl -O "$PLUGIN_DEPS/ubuntu-packages.txt" && \
    apt-get update && apt-get install -y --no-install-recommends \
    $(sed -e s/\#.*//g ubuntu-packages.txt) && \
    rm -rf /var/lib/apt/lists/* ubuntu-packages.txt
#   - Symlink python to python2
RUN ln -s /usr/bin/python2 /usr/bin/python
#   - Perl modules
RUN curl -O "$PLUGIN_DEPS/cpanfile" && \
    cpanm --installdeps --with-recommends . && \
    rm -rf /root/.cpanm cpanfile
#   - Python packages
RUN curl -O https://raw.githubusercontent.com/paulfitz/mysql-connector-c/master/include/my_config.h && \
    mv my_config.h /usr/include/mysql/my_config.h
RUN curl -O "$PLUGIN_DEPS/requirements.txt" && \
    python2 -m pip install --no-cache-dir -r requirements.txt && \
    rm requirements.txt

RUN apt-get update && apt-cache search libcurl

RUN apt-get update && apt-get -y install \
    build-essential \
    git \
    libpng-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    perl \
    perl-base \
    unzip \
    wget \
    cpanminus \
    curl \
    libmysqlclient-dev \
    libdbd-mysql-perl \
    libpng-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    locales \
    openssl \
    perl \
    perl-base \
    unzip \
    bedtools \
    samtools \
    bcftools \
    tabix \
    libdbi-perl \
    libxml2-dev \
    libhts-dev \
    libcurl4-gnutls-dev \
    g++ \
    libcairo2-dev \
    libglib2.0-dev \
    libfreetype6-dev \
    nano \
    gcc \
    pkg-config \
    vim && \
    rm -rf /var/lib/apt/lists/*

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y libcurl4-openssl-dev

# Set working directory as symlink to $OPT/.vep (containing VEP cache and data)
USER root
RUN ln -s $OPT/.vep /data

RUN echo "source /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate" >> ~/.bashrc && \
    conda install -c conda-forge r-base=4.2.2 && \
    conda run -n base R -e "install.packages('remotes', repos='https://cloud.r-project.org/')" && \
    conda run -n base R -e "remotes::install_version('renv', version='1.0.2', repos='https://cloud.r-project.org/')"
#    conda install -c anaconda libxml2 \
 #   conda install -c conda-forge libcurl

#ENV export XML2_INCDIR=/opt/conda/include/libxml2
#ENV export XML2_LIBDIR=/opt/conda/lib

# Use ENTRYPOINT to execute the script, then fallback to CMD
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

USER vep
WORKDIR /data

