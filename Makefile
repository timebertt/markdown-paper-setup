IMG = ghcr.io/timebertt/markdown-paper-setup
TAG = latest

build:
	docker buildx build -t $(IMG):$(TAG) --target basic .
	docker buildx build -t $(IMG)/python:$(TAG) --target python .

push:
	docker push $(IMG):$(TAG)
	docker push $(IMG)/python:$(TAG)
