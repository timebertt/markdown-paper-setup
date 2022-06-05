IMG = ghcr.io/timebertt/markdown-paper-setup
TAG = latest

build:
	docker build --cache-from $(IMG):latest -t $(IMG):$(TAG) .

push:
	docker push $(IMG):$(TAG)
