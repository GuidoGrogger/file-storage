.PHONY: help start docker-compose test-api local setup-azure setup-azurite setup

help:
	@echo "Available commands:"
	@echo "  make start          - Starts the Go application"
	@echo "  make docker-compose - Starts the docker-compose services in detached mode"
	@echo "  make test-api       - Executes the API tests"
	@echo "  make local          - Starts the Go application with Azurite for local development"
	@echo "  make setup-azure    - Installs Azure CLI using Homebrew (Mac OS)"
	@echo "  make setup-azurite  - Installs Azurite, starts it and creates the 'files' container"
	@echo "  make setup          - Runs setup-azure and setup-azurite"

start:
	@echo "Starting Go application..."
	go run main.go

docker-compose:
	@echo "Starting docker-compose services..."
	docker-compose up -d

test-api:
	@echo "Executing API tests..."
	./scripts/test-api.sh

local:
	@echo "Starting Go application with Azurite..."
	USE_AZURITE=true go run main.go

setup-azure:
	@echo "Installing Azure CLI..."
	brew install azure-cli

setup-azurite:
	@echo "Installing and setting up Azurite..."
	npm install -g azurite
	@echo "Starting Azurite in the background..."
	pkill -f azurite || true
	azurite &
	@echo "Creating 'files' container in Azurite..."
	sleep 2
	az storage container create --name files --connection-string 'DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;'

setup: setup-azure setup-azurite
	@echo "Setup complete!" 