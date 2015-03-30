FROM ubuntu
MAINTAINER Christian Lehner <lehner.chri@gmail.com>

# prevents a weird error message
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y nodejs npm

# install ruby (required by compass)
RUN  apt-get install -y ruby-dev
RUN apt-get install -y make

# install compass
RUN gem install --no-rdoc --no-ri compass

# node packages
RUN npm install -g coffee-script
RUN npm install -g jasmine
RUN npm install -g bower

# create folder var/www/vidatio and copy the app
RUN mkdir -p /var/www/vidatio
COPY . /var/www/vidatio/

# set bash start directory to /var/www/vidatio
WORKDIR /var/www/vidatio

# change directory and install node packages from package.json
RUN npm install

# expose port 5000 to host OS
EXPOSE 5000

CMD ["nodejs", "server.js"]