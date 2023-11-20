APP=$(shell basename -s .git $(shell git remote get-url origin))
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

# Default variables for TARGETOS and TARGETARCH
REGISTRY_DEFAULT=ptarasyuk
TARGETOS_DEFAULT=linux
TARGETARCH_DEFAULT=amd64

# We use ?= to enable them to be reassigned from the command line
REGISTRY ?= $(REGISTRY_DEFAULT)
TARGETOS ?= $(TARGETOS_DEFAULT)
TARGETARCH ?= $(TARGETARCH_DEFAULT)

format: ## Format source code using gofmt
	gofmt -s -w ./

lint: ## Run golint to check code standards
	golint

test: ## Run Go tests
	go test -v

get: ## Get dependencies using go get
	go get

build: format get ## Build the application
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/PTarasyuk/kbot/cmd.appVersion=${VERSION}

image: ## Create a Docker image
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push: ## Push Docker image to the registry
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean: ## Remove the built executable and docker image
	rm -rf kbot
	docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

help: ## Display this help message
	@echo "Usage: make [target] [REGISTRY=value] [TARGETOS=value] [TARGETARCH=value]"
	@echo ""
	@echo "Targets:"
	@awk '/^[a-zA-Z\-\_0-9]+:/ {                              \
		nb = sub( /^## /, "", helpMsg );                      \
		if(nb == 0) {                                         \
			helpMsg = $$0;                                    \
			nb = sub( /^[^:]+:.* ## /, "", helpMsg );         \
		}                                                     \
		if (nb)                                               \
			printf "\033[36m%-20s\033[0m %s\n", $$1, helpMsg; \
	}                                                         \
	{ helpMsg = $$0 }'                                        \
	$(MAKEFILE_LIST)
	@echo ""
	@echo "You can also override the following variables from the command line:"
	@echo "  REGISTRY     - Target docker registry (default: $(REGISTRY_DEFAULT))"
	@echo "  TARGETOS     - Target operating system (default: $(TARGETOS_DEFAULT)). Recommended variables: linux, darwin, windows"
	@echo "  TARGETARCH   - Target architecture (default: $(TARGETARCH_DEFAULT)). Recommended variables: amd64, arm64"
	@echo ""