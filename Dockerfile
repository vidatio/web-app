FROM ubuntu
MAINTAINER Christian Lehner <lehner.chri@gmail.com>

# prevents a weird error message
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y curl git

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.24.0/install.sh | bash

# set node path in container
ENV NODE_PATH=/root/.nvm/versions/node/v0.12.2/bin
ENV PATH=$PATH:$NODE_PATH

# install node.js via NVM
RUN cat ~/.nvm/nvm.sh >> ~/.nvm/installnode.sh
RUN echo "nvm install stable" >> ~/.nvm/installnode.sh
RUN echo "npm install -g coffee-script jasmine bower" >> ~/.nvm/installnode.sh
RUN sh ~/.nvm/installnode.sh

# set bash start directory to /var/www/vidatio
WORKDIR /var/www/vidatio

# add package.json and bower.json before copying the entire app to use caching
ADD package.json bower.json /var/www/vidatio/
RUN npm install
RUN bower install --allow-root

# create folder var/www/vidatio and copy the app
RUN mkdir -p /var/www/vidatio
ADD . /var/www/vidatio/

# expose port 5000 to host OS
EXPOSE 5000

# run the app
CMD ["node", "server.js"]
