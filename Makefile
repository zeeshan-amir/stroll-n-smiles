.DEFAULT_GOAL:=help
.PHONY: help up down dev

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

up: ## Create and start SNS containers on background
	@docker-compose -p sns -f .docker/docker-compose.yml up -d

restart: ## Create and start SNS app container on background
	@docker-compose -p sns -f .docker/docker-compose.yml restart app

down: ## Stop and remove SNS containers
	@docker-compose -p sns -f .docker/docker-compose.yml down

dev: ## Build SNS image for local development (sns_app)
	@docker-compose -p sns -f .docker/docker-compose.yml build
