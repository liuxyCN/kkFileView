FROM centos:centos7
MAINTAINER liuxyCN "lxy@live.cn"
ADD jodconverter-web/target/kkFileView-*.tar.gz /opt/
COPY fonts/* /usr/share/fonts/chinese/
RUN yum install -y wget &&\
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo &&\
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo &&\
    yum makecache &&\
    yum install -y kde-l10n-Chinese &&\
	yum install -y glibc-common &&\
	yum install -y freetype freetype-devel &&\
	yum install -y gtk3-devel gtk3-devel-docs &&\
	yum install -y fontconfig &&\
	yum install -y mkfontscale &&\
	localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 &&\
	echo "LANG=zh_CN.UTF-8" > /etc/locale.conf &&\
	source /etc/locale.conf &&\
	export LANG=zh_CN.UTF-8 &&\
	LANG="zh_CN.UTF-8" &&\
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
	yum install -y java-1.8.0-openjdk.x86_64 &&\
	yum install -y libXext.x86_64 &&\
	yum groupinstall -y "X Window System" &&\
	yum provides '*/applydeltarpm' &&\
    yum install  -y deltarpm &&\
	cd /tmp &&\
	wget https://mirrors.tuna.tsinghua.edu.cn/libreoffice/libreoffice/stable/6.4.1/rpm/x86_64/LibreOffice_6.4.1_Linux_x86-64_rpm.tar.gz &&\
	wget https://mirrors.tuna.tsinghua.edu.cn/libreoffice/libreoffice/stable/6.4.1/rpm/x86_64/LibreOffice_6.4.1_Linux_x86-64_rpm_helppack_zh-CN.tar.gz &&\
	wget https://mirrors.tuna.tsinghua.edu.cn/libreoffice/libreoffice/stable/6.4.1/rpm/x86_64/LibreOffice_6.4.1_Linux_x86-64_rpm_langpack_zh-CN.tar.gz &&\
	tar zxf /tmp/LibreOffice_6.4.1_Linux_x86-64_rpm.tar.gz &&\
	tar zxf /tmp/LibreOffice_6.4.1_Linux_x86-64_rpm_helppack_zh-CN.tar.gz &&\
	tar zxf /tmp/LibreOffice_6.4.1_Linux_x86-64_rpm_langpack_zh-CN.tar.gz &&\
	cd /tmp/LibreOffice_6.4.1.2_Linux_x86-64_rpm/RPMS &&\
	su -c 'yum install -y *.rpm' &&\
	cd /tmp/LibreOffice_6.4.1.2_Linux_x86-64_rpm_langpack_zh-CN/RPMS &&\
	su -c 'yum install -y *.rpm' &&\
	cd /tmp/LibreOffice_6.4.1.2_Linux_x86-64_rpm_helppack_zh-CN/RPMS &&\
	su -c 'yum install -y *.rpm' &&\
	cd /opt &&\
    ln -s libreoffice6.4 libreoffice &&\
	cd /usr/share/fonts/chinese &&\
	mkfontscale &&\
	mkfontdir &&\
	fc-cache -fv
ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV KKFILEVIEW_BIN_FOLDER /opt/kkFileView-2.2.0-SNAPSHOT/bin
ENTRYPOINT ["java","-Dfile.encoding=UTF-8","-Dsun.java2d.cmm=sun.java2d.cmm.kcms.KcmsServiceProvider","-Dspring.config.location=/opt/kkFileView-2.2.0-SNAPSHOT/config/application.properties","-jar","/opt/kkFileView-2.2.0-SNAPSHOT/bin/kkFileView-2.2.0-SNAPSHOT.jar"]

#mvn clean package -DskipTests -Prelease
#docker build -t mymoyu/kkfileview:2.2.0-SNAPSHOT .
#docker run -p 8012:8012 --name kkfileview --network whatever -d mymoyu/kkfileview