---
layout: post
title:  "워드프레스 이미지 첨부 안되는 문제 해결하기"
subtitle: "NGINX와 PHP 권한 문제 정리"
date: 2017-08-24 12:30:16 +0900
categories: 'dev'
tags: [wordpress, nginx, php, configuration]
---

일상을 정리하기 위한 <a href="https://nadann.880322.com/" target="_blank">블로그</a>를 워드프레스로 만들었는데 파일 첨부가 안되는 문제때문에 고생했다.

내가 워드프레스를 구성한 환경을 정리하자면

* DigitalOcean Cloud Server
* Ubuntu 16.04
* NGINX
* PHP-FPM (PHP7)
* MariaDB

로 구성이 되어있다.

### 문제 발생

#### 사진이 업로드가 안되는 문제

검색해본 결과 원인은 다양했다.

1. 서버의 메모리가 부족한 경우
2. 서버의 하드가 부족한 경우
3. 웹 서버의 Client 접속시간 제한 문제거나 리퀘스트 바디 사이즈를 제한 한 경우

나의 경우는 3번이었고 내가 세팅한 파일 (`/etc/nginx/sites-available/` 안에 있는 파일)에 아래와 같이 넣어주고 해결 했다.

`client_max_body_size 20M;`

예시를 들자면 아래와 같이 넣어주면 된다.<br/>
용량은 임의로 20M 라고 했지만 능력껏 바꾸면 된다.

```
server {
  listen 80;

  client_max_body_size 20M;

  location ..... 중략
}
```

#### 업로드 된 사진이 보이지 않는 문제

이제 용량이 제법 큰 사진도 업로드는 가능해졌는데 업로드 된 파일이 보이지 않는 문제가 발생했다.<br/>
실제로 `wp-content/uploads/` 폴더를 들어가보면 파일은 업로드가 되어있는데 404 Not Found 가 뜨는 것이다.

추측컨데 nginx 에서의 rewrite rule 문제이거나 퍼미션 문제를 예상했다.

결국 이렇게 저렇게 찾아본 결과 nginx의 user는 `nginx`로 설정해두고 php-fpm user는 `www-data`로 설정해서 생긴 문제였다.<br/>
php가 파일을 업로드하거나 생성하면 `www-data:www-data`로된 user/group 권한을 가지고 있는데 nginx는 `nginx:nginx`의 그룹이었던 것이 문제.<br/>
소유권이 달랐던 nginx는 해당 파일을 불러올 수 없으므로 404 에러를 내뿜었던 것이다.

`/etc/nginx/nginx.conf` 에 들어가서 nginx 유저를 확인 하고 `/etc/php/7.0/fpm/pool.d/www.conf` 에서 user:group 을 nginx로 맞춰주고 문제는 종결.

단, 이미 업로드 된 파일들의 소유권은 www-data:www-data 로 되어있기 때문에 이 부분을 바꿔줬다.

``` shell
# 소유권을 변경한다.
chown -R nginx:nginx ~/public_html/wp-content/uploads/
# 접근 권한 문제가 생길 수 있으니 해당 유저의 그룹을 추가한다.
sudo usermod -aG nginx user
```


### 마치며

아주 가끔씩 세팅의 기본을 놓쳐서 생기는 문제들이 많다.<br/>
부끄러운 내용이라 포스팅을 할까 고민을 했긴 했는데 그래도 혹여나 똑같은 일을 겪을 사람이 있다면 참고하라고 포스팅을 해본다.<br/>
예전에 비슷하게 php 할때 코드가 제대로 동작하지 않아서 알고보니 **PHP SHORT TAG** 문제였던 적이 있었더랬지...<br/>
늘 꼼꼼하지 못함을 반성해본다.
