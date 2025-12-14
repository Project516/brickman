FROM debian:trixie

ENV DEBIAN_FRONTEND=noninteractive

# 1. Enable ARM architecture
RUN dpkg --add-architecture armel

# 2. Install Build Tools
# We install 'cmake' and 'git' for the build process
# We install 'valac' and 'libglib2.0-dev' (native) for the Vala compiler
RUN apt-get update && apt-get install -y \
    crossbuild-essential-armel \
    git \
    build-essential \
    devscripts \
    debhelper \
    pkg-config \
    cmake \
    sudo \
    python3 \
    valac \
    libglib2.0-dev \
    # Install ARM libraries required by Brickman
    libglib2.0-dev:armel \
    libudev-dev:armel \
    libdbus-1-dev:armel \
    libasound2-dev:armel \
    libgudev-1.0-dev:armel \
    libpng-dev:armel \
    libjpeg-dev:armel \
    libfreetype-dev:armel \
    libfontconfig-dev:armel \
    fonts-lato \
    libpcre2-dev:armel \
    && rm -rf /var/lib/apt/lists/*

COPY *.deb /tmp/
RUN dpkg -i --force-all /tmp/*.deb

# 4. Create builder user
RUN useradd -m compiler && echo "compiler ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER compiler
WORKDIR /src