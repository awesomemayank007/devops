FROM centos:latest

RUN yum update all
RUN yum install httpd -y
RUN echo "dumy file hosted" > /var/www/html/index.html
CMD ["/usr/sbin/apachectl","-D","FOREGROUND"]
