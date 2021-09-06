# docker-wemeet

WIP.

**If you have no problem with it, just download and install the official deb package from https://source.meeting.qq.com/download-center.html.**

## Description

Isolate the [Tencent Meeting](https://meeting.tencent.com) app with a Docker container. Inspired by [johngong/baidunetdisk](https://hub.docker.com/r/johngong/baidunetdisk).

## Usage

You can simply run `make` and visit http://127.0.0.1:6008 if it works for you. Otherwise follow the steps below.

### Building the image

```bash
docker build -t docker-wemeet .
```

### Checking your audio configuration

It's assumed that you have PulseAudio installed. Run `pactl info` and find a line like this:

```plaintext
Server String: /run/user/1000/pulse/native
```

Take down that path; it will be denoted by `${P}` below.

Or alternatively, you can set `${P}` directly using the command

```bash
P=$(pactl info | grep 'Server String' | cut -d ':' -f2 | xargs)
```

### Starting the container

First, create a data directory for Tencent Meeting to use:

```bash
mkdir ~/wemeet
```

Then start the container with:

```bash
docker run --rm -e PULSE_SERVER=unix:/tmp/pulse -v ${P}:/tmp/pulse -ti -v ~/wemeet:/wemeet -p 127.0.0.1:6008:6008 docker-wemeet
```

Now you can access http://127.0.0.1:6008 with your browser.

## What's missing

- Webcam
- Input method

## Troubleshooting

- Check the ownership and permissions on your data directory (e.g. `~/wemeet`). If it is created by Docker automatically, it will likely have the ownership `root:root`, making the app unable to access it.
