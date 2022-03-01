FROM ubuntu:20.04
LABEL MAINTAINER=Gloryhuis EMAIL=huismessager@gmail.com WEBSITE=https://huismessager.com
WORKDIR /opt
# globe Bash
SHELL ["/bin/bash", "-c"]
ENV TZ=Asia/Shanghai
# Alibaba Cloud ubuntu Sources
COPY ./sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
    wget \
    tzdata \
    locales \
    libfreetype6 \
    ttf-dejavu \
    fontconfig && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen zh_CN && \
    locale-gen zh_CN.utf8 && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone \
    fc-cache
# Download OpenJDK17 and unzip to /opt/openjdk17
RUN mkdir -p /opt/openjdk17 && wget -c https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz -O - | tar -zxP -C /opt/openjdk17 --strip-components=1
# my local file path.please replace this.
# RUN mkdir -p /opt/openjdk17 && wget -c http://192.168.1.7:9000/handsure/file/openjdk-17.0.2_linux-x64_bin.tar.gz -O - | tar -zxP -C /opt/openjdk17 --strip-components=1
# Setting Chinese language And JAVA_HOME PATH
ENV LANG=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8  LC_ALL=zh_CN.UTF-8 
ENV JAVA_HOME=/opt/openjdk17 
ENV PATH=$JAVA_HOME/bin:$PATH
# RUN java --version
#Download LibreOffice7.2.5 and unzip to /opt/libreoffice725
RUN mkdir -p /opt/libreoffice725_temp /opt/libreoffice725 && wget -c https://mirrors.nju.edu.cn/tdf/libreoffice/stable/7.2.5/deb/x86_64/LibreOffice_7.2.5_Linux_x86-64_deb.tar.gz -O - | tar -zxP -C /opt/libreoffice725_temp --strip-components=1 && cd /opt/libreoffice725_temp/DEBS && dpkg -i --instdir=/opt/libreoffice725 ./*.deb && rm -rf /opt/libreoffice725_temp
# RUN mkdir -p /opt/libreoffice725_temp && wget -c http://192.168.1.7:9000/handsure/file/LibreOffice_7.2.5_Linux_x86-64_deb.tar.gz -O - | tar -zxP -C /opt/libreoffice725_temp --strip-components=1 && cd /opt/libreoffice725_temp/DEBS && dpkg -i ./*.deb && rm -rf /opt/libreoffice725_temp
VOLUME [ "/opt/webroot" ]
CMD [ "/bin/bash" ]