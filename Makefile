IMG = ghcr.io/timebertt/markdown-paper-setup
TAG = latest
PLATFORM = linux/amd64,linux/arm64

build:
	docker buildx build --platform $(PLATFORM) -t $(IMG):$(TAG) --target basic .
	docker buildx build --platform $(PLATFORM) -t $(IMG)/python:$(TAG) --target python .

push:
	docker push $(IMG):$(TAG)
	docker push $(IMG)/python:$(TAG)
