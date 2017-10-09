build:
	docker build -t sheepdoge/pup-rust .

test: build
	docker run sheepdoge/pup-rust /bin/bash -c "./test.sh"

interactive: build
	docker run -it sheepdoge/pup-rust /bin/bash
