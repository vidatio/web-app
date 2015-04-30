FROM ubuntu
MAINTAINER Christian Lehner <lehner.chri@gmail.com>

# prevents a weird error message
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get clean && apt-get autoclean && apt-get autoremove && apt-get upgrade -y
RUN apt-get install -y curl git nginx

# needed for bower github installations
RUN git config --global url."https://".insteadOf git://

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.24.0/install.sh | bash

# set node path in container
ENV NODE_VERSION=v0.12.2
ENV NODE_PATH=/root/.nvm/versions/node/$NODE_VERSION/bin
ENV PATH=$PATH:$NODE_PATH

# install node.js via NVM
RUN cat ~/.nvm/nvm.sh >> ~/.nvm/installnode.sh
RUN echo "nvm install $NODE_VERSION" >> ~/.nvm/installnode.sh
RUN echo "npm install -g coffee-script jasmine bower" >> ~/.nvm/installnode.sh
RUN sh ~/.nvm/installnode.sh

# copy nginx config
ADD nginx_config /etc/nginx/sites-enabled/

#delete default nginx config to run the new one on localhost:80
RUN rm /etc/nginx/sites-enabled/default

# set bash start directory to /var/www/vidatio
WORKDIR /var/www/vidatio

# add package.json and bower.json before copying the entire app to use caching
ADD package.json bower.json /var/www/vidatio/
RUN npm install
RUN bower install --allow-root

# create folder var/www/vidatio and copy the app
RUN mkdir -p /var/www/vidatio
ADD . /var/www/vidatio/

# expose port 5000 and 80 to host OS
EXPOSE 5000 80

# run nginx and the app
CMD nginx && node api.js