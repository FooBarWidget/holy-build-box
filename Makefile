VERSION = 2.1.0
MAJOR_VERSION = 2.1

.PHONY: all 32 64 test tags release

all: 32 64

32:
	docker build --rm --squash -t phusion/holy-build-box-32:$(VERSION) -f Dockerfile-32 --pull .

64:
	docker build --rm --squash -t phusion/holy-build-box-64:$(VERSION) -f Dockerfile-64 --pull .

test:
	echo "*** You should run: SKIP_FINALIZE=1 linux32 bash /hbb_build/build.sh"
	docker run -t -i --rm -e DISABLE_OPTIMIZATIONS=1 -v `pwd`/image:/hbb_build:ro phusion/centos-6-32:latest bash

test64:
	echo "*** You should run: SKIP_FINALIZE=1 bash /hbb_build/build.sh"
	docker run -t -i --rm -e DISABLE_OPTIMIZATIONS=1 -v `pwd`/image:/hbb_build:ro centos:6 bash

tags:
	docker tag phusion/holy-build-box-32:$(VERSION) phusion/holy-build-box-32:$(MAJOR_VERSION)
	docker tag phusion/holy-build-box-64:$(VERSION) phusion/holy-build-box-64:$(MAJOR_VERSION)
	docker tag phusion/holy-build-box-32:$(VERSION) phusion/holy-build-box-32:latest
	docker tag phusion/holy-build-box-64:$(VERSION) phusion/holy-build-box-64:latest

release: tags
	docker push phusion/holy-build-box-32
	docker push phusion/holy-build-box-64
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
