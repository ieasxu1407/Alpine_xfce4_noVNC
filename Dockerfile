FROM alpine:edge

# 1. 필수 패키지 및 xfce4, noVNC 환경 설치
RUN apk update && \
    apk add --no-cache bash xfce4-session xfce4-terminal xvfb x1920x1080 xorg-server xinit xf86-video-vesa xf86-input-evdev xf86-input-mouse xf86-input-keyboard udev dmidecode chromium openbox git python3 websockify && \
    rm -rf /var/cache/apk/*

# 2. noVNC 다운로드 및 클라우드타입 HTTPS(WSS) 대응 패치 🌟
RUN git clone https://github.com /root/noVNC && \
    sed -i 's/ws:\/\//wss:\/\//g' /root/noVNC/vnc.html && \
    sed -i 's/ws:\/\//wss:\/\//g' /root/noVNC/include/ui.js

# 3. 환경 변수 및 패스워드 설정
ENV DISPLAY=:1
ENV VNC_PASSWD=wer29292@@

# 4. 실행 및 포트 설정
EXPOSE 6080

CMD ["sh", "-c", "Xvfb :1 -screen 0 1024x768x16 & xfce4-session & websockify --web /root/noVNC 6080 localhost:5901"]
