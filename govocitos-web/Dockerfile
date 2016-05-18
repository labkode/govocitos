FROM tomcat:8.0
COPY detepre /usr/local/tomcat/webapps/detepre
RUN apt-get update
RUN apt-get install -y graphviz imagemagick openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:detepre' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

CMD service ssh restart & catalina.sh run

EXPOSE 22
EXPOSE 8080
