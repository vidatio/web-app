IMAGE_NAME = "vidatio/app"
CONTAINER_NAME = "vidatio"

all: build run address

# Mac OS only: Linux users execute "make ps" instead
address: port ip

# build image from ubuntu
build:
	docker build -t $(IMAGE_NAME) .

# create and start container from image
run:
	docker run -d -P --name $(CONTAINER_NAME) $(IMAGE_NAME)

# stop container
stop:
	docker stop $(CONTAINER_NAME)

# start container
rerun:
	docker start $(CONTAINER_NAME)

# stop + delete container, delete image
# fails if something went wrong during build process, because the image has no name or the container name is in use ...
clean:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)
	docker rmi -f $(IMAGE_NAME)

# show mapped port, which maps to exposed port inside the container (5000 in our case)
port:
	docker port $(CONTAINER_NAME) 5000

# Mac OS only: 
ip:
	if [ boot2docker ] ; \
	then \
		boot2docker ip ; \
	fi;
