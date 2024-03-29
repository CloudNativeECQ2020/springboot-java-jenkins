# makefile to build a container to run firefox
# pmcampbell
# 2020-04-16
# 2020-05-15 add amazon ecr 

include	 config.make
ECRREPO=016076643457.dkr.ecr.us-east-2.amazonaws.com
ECRIMG=tricia/ecrrepo
ECSTASK=fargate-task
ECSSERVICE=shakespeare-ec-service
ECSTASK_REV=1
#ECSCLUSTER=default
ECSCLUSTER=springbootj-fargate

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
	java -jar target/*.jar

run-fg:  ## run the container logs to stdout
	docker run -p $(HOST_PORT):$(CONTAINER_PORT) --name $(NAME)  $(NAME)
	@echo load the image via a browser http://ip.add.re.ss:${HOST_PORT}

# returns true if found (0) and false if not found (1) 
# $(shell (docker ps | grep -q ${NAME}; echo $$?))
run:  ## run the container detached (~in the background )
	ISRUNNING=$(shell (docker ps | grep  ${NAME} | cut -f  1 -d " "))

#ifdef $(ISRUNNING)
ifneq ($(ISRUNNING), "")
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

ecr: ecrauth ecrpublish ## get auth pass & auth to aws  & publish to amazon Amazon Elastic Container Registry 
ecrauth: ## get auth password & auth with ecr /aws 
	 /usr/local/bin/aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin ${ECRREPO}

ecrpublish: ## publish to amazon Amazon Elastic Container Registry 
	docker tag ${NAME} ${ECRREPO}/${ECRIMG}:latest
	docker image push ${ECRREPO}/${ECRIMG}:latest

ecrimage: ## show image in ECR repo
	aws ecr list-images --region us-east-2  --repository-name ${ECRIMG}
	aws ecr describe-images --repository-name ${ECRIMG}


ecrrepo: ## show ECR repo info
	aws ecr describe-repositories  

# note different output defaults to json on centos, not ubuntu
# exact same version, build etc of aws cli
PARM=$(shell (aws ecs list-tasks --cluster $ECSCLUSTER) --output json| jq -r '.taskArns[]'))
TASK=$(shell /usr/local/bin/aws ecs list-tasks --cluster ${ECSCLUSTER} --output json| jq -r ".taskArns[]")
ecsrestart: ## stop  the task after image updated, will auto pull & reload image
	/usr/local/bin/aws ecs stop-task --cluster $(ECSCLUSTER) --task "${TASK}"


#	@echo PARM $(PARM) 
#	aws ecs stop-task --cluster ${ECSCLUSTER} --task ${PARM}
#	aws ecs update-service --cluster default --service ${ECSSERVICE} --task-definition ${ECSTASK}:${ECSTASK_REV} 

ecstask: ## describe ecs task
#	PARM=$(shell (aws ecs list-tasks --cluster ${ECSCLUSTER} --output json| jq -r '.taskArns[]'))
	@echo PARM $(PARM) 
	aws ecs describe-tasks --cluster ${ECSCLUSTER} --task ${PARM}

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
