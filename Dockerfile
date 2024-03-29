# Use a base image that supports the necessary kernel features for redroid
FROM ubuntu:20.04

# Install Docker following the official instructions
RUN apt-get update && \
    apt-get install -y docker.io

# Install required kernel modules for redroid
RUN apt-get install -y linux-modules-extra-`uname -r` && \
    modprobe binder_linux devices="binder,hwbinder,vndbinder" && \
    modprobe ashmem_linux

# Copy the redroid image to the container
COPY . /redroid

# Expose the ADB port (5555) for redroid
EXPOSE 5555

# Run redroid with the necessary privileges and configurations
CMD ["docker", "run", "-itd", "--rm", "--privileged", \
     "--pull", "always", \
     "-v", "/data:/data", \
     "-p", "5555:5555", \
     "redroid/redroid:11.0.0-latest"]