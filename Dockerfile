# Use a base image that includes Miniconda
FROM continuumio/miniconda3

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the environment.yml file (if you have one) and other necessary files into the container
COPY DrivR-Base.yml ./
COPY . /usr/src/app

# Create the Conda environment
RUN conda env create -f DrivR-Base.yml

# Activate the Conda environment
# Note: Adjust "your_env_name" to match the name of your Conda environment
ENV PATH /opt/conda/envs/DrivR-Base/bin:$PATH

# Activate the Conda environment
ENV PATH /opt/conda/envs/DrivR-Base/bin:$PATH
RUN echo "source activate DrivR-Base" >> ~/.bashrc

# Install bedtools within the Conda environment
RUN conda install -c bioconda bedtools

# Install wget
RUN apt-get update && apt-get install -y wget

# Install bigWigToBedGraph
RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/bigWigToBedGraph -O /usr/local/bin/bigWigToBedGraph && chmod +x /usr/local/bin/bigWigToBedGraph

# Create a directory for conservation data
RUN mkdir -p /usr/src/app/conservation_data

# Make port 80 available to the world outside this container
EXPOSE 80

# Ensure your scripts are executable
RUN chmod +x *.sh

CMD ["tail", "-f", "/dev/null"]
