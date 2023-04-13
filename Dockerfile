# 根据版本
FROM gradle:jdk8 as builder

# 指定构建过程中的工作目录
WORKDIR /opt/application
# 将当前目录（dockerfile所在目录）下所有文件都拷贝到工作目录下（.dockerignore中文件除外）
COPY . .

RUN gradle clean build

# 采用抖音云基础镜像, 包含https证书, bash, tzdata等常用命令
FROM public-cn-beijing.cr.volces.com/public/dycloud-openjdk:tomcat-jre8-alpine
WORKDIR /opt/application

RUN mkdir -p /usr/local/tomcat/myapps

# 分析打包文件, maven: pom.xml 可得
COPY --from=builder /opt/application/build/libs/*.war /usr/local/tomcat/myapps/

# 替换端口号
RUN war_name=$(ls /usr/local/tomcat/myapps | sort -r | grep .war -m 1) && sed -i s/8080/8000/g /usr/local/tomcat/conf/server.xml && rm -rf /usr/local/tomcat/webapps/ROOT && content='\ \t<Context path="" docBase="/usr/local/tomcat/myapps/'"${war_name}"'"></Context>' && num=$(grep -n 'autoDeploy' /usr/local/tomcat/conf/server.xml | awk -F ":" '{print $1}') && sed -i ''"${num}"'a '"${content}"'' /usr/local/tomcat/conf/server.xml

# 写入run.sh
RUN echo '#!/usr/bin/env bash\nsh /usr/local/tomcat/bin/catalina.sh run' > /opt/application/run.sh

# 指定run.sh权限
Run chmod a+x run.sh

EXPOSE 8000

USER root

#CMD ["sh", "run.sh"]

