IMAGE_NAME = "vidatio/app"
CONTAINER_NAME = "vidatio"
PORT = 49000

all: rm_container build run port
restart: rm_container run

# build image from ubuntu
build:
	docker build -t $(IMAGE_NAME) .

# create and start container from image
run:
	docker run -d -p $(PORT):5000 --name $(CONTAINER_NAME) $(IMAGE_NAME)

# stop container
stop:
	docker stop $(CONTAINER_NAME) || true

# start container
rerun:
	docker start $(CONTAINER_NAME) || true

rm_container:
	docker rm -f $(CONTAINER_NAME) || true

rm_image:
	docker rmi -f $(IMAGE_NAME)
# stop + delete container, delete image
# fails if something went wrong during build process, because the image has no name or the container name is in use ...
rm_all: rm_container rm_image

# show mapped port, which maps to exposed port inside the container (5000 in our case)
port:
	docker port $(CONTAINER_NAME) 5000