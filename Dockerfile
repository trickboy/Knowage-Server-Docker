FROM java:8

ENV KNOWAGE_VERSION 6_2_0-RC
ENV KNOWAGE_EDITION CE
ENV KNOWAGE_RELEASE_DATE 20180509
ENV KNOWAGE_PACKAGE_SUFFIX bin-${KNOWAGE_VERSION}-${KNOWAGE_EDITION}-${KNOWAGE_RELEASE_DATE}

ENV KNOWAGE_CORE_ENGINE knowage
ENV KNOWAGE_CORE_URL http://download.forge.ow2.org/knowage/${KNOWAGE_CORE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_BIRTREPORT_ENGINE ${KNOWAGE_CORE_ENGINE}birtreportengine
ENV KNOWAGE_BIRTREPORT_URL http://download.forge.ow2.org/knowage/${KNOWAGE_BIRTREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_COCKPIT_ENGINE ${KNOWAGE_CORE_ENGINE}cockpitengine
ENV KNOWAGE_COCKPIT_URL http://download.forge.ow2.org/knowage/${KNOWAGE_COCKPIT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_COMMONJ_ENGINE ${KNOWAGE_CORE_ENGINE}commonjengine
ENV KNOWAGE_COMMONJ_URL http://download.forge.ow2.org/knowage/${KNOWAGE_COMMONJ_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_DATAMINING_ENGINE ${KNOWAGE_CORE_ENGINE}dataminingengine
ENV KNOWAGE_DATAMINING_URL http://download.forge.ow2.org/knowage/${KNOWAGE_DATAMINING_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_GEOREPORT_ENGINE ${KNOWAGE_CORE_ENGINE}georeportengine
ENV KNOWAGE_GEOREPORT_URL http://download.forge.ow2.org/knowage/${KNOWAGE_GEOREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_JASPERREPORT_ENGINE ${KNOWAGE_CORE_ENGINE}jasperreportengine
ENV KNOWAGE_JASPERREPORT_URL http://download.forge.ow2.org/knowage/${KNOWAGE_JASPERREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_KPI_ENGINE ${KNOWAGE_CORE_ENGINE}kpiengine
ENV KNOWAGE_KPI_URL http://download.forge.ow2.org/knowage/${KNOWAGE_KPI_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_META_ENGINE ${KNOWAGE_CORE_ENGINE}meta
ENV KNOWAGE_META_URL http://download.forge.ow2.org/knowage/${KNOWAGE_META_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_NETWORK_ENGINE ${KNOWAGE_CORE_ENGINE}networkengine
ENV KNOWAGE_NETWORK_URL http://download.forge.ow2.org/knowage/${KNOWAGE_NETWORK_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_QBE_ENGINE ${KNOWAGE_CORE_ENGINE}qbeengine
ENV KNOWAGE_QBE_URL http://download.forge.ow2.org/knowage/${KNOWAGE_QBE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_SVGVIEWER_ENGINE ${KNOWAGE_CORE_ENGINE}svgviewerengine
ENV KNOWAGE_SVGVIEWER_URL http://download.forge.ow2.org/knowage/${KNOWAGE_SVGVIEWER_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_TALEND_ENGINE ${KNOWAGE_CORE_ENGINE}talendengine
ENV KNOWAGE_TALEND_URL http://download.forge.ow2.org/knowage/${KNOWAGE_TALEND_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV KNOWAGE_WHATIF_ENGINE ${KNOWAGE_CORE_ENGINE}whatifengine
ENV KNOWAGE_WHATIF_URL http://download.forge.ow2.org/knowage/${KNOWAGE_WHATIF_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

ENV APACHE_TOMCAT_VERSION 7.0.57
ENV APACHE_TOMCAT_PACKAGE apache-tomcat-${APACHE_TOMCAT_VERSION}
ENV APACHE_TOMCAT_URL https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.57/bin/${APACHE_TOMCAT_PACKAGE}.zip

#location of mysql script to init knowage db
ENV KNOWAGE_MYSQL_SCRIPT_URL=http://download.forge.ow2.org/knowage/mysql-dbscripts-${KNOWAGE_VERSION}_${KNOWAGE_RELEASE_DATE}.zip

ENV LIB_COMMONS_LOGGING_URL https://search.maven.org/remotecontent?filepath=commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar
ENV LIB_COMMONS_LOGGING_API_URL https://search.maven.org/remotecontent?filepath=commons-logging/commons-logging-api/1.1/commons-logging-api-1.1.jar
ENV LIB_CONCURRENT_URL https://search.maven.org/remotecontent?filepath=org/lucee/oswego-concurrent/1.3.4/oswego-concurrent-1.3.4.jar
ENV LIB_MYSQL_CONNECTOR_URL https://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.33/mysql-connector-java-5.1.33.jar
ENV LIB_GERONIMO_COMMONJ_URL https://search.maven.org/remotecontent?filepath=org/apache/geronimo/specs/geronimo-commonj_1.1_spec/1.0/geronimo-commonj_1.1_spec-1.0.jar
ENV LIB_MYFOO_COMMONJ_PACKAGE foo-commonj-1.1.0
ENV LIB_MYFOO_COMMONJ_URL http://commonj.myfoo.de/bin/${LIB_MYFOO_COMMONJ_PACKAGE}.zip

ENV LIB_POSTGRESQL_CONNECTOR_URL https://jdbc.postgresql.org/download/postgresql-42.2.4.jar

#knowage directory
ENV KNOWAGE_DIRECTORY /home/knowage
#mysql script directory
ENV MYSQL_SCRIPT_DIRECTORY ${KNOWAGE_DIRECTORY}/mysql

#go to knowage home directory
WORKDIR ${KNOWAGE_DIRECTORY}

RUN apt-get update && apt-get install -y wget coreutils unzip mysql-client  && rm -rf /var/lib/apt/lists/*

#download mysql scripts
RUN wget "${KNOWAGE_MYSQL_SCRIPT_URL}" -O mysql.zip && \
        unzip mysql.zip && \
        rm mysql.zip

#download apache tomcat and extract it
RUN wget "${APACHE_TOMCAT_URL}" && \
       unzip ${APACHE_TOMCAT_PACKAGE}.zip && \
       rm ${APACHE_TOMCAT_PACKAGE}.zip

#go to apache tomcat webapps directory
WORKDIR ${KNOWAGE_DIRECTORY}/${APACHE_TOMCAT_PACKAGE}/webapps

#download knowage engines and extract them
RUN wget "${KNOWAGE_CORE_URL}" && \
       unzip -o ${KNOWAGE_CORE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_CORE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_CORE_ENGINE}.war -d ${KNOWAGE_CORE_ENGINE} && \
       rm ${KNOWAGE_CORE_ENGINE}.war
       
RUN wget "${KNOWAGE_BIRTREPORT_URL}" && \
       unzip -o ${KNOWAGE_BIRTREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_BIRTREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_BIRTREPORT_ENGINE}.war -d ${KNOWAGE_BIRTREPORT_ENGINE} && \
       rm ${KNOWAGE_BIRTREPORT_ENGINE}.war
       
RUN wget "${KNOWAGE_COCKPIT_URL}" && \
       unzip -o ${KNOWAGE_COCKPIT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_COCKPIT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_COCKPIT_ENGINE}.war -d ${KNOWAGE_COCKPIT_ENGINE} && \
       rm ${KNOWAGE_COCKPIT_ENGINE}.war
       
RUN wget "${KNOWAGE_COMMONJ_URL}" && \
       unzip -o ${KNOWAGE_COMMONJ_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_COMMONJ_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_COMMONJ_ENGINE}.war -d ${KNOWAGE_COMMONJ_ENGINE} && \
       rm ${KNOWAGE_COMMONJ_ENGINE}.war
       
RUN wget "${KNOWAGE_DATAMINING_URL}" && \
       unzip -o ${KNOWAGE_DATAMINING_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_DATAMINING_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_DATAMINING_ENGINE}.war -d ${KNOWAGE_DATAMINING_ENGINE} && \
       rm ${KNOWAGE_DATAMINING_ENGINE}.war
       
RUN wget "${KNOWAGE_GEOREPORT_URL}" && \
       unzip -o ${KNOWAGE_GEOREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_GEOREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_GEOREPORT_ENGINE}.war -d ${KNOWAGE_GEOREPORT_ENGINE} && \
       rm ${KNOWAGE_GEOREPORT_ENGINE}.war
       
RUN wget "${KNOWAGE_JASPERREPORT_URL}" && \
       unzip -o ${KNOWAGE_JASPERREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_JASPERREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_JASPERREPORT_ENGINE}.war -d ${KNOWAGE_JASPERREPORT_ENGINE} && \
       rm ${KNOWAGE_JASPERREPORT_ENGINE}.war
       
RUN wget "${KNOWAGE_KPI_URL}" && \
       unzip -o ${KNOWAGE_KPI_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_KPI_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_KPI_ENGINE}.war -d ${KNOWAGE_KPI_ENGINE} && \
       rm ${KNOWAGE_KPI_ENGINE}.war
       
RUN wget "${KNOWAGE_META_URL}" && \
       unzip -o ${KNOWAGE_META_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_META_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_META_ENGINE}.war -d ${KNOWAGE_META_ENGINE} && \
       rm ${KNOWAGE_META_ENGINE}.war
       
RUN wget "${KNOWAGE_NETWORK_URL}" && \
       unzip -o ${KNOWAGE_NETWORK_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_NETWORK_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_NETWORK_ENGINE}.war -d ${KNOWAGE_NETWORK_ENGINE} && \
       rm ${KNOWAGE_NETWORK_ENGINE}.war
       
RUN wget "${KNOWAGE_QBE_URL}" && \
       unzip -o ${KNOWAGE_QBE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_QBE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_QBE_ENGINE}.war -d ${KNOWAGE_QBE_ENGINE} && \
       rm ${KNOWAGE_QBE_ENGINE}.war
       
RUN wget "${KNOWAGE_SVGVIEWER_URL}" && \
       unzip -o ${KNOWAGE_SVGVIEWER_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_SVGVIEWER_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_SVGVIEWER_ENGINE}.war -d ${KNOWAGE_SVGVIEWER_ENGINE} && \
       rm ${KNOWAGE_SVGVIEWER_ENGINE}.war
       
RUN wget "${KNOWAGE_TALEND_URL}" && \
       unzip -o ${KNOWAGE_TALEND_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_TALEND_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_TALEND_ENGINE}.war -d ${KNOWAGE_TALEND_ENGINE} && \
       rm ${KNOWAGE_TALEND_ENGINE}.war
       
RUN wget "${KNOWAGE_WHATIF_URL}" && \
       unzip -o ${KNOWAGE_WHATIF_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       rm ${KNOWAGE_WHATIF_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && \
       unzip ${KNOWAGE_WHATIF_ENGINE}.war -d ${KNOWAGE_WHATIF_ENGINE} && \
       rm ${KNOWAGE_WHATIF_ENGINE}.war

#go to apache tomcat lib directory
WORKDIR ${KNOWAGE_DIRECTORY}/${APACHE_TOMCAT_PACKAGE}/lib

#download knowage libs and put them into apache tomcat lib
RUN wget "${LIB_COMMONS_LOGGING_URL}"
RUN wget "${LIB_COMMONS_LOGGING_API_URL}"
RUN wget "${LIB_CONCURRENT_URL}"
RUN wget "${LIB_MYSQL_CONNECTOR_URL}"
RUN wget "${LIB_GERONIMO_COMMONJ_URL}"
RUN wget "${LIB_MYFOO_COMMONJ_URL}" && \
	unzip ${LIB_MYFOO_COMMONJ_PACKAGE}.zip && \
	rm ${LIB_MYFOO_COMMONJ_PACKAGE}.zip && \
	cp ${LIB_MYFOO_COMMONJ_PACKAGE}/lib/${LIB_MYFOO_COMMONJ_PACKAGE}.jar . && \
	rm -r ${LIB_MYFOO_COMMONJ_PACKAGE}

#dowload DBs libraries and put them into apache tomcat lib
RUN wget "${LIB_POSTGRESQL_CONNECTOR_URL}"

#go to apache tomcat configuration directory
WORKDIR ${KNOWAGE_DIRECTORY}/${APACHE_TOMCAT_PACKAGE}/conf

#override apache tomcat server configuration
COPY server.xml ./

#go to binary folder in order to execute tomcat startup
WORKDIR ${KNOWAGE_DIRECTORY}/${APACHE_TOMCAT_PACKAGE}/bin

#make the script executable by bash (not only sh) and
#make knowage running forever without exiting when running the container
RUN sed -i "s/bin\/sh/bin\/bash/" startup.sh && \
	sed -i "s/EXECUTABLE\" start/EXECUTABLE\" run/" startup.sh

#copy entrypoint to be used at runtime
COPY ./entrypoint.sh ./

#make all scripts executable
RUN chmod +x *.sh

#expose common tomcat port
#this can be used by the host to expose the application
#you can use it while running image with the param '-p 8080:8080'
EXPOSE 8080

#-d option is passed to run knowage forever without exiting from container
ENTRYPOINT ["./entrypoint.sh"]

#this will start knowage just after the previous entrypoint
CMD ["./startup.sh"]
