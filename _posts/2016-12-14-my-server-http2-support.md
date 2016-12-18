---
layout: post
title:  "내 서버에 http/2 적용기 (Ubuntu + Nginx + SSL 인증서 발급받기")
subtitle: "HTTP/2 를 설정하기 위한 고군분투기(...)"
date: 2016-12-14 14:41:42 +0900
categories: 'dev'
---

오늘은 내 서버에 http 2를 적용했다. 딱히 뭐가 없는 사이트긴 하지만 그냥 해볼 수 있을때 해두자.. 정도로... 생각해서 진행했다.

# HTTP/2 란?

기존의 HTTP/1.1은 99년도에 출시되어 지금까지 유지하고 있는 프로토콜이다.<br/>
... 사실 여기까지만 말해도 이해가 될 것 같긴 하지만...<br/>
처음에 웹은 정말 논문을 공유하는 정도의 수준을 생각했었고..<br/>
속도나 현재 디바이스들과 인터넷 환경에 고려가 전혀 되지 않은 채로 정해진 규격이다.

HTTP/1.1의 Connection 요청 처리를 개선하기 위해 pipelining 등을 사용하기도 하고.. 그로 인해서 Round Trip 문제도 생긴다고 한다.

웹 속도와 처리를 개선하기 위해 다양한 노력이 있었는데 제일 유명한 것이 Google사의 SPDY 프로토콜이고.. 자세한 건 <a href="http://d2.naver.com/helloworld/140351" target="_blank" alt="SPDY는 무엇인가?">이 글</a>을 참조하면 좋을 듯 하다.

HTTP/2도 SPDY를 고안하여 만들어졌다고 하니 이런 역사를 공부해봐야 할 것 같다.


아무튼(...) 이러한 개선을 위해 노력하고 있고. 지원하는 브라우저도 늘어난다고해서 내 개인 서버에 적용해보았다.

# NGINX 업그레이드

처음 적용할 때 내 Ubuntu 버전은 14.04 LTS 였고 apt로 nginx 패키지를 업그레이드 하려했지만 되지 않았다.

NGINX 버전을 올리기 위해서 apt 소스 리스트를 업데이트해주어야 했다.

우선 /etc/apt/sources.list.d/nginx.list 라는 파일을 만들고 아래와 같이 입력한다.

```
deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx
deb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx
```

그리고 사이닝 키를 추가한다.

```
wget -q -O- http://nginx.org/keys/nginx_signing.key | sudo apt-key add -
```

그 후 nginx 를 설치한다. 만약에 이전에 설치한게 있으면 지우고 설치하는게 제일 깔끔하더라. (설정 파일은 안날라감)

```
sudo apt-get update
sudo apt-get install nginx
```

설정 파일을 덮어 쓸 것인지 물어보는데 기존의 설정 파일이 복잡하지 않아서 나는 덮어쓰기를 했다.

설정을 바꾸려고 보니.. HTTP/2는 HTTPS에서만 적용되고.. SSL 인증서가 필요하다.

아 맞다 나 인증서가 없네..?;

# SSL 인증서 발급받기

개인 사이트인데 인증서를 막상 구입해서 쓰려니 부담이 됐다.

문득 떠오른 <a href="https://letsencrypt.org/" target="_blank">Let's Encrypt</a>.. 무료로 SSL를 발급해준다는 이야길 들은 적이 있었다.

## 설치 방법

<a href="https://certbot.eff.org" target="_blank">https://certbot.eff.org</a>에 가면 자신의 환경에 맞는 설치 방법들을 볼 수 있다.

나는 nginx on ubuntu 14.04 를 기준으로 진행한다.

다운을 받고 실행 권한을 맞춰준다.

```
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
```

실행을 한다.

```
./certbot-auto certonly --standalone -d example.com -d www.example.com
```

그리고 자동으로 90일이 되면 자동으로 리뉴얼 하도록 하는 명령어

```
./certbot-auto renew --dry-run 
```

이렇게 발급받은 후 nginx 에 세팅을 해야하는데 이 부분은 <a href="https://mozilla.github.io/server-side-tls/ssl-config-generator/">Mozilla SSL Configuration Generator</a>를 이용했다.

간단하게만 세팅한 걸 설명하자면

/etc/nginx/sites-enables/880322.tld 파일에 433 port ssl 을 추가한다.

```
server {
  listen 443 ssl http2;

  ssl_certificate /etc/letsencrypt/live/880322.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/880322.com/privkey.pem;
  ssl_session_timeout 1d;
  ssl_session_cache shared:SSL:50m;
  ssl_session_tickets off;

  # Diffie-Hellman parameter for DHE ciphersuites, recommended 2048 bits
  ssl_dhparam /etc/nginx/ssl/dhparam.pem;
  # run openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers 'ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS';
  ssl_prefer_server_ciphers on;
}
```

정로도 세팅했다.

잘 됐는가! 했는데 안되더라..;

예상이 가능한 원인은 openssl 버전이었는데.. 귀찮아서 ubuntu 버전을 업데이트 했더니 http2가 적용됐다.

다음번엔 openssl을 따로 업그레이드 하넌 방법을 알아보는 편이 나을듯.

아무튼 오늘의 뻘짓은 여기까지..
