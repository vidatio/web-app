FROM ubuntu
MAINTAINER Christian Lehner <lehner.chri@gmail.com>

# prevents a weird error message
ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update

RUN apt-get install -y curl man

# install ruby (required by compass)
RUN  apt-get install -y ruby-dev
RUN apt-get install -y make

# install compass
RUN gem install --no-rdoc --no-ri compass

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.24.0/install.sh | bash

# set node path in container
ENV NODE_PATH=/root/.nvm/versions/node/v0.12.2/bin
ENV PATH=$PATH:$NODE_PATH

RUN cat ~/.nvm/nvm.sh >> ~/.nvm/installnode.sh
RUN echo "nvm install stable" >> ~/.nvm/installnode.sh
RUN echo "npm install -g coffee-script jasmine bower" >> ~/.nvm/installnode.sh
RUN sh ~/.nvm/installnode.sh

# set bash start directory to /var/www/vidatio
WORKDIR /var/www/vidatio

# create folder var/www/vidatio and copy the app
RUN mkdir -p /var/www/vidatio
COPY . /var/www/vidatio/

RUN npm install

# expose port 5000 to host OS
EXPOSE 5000

CMD ["node", "server.js"]
