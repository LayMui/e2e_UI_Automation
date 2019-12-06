#!make
__dummy := $(shell touch .env)
include .env
export

.DEFAULT_GOAL := docker-build

NOW = $(shell date +"%c" | tr ' :' '__')
NAME=internal/converse-e2e-test
#TAG = $(shell majorVersion=1.0 && branch=$$(git branch | grep \* | cut -d ' ' -f2) && branch=-$${branch\#\#\*\/} && branch=$${branch/-master/} && branch=$${branch/feature-/} && echo "$${majorVersion}.$$(git rev-list HEAD --count . )$${branch}" )
TAG=latest

help:
	@echo ""
	@echo " +---------------------------------------------+"
	@echo " | iConverse Test Image Suite             |"
	@echo " +---------------------------------------------+"
	@echo " |_ docker-push"
	@echo " |      Pushes current version up to repo"
	@echo " |_ docker-build"
	@echo " |      Builds Current version"
	@echo " |_ test"
	@echo " |      Execute run_cucumber.sh"
	@echo " +---------------------------------------------+"
	@echo ""

docker-build:
	docker build  -t docker.exm-platform.com/${NAME}:${TAG} .

docker-push:
	docker push docker.exm-platform.com/${NAME}:${TAG}

test:
	docker run docker.exm-platform.com/${NAME}:${TAG} 
