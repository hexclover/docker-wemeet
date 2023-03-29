FROM ubuntu:jammy
MAINTAINER 0xCLOVER

WORKDIR /

# Parameters
ARG REPO="http://mirrors.tuna.tsinghua.edu.cn"
ARG TIMEZONE="Asia/Shanghai"
ARG TMVERSION="3.14.0.401"
ARG DEBURL="https://updatecdn.meeting.qq.com/cos/1b001ef75914a1d6948decb8c2550b47/TencentMeeting_0300000000_${TMVERSION}_x86_64_default.publish.deb"
ARG SHA512SUM="df1528be8b58f61f2fb7e53e012fb4c6d9c014a9f0d60e47ebee2bfc89b7a54db13dbbaa83b27c2a7650628f3844fb333637e6cde22622e6cd42ac15eed7954e"
ARG DEBFILE="/tm.deb"

# Setup repo & timezone
RUN if [ -n "$REPO" ]; then sed -i "s%https\\?://\\(archive\\|security\\).ubuntu.com%${REPO}%g" /etc/apt/sources.list; fi && \
    apt-get update --error-on=any
RUN ln -fs /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Install tools
RUN apt-get install -y curl
RUN apt-get install -y tigervnc-standalone-server novnc websockify && ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html
RUN apt-get install -y openbox xinit python3-xdg libv4l-0 sudo --no-install-recommends
RUN apt-get install -y fcitx5 fcitx5-frontend-gtk3 fcitx5-frontend-qt5 fcitx5-chinese-addons --no-install-recommends
RUN apt-get install -y locales fonts-noto-cjk

# Install wemeet & dependencies
RUN apt-get install -y libnss3 libx11-6 desktop-file-utils libpulse0 libwayland-egl1 libgl1-mesa-dev libharfbuzz0b libasound2 libfontconfig1 dbus-x11 xdg-utils libpci3
RUN curl -o "$DEBFILE" "$DEBURL" && echo "$SHA512SUM $DEBFILE" | sha512sum -c
RUN dpkg -i "$DEBFILE" && rm -f "$DEBFILE"

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN useradd -mG audio,video wemeet && \
    mkdir /wemeet && \
    chown wemeet:wemeet /wemeet && \
    echo "wemeet ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY start.sh /
RUN chmod +x start.sh

USER wemeet

CMD ["/start.sh"]
