# makefile to build a container to run firefox
# pmcampbell
# 2020-04-16

include	 config.make

# .PHONY used if no options given
.PHONY: help
	@echo set up xeyes container  
help: ## put help info here
	@echo
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: maven build run ## maven build, container build and container run 
maven: ## build the app (maven)
	mvn compile
	mvn package

build: ## build container image from Dockerfile
	docker build -t $(NAME) .

runapp: ## run the app, locally for testing
	java --jar target/*.jar

run-fg:  ## run the container logs to stdout
	docker run -p $(HOST_PORT):$(CONTAINER_PORT) --name $(NAME)  $(NAME)
	@echo load the image via a browser http://ip.add.re.ss:${HOST_PORT}

# returns true if found (0) and false if not found (1) 
# $(shell (docker ps | grep -q ${NAME}; echo $$?))
run:  ## run the container detached (~in the background )	
ifneq ( $(shell (docker ps | grep -q ${NAME}; echo $$?)) , 1 ) 
	@echo stopping running container
	docker stop $(NAME)
	docker rm $(NAME)
endif
	docker run -d -p $(HOST_PORT):$(CONTAINER_PORT) --name $(NAME)  $(NAME)
	@echo load the image via a browser http://ip.add.re.ss:${HOST_PORT}
	docker ps 

sh:	shell  ##  shell into the container
shell:  ## shell into the container
	docker exec -ti $(NAME)  sh

logs: ## show logs for the containers
	docker logs -f $(NAME)

restart: stoprun ## use stop then run
clean:  stop prune ## use stop then prune

stop: ## stop and remove the containers
	docker stop $(NAME) ; docker rm $(NAME) ; docker ps

prune:  # clean up unused containers
	docker system prune -f ; docker images

net:     ## show the container network
check:  ## check docker run time
	systemctl status  docker
	docker info
	docker version
	docker images
	docker ps
	docker-compose version

publish:  ## publish to docker hub (interactive)  
	@echo publish to  docker hub, interactive 
	@echo be sure to tag it first with my repo tricia/imagename
        ifdef DOCKER_USER
		docker login   -u $(DOCKER_USER)
        else
		docker login 
        endif
	docker tag ${NAME} ${HUBUSER}/${NAME}:${VERSION}

	docker image push $(NAME):latest
