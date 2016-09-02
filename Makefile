DOCKER_CMD = docker run \
	--rm -t -i \
	-v $$(pwd):/opt/build \
	$(CONTAINER_NAME)

.PHONY : default manual dircheck container prereqs release

default: prereqs
	$(DOCKER_CMD)

release: prereqs
	$(DOCKER_CMD) pkgforge release

manual: prereqs
	$(DOCKER_CMD) bash || true

prereqs: dircheck container auth

ifdef GITHUB_CREDS
auth:
	@echo "targit: $(GITHUB_CREDS)" > .github || true
else
auth:
	@true
endif

ifneq ("$(wildcard .pkgforge)","")
dircheck:
	@true
else
dircheck:
	@echo ".pkgforge not found; run make from the repo root"
	@false
endif

ifneq ("$(wildcard Dockerfile)","")
CONTAINER_NAME = $$(awk '/^name / {print $$2}' .pkgforge | tr -d "'")
container:
	docker build -t $(CONTAINER_NAME)-pkg .
else
CONTAINER_NAME = dock0/pkgforge
container:
	@true
endif

