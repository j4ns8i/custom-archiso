.PHONY: help
help:
	@echo "custom-archiso help"
	@echo
	@echo "clean: \t\t\tclean intermediate build/output files"
	@echo "docker-mkarchiso: \tmake archlinux iso using docker"

.PHONY: clean
clean:
	rm -rf ./target/

DATE=$(shell date -u +%Y.%m.%d)

.PHONY: docker-mkarchiso
docker-mkarchiso: target/out/archlinux-$(DATE)-x86_64.iso

target/out/archlinux-$(DATE)-x86_64.iso:
	docker run \
		--name custom-archiso-docker \
		--privileged \
		--rm \
		-ti \
		-w /custom-archiso \
		-v $(PWD)/scripts/mkarchiso.sh:/custom-archiso/mkarchiso.sh:ro \
		-v $(PWD)/target/shared/work:/custom-archiso/work:rw \
		-e CUSTOM_ARCHISO_WORK_DIR=/custom-archiso/work \
		-v $(PWD)/target/shared/build:/custom-archiso/build:rw \
		-e CUSTOM_ARCHISO_BUILD_DIR=/custom-archiso/build \
		archlinux:base-devel \
		bash /custom-archiso/mkarchiso.sh
	mkdir -p target/out/
	cp $(PWD)/target/shared/build/out/archlinux* target/out/
