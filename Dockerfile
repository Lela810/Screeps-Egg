FROM mongo:7.0.2

RUN mkdir /opt/screeps

WORKDIR /opt/screeps

RUN apt update && apt install -y git redis git curl
ADD https://github.com/screepers/screeps-launcher/releases/download/v1.15.1/screeps-launcher_v1.15.1_linux_amd64 screeps-launcher
RUN chmod +x screeps-launcher

RUN git clone https://github.com/Lela810/Screeps-Egg

COPY /opt/screeps/Screeps-Egg/src/config.yml /opt/screeps/config.yml

