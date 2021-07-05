FROM ubuntu:20.04
COPY ./init.sh /
RUN apt-get update -y && \
    apt-get install uuid-runtime -y && \
    apt-get install zip -y && \
    apt-get install curl -y  && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash -  && \
    apt-get install nodejs -y  && \
    npm install -g pm2  && \
    apt-get update -y && \
    apt-get install unzip -y && \
    apt-get update -y && \
    apt-get install mysql-server -y && \
    apt-get update -y && \
    apt-get install git -y && \
    apt-get install wget -y
RUN bash /init.sh
CMD ["node", "/WickHunterTVCompanion/main.js"]