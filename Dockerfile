FROM ubuntu:20.04

WORKDIR /plantuml

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y openjdk-8-jre
    
RUN wget -O plantuml.jar https://sourceforge.net/projects/plantuml/files/plantuml.1.2020.15.jar/download

RUN mkdir input && \
    mkdir output

VOLUME ["input", "output"]

COPY ./render-plantuml.sh ./render-plantuml.sh

ENTRYPOINT [ "sh", "render-plantuml.sh", "/input", "/output" ]