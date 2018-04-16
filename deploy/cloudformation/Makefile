## DEPLOY ##
DEPLOY_REGION 	?= ap-northeast-1
ACCOUNT_ID		?= 929226109038

## RESULT_VARS ##

DEPLOY_REGISTRY = $(ACCOUNT_ID).dkr.ecr.$(DEPLOY_REGION).amazonaws.com

aws-create-registry: ## Create registry in aws ECR service: make create-registry
	aws cloudformation deploy \
	--template-file ./deploy/cloudformation/registry.yml \
	--stack-name $(PROJECT_NAME)-registry \
	--parameter-overrides \
		RepositoryNameTest=$(REPOSITORY_TEST) \
		RepositoryNameServer=$(REPOSITORY_SERVER) \
		RepositoryNameServerFake=$(REPOSITORY_SERVER_FAKE) \
	--region $(DEPLOY_REGION) \
	--capabilities CAPABILITY_IAM


aws-deploy: ## Exec all step to deploy microservice in aws: make deploy
	make aws-login aws-create-image aws-push

aws-create-image:
	docker tag $(REPOSITORY_TEST):$(TAG_DEPLOY) $(DEPLOY_REGISTRY)/$(REPOSITORY_TEST):$(TAG_DEPLOY)
	docker tag $(REPOSITORY_TEST):$(TAG_DEPLOY) $(DEPLOY_REGISTRY)/$(REPOSITORY_TEST):latest

	docker tag $(REPOSITORY_SERVER):$(TAG_DEPLOY) $(DEPLOY_REGISTRY)/$(REPOSITORY_SERVER):$(TAG_DEPLOY)
	docker tag $(REPOSITORY_SERVER):$(TAG_DEPLOY) $(DEPLOY_REGISTRY)/$(REPOSITORY_SERVER):latest

	docker tag $(REPOSITORY_SERVER_FAKE):$(TAG_DEPLOY) $(DEPLOY_REGISTRY)/$(REPOSITORY_SERVER_FAKE):$(TAG_DEPLOY)
	docker tag $(REPOSITORY_SERVER_FAKE):$(TAG_DEPLOY) $(DEPLOY_REGISTRY)/$(REPOSITORY_SERVER_FAKE):latest

aws-push: ## Push image to aws ECR: make publish
	docker push $(DEPLOY_REGISTRY)/$(REPOSITORY_TEST):$(TAG_DEPLOY)
	docker push $(DEPLOY_REGISTRY)/$(REPOSITORY_TEST):latest

	docker push $(DEPLOY_REGISTRY)/$(REPOSITORY_SERVER):$(TAG_DEPLOY)
	docker push $(DEPLOY_REGISTRY)/$(REPOSITORY_SERVER):latest

	docker push $(DEPLOY_REGISTRY)/$(REPOSITORY_SERVER_FAKE):$(TAG_DEPLOY)
	docker push $(DEPLOY_REGISTRY)/$(REPOSITORY_SERVER_FAKE):latest

aws-login: ## Push image to aws ECR: make publish
	aws ecr get-login --no-include-email --region $(DEPLOY_REGION) | sh
