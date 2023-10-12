FROM mongo:7.0.2

RUN mkdir /opt/screeps

WORKDIR /opt/screeps

RUN apt update && apt install -y git redis curl
ADD https://github.com/screepers/screeps-launcher/releases/download/v1.15.1/screeps-launcher_v1.15.1_linux_amd64 screeps-launcher
RUN chmod +x screeps-launcher

