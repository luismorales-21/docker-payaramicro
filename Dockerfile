FROM centos:7.5.1804
RUN yum update -y && \
yum install -y java-1.8.0-openjdk
ENV PAYARA_PORT 8080
#Payara environment variables
ENV PAYARA_NAME payara-5-micro-prerelease.jar
ENV PAYARA_DEPLOYMENT_DIR apps_deployment
ENV PAYARA_PATH /opt/payara
ENV PAYARA_URL https://s3-eu-west-1.amazonaws.com/payara.fish/payara-5-micro-prerelease.jar
#Create dir for Payara package
RUN mkdir -p $PAYARA_PATH/$PAYARA_DEPLOYMENT_DIR
#Copy WAR microservices to deployment dir
COPY *.war $PAYARA_PATH/$PAYARA_DEPLOYMENT_DIR/
#Create user for exec payara micro
RUN groupadd -r payaramicro && \
useradd -r -g payaramicro payaramicro
RUN chown -R payaramicro:payaramicro $PAYARA_PATH
#Set user
USER payaramicro
WORKDIR $PAYARA_PATH
#Payara ports to expose
EXPOSE $PAYARA_PORT
#Get Payara JAR
RUN curl -o $PAYARA_PATH/$PAYARA_NAME $PAYARA_URL
RUN echo $PAYARA_PATH/$PAYARA_DEPLOYMENT_DIR/
#Execute Payara on specified Port
CMD java -jar $PAYARA_NAME --deploymentDir $PAYARA_PATH/$PAYARA_DEPLOYMENT_DIR/ --port $PAYARA_PORT