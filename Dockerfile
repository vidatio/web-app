FROM mhart/alpine-node:4.2.1
MAINTAINER Christian Lehner <lehner.chri@gmail.com>, Lukas Wanko <lwanko.mmt-m2014@fh-salzburg.ac.at>

RUN apk update
RUN apk upgrade
RUN apk add nginx git python make g++

WORKDIR /var/www/

# add package.json and bower.json before copying the entire app to use caching
ADD package.json bower.json /var/www/
RUN npm install
RUN npm install -g bower gulp
RUN bower install --allow-root

# create folder var/www/vidatio and copy the app
ADD . /var/www/

# move loggly config from server to app
# RUN cp /etc/loggly/config.json /usr/share/nginx/html/vidatio/app/statics/constants/config.json

# expose 80 to host OS
EXPOSE 80

RUN gulp production

ADD nginx-config /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
