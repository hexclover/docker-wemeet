P := $(shell pactl info | grep 'Server String' | cut -d ':' -f2 | xargs)

all:
	mkdir -p ~/wemeet
	docker build -t docker-wemeet .
	docker run --rm -ti -e PULSE_SERVER=unix:/tmp/pulse -v $P:/tmp/pulse -v ~/wemeet:/wemeet -p 127.0.0.1:6008:6008 docker-wemeet
