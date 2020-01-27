---
layout: post
title: 크롬과 파이어폭스에서 DNS over HTTPS(DoH) 설정
date: 2020-01-27 20:05:18 +0900
categories: 'tools'
---

DNS over HTTPS(DoH)는 DNS 확인을 HTTPS 프로토콜로 처리하기 위한 통신 규약이다.<br/>
기본적으론 중간자 공격에 의한 감청이나 조작을 방지하기 위해 등장했다고 한다.<br/>

크롬은 아직 Encrypted SNI는 지원하지 않는 것 같다.<br/>
파이어폭스는 가능하니 이 쪽을 참고해보는 게 좋음<br/>

## 네트워크의 DNS 설정

[DoH를 지원하는 DNS 목록 및 지원 툴 확인이 가능한 링크](https://github.com/curl/curl/wiki/DNS-over-HTTPS)를 참조하여 원하는 DNS를 사용하는 것을 추천한다.

이 글에서는 Cloudflare DNS를 이용하는 것으로 설명한다.

우선 자신의 컴퓨터의 네트워크 설정에서 DNS 설정을 `1.1.1.1` 보조 `1.0.0.1`로 설정한다.

## FIREFOX

주소창에 `about:config`로 입력하여 접속하여 아래와 같이 세팅한다.

```shell
network.trr.bootstrapAddress: 1.1.1.1
network.trr.mode: 2
network.trr.uri: https://mozilla.cloudflare-dns.com/dns-query
network.security.esni.enable: true
```

network.trr.uri 옵션은 DNS over HTTPS를 지원하는 호스트 서버

network.trr.bootstrapAddress 옵션은 비워도 무방하지만 사용할 호스트 서버의 DNS IP를 입력하는게 좋다고 하여 1.1.1.1 로 설정했다.

network.trr.mode 옵션은 아래와 같이 세팅이 가능하다.


- 0: DNS over HTTPS 모드 사용하지 않음
- 1: 기존방식과 DNS over HTTPS 동시 실행하여 응답이 빠른 것을 사용함
- 2: DNS over HTTPS에 먼저 질의 후 실패하면 기존 방식 사용
- 3: DNS over HTTPS만 사용
- 4: 둘다 질의하지만 기존의 방식만 사용함
- 5: DOH 비활성화

network.security.esni.enable 옵션은 Encrypted SNI 를 위한 옵션이다.

## GOOGLE CHROME

크롬에서 주소창에 `chrome://flags/#dns-over-https` 로 입력하여 `Secure DNS lookups` 값을 Enabled로 변경해주면 된다.

## 설정 확인

### DoH 설정 여부 확인하기 

[https://1.1.1.1/help](https://1.1.1.1/help)에 접속하여 DoH 설정 여부를 체크할 수 있다.<br/>

### Encrypted SNI 설정 여부 확인하기

[https://www.cloudflare.com/ssl/encrypted-sni/](https://www.cloudflare.com/ssl/encrypted-sni/) 에 접속하여 Encrypted SNI 설정이 되었는지 상태 체크가 가능하다.
