---
layout: post
title:  "Certbot 새 인증서 발급시 에러 발생하는 문제"
subtitle: "Client with the currently selected authenticator does not support any combination of challenges that will satisfy the CA."
date: 2018-02-06 15:24:21 +0900
categories: 'dev'
tags: [nginx, apache, https, letsencrypt, certificate]
---

>Obtaining a new certificate
>Performing the following challenges:
>Client with the currently selected authenticator does not support any combination of challenges that will satisfy the CA.
>Client with the currently selected authenticator does not support any combination of challenges that will satisfy 
>the CA.

이게 갑자기 떠서 놀랬다.

아래와 같은 메서드로 해결. 

## apache

```shell
sudo certbot --authenticator standalone --installer apache -d example.com -d www.example.com \
--pre-hook "systemctl stop apache2" --post-hook "systemctl start apache2"
```

## nginx 

```shell
sudo certbot --authenticator standalone --installer nginx -d example.com -d www.example.com \
--pre-hook "systemctl stop nginx" --post-hook "systemctl start nginx"
``` 

## 결론

자신의 도메인이 아니더라도 발급해주는 부분을 해결하기 위해 해둔 조치 등으로 생긴 문제 같은데 (영알못;)
우선 이런식으로 해결 할 수 있다.
