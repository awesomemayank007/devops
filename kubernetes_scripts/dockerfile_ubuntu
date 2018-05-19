FROM ubuntu:latest
RUN apt-get update
RUN apt-get install apache2  -y
ADD index.html /var/www/html/
CMD ["/usr/sbin/apachectl","-D","FOREGROUND"]
