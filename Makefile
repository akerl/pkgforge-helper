DOCKER_CMD = "docker run" \
	"--rm -t -i" \
	"-v ~/.gitconfig:/etc/gitconfig" \
	"-v $$(pwd):/opt/build" \
	"dock0/pkgforge"

.PHONY : default manual dircheck container

default: dircheck container
	$(DOCKER_CMD)

manual: dircheck container
	$(DOCKER_CMD) bash || true


ifneq ("$(wildcard .pkgforge)","")
dircheck:
	@true
else
dircheck:
	@echo ".pkgforge not found; run make from the repo root"
	@false
endif

ifneq ("$(wildcard Dockerfile)","")
CONTAINER_NAME = $$(pkgforge info | awk '/^name: / {print $$2}')
container:
	docker build -t $(CONTAINER_NAME)-pkg
else
container:
	@true
endif

