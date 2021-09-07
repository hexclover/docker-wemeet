FROM ubuntu:focal
MAINTAINER 0xCLOVER

ARG DEBURL="https://updatecdn.meeting.qq.com/ad878a99-76c4-4058-ae83-22ee948cce98/TencentMeeting_0300000000_2.8.0.0_x86_64.publish.deb"
ARG DEBFILE="/tm.deb"
ARG SHA256SUM="a6b3506b02870196694f138354ccce6faa81e38a19a24e3a3b3426c8b24efcbf"
ARG REPO="http://mirrors.tuna.tsinghua.edu.cn"
ARG TIMEZONE="Asia/Shanghai"

WORKDIR /

# Install Tencent Meeting & dependencies
RUN if [ -n "$REPO" ]; then sed -i "s%https\\?://\\(archive\\|security\\).ubuntu.com%${REPO}%g" /etc/apt/sources.list; fi && \
    apt-get update --error-on=any
RUN ln -fs /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get install -y \
    curl \
    libnss3 libx11-6 desktop-file-utils libpulse0 libwayland-egl1 libgl1-mesa-dev libharfbuzz0b libasound2 libfontconfig1 dbus-x11 xdg-utils
RUN curl -o "$DEBFILE" "$DEBURL" && \
    echo "$SHA256SUM $DEBFILE" | sha256sum -c && \
    dpkg -i "$DEBFILE" && rm -f "$DEBFILE"

RUN apt-get install -y tigervnc-standalone-server novnc websockify && \
    ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html
RUN apt-get install -y openbox xinit xterm python3-xdg libv4l-0 simplescreenrecorder sudo --no-install-recommends

COPY start.sh /
RUN chmod +x start.sh

RUN useradd -mG audio,video wemeet && \
    mkdir /wemeet && \
    chown wemeet:wemeet /wemeet && \
    echo "wemeet ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER wemeet
RUN mkdir -p ~/.config/autostart && \
    cp /usr/share/applications/wemeetapp.desktop ~/.config/autostart && \
    mkdir -p ~/.local/share && \
    ln -s /wemeet ~/.local/share/wemeetapp && \
    mkdir ~/.vnc && \
    touch ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd && \
    echo "exec dbus-launch openbox-session" >> ~/.vnc/xstartup

CMD ["/start.sh"]
