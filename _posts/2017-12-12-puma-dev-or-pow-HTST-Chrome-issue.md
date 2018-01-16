---
layout: post
title:  "크롬에서 HSTS를 통해 .dev 도메인을 HTTPS로 강제로 전환하는 이슈"
date: 2017-12-12 09:27:45 +0900
categories: 'dev'
tags: [pow, puma-dev, https, development tools]
---

어제부터 갑자기 크롬으로 개발하는 사이트의 URL이 접속이 안되는 문제가 발생했다.

.dev 도메인을 모두 HTTPS 프로토콜로 전환시키는 문제로 인해 인증서 관련 오류가 났는데 이 문제는 어찌어찌 해결을 했는데, 현재 진행하는 프로젝트가 웹소켓을 쓰고 있어서 웹소켓 프로토콜까지 WSS://로 다 변경해줘야하는 문제가 있었다.

그리고 근본적인 원인을 찾아야 할 것 같아서 검색해 본 결과 다음과 같은 글을 발견했다.

<a href="https://ma.ttias.be/chrome-force-dev-domains-https-via-preloaded-hsts/" target="_blank">Chrome to force .dev domains to HTTPS via preloaded HSTS</a>

HTST는 HTTP로 접속 후 HTTPS로 리다이렉트 할 경우 생길 수 있는 취약점을 아예 원천적으로 막도록 브라우저에서 HTTPS로 접속할 사이트들을 강제하는 것인데 이 해당 도메인 리스트에 *.dev가 포함된 것으로 보인다.

그래서 pow나 puma-dev같이 .dev로 끝나는 도메인을 도메인으로 만들어주는 애들을 다른 도메인으로 변경하는 것을 권장하고 있어 보인다.


## POW 해결책

제일 유명한 <a href="http://pow.cx">pow.cx</a>에서는 이 부분을 .test 도메인을 디폴트로 변경해서 해결 한 것으로 보이는데 만약 이가 되어있지 않다면 `~/.powconfig`에서 아래와 같이 설정한다.
```bash
export POW_DOMAINS=test,local
```

아니면 최신 버전으로 재설치하길 권장한다.


## puma-dev 해결책

pow를 이용하는 것 같아서 똑같이 하려했는데 안됨.

puma-dev install를 다시 진행했다.

```bash
puma-dev -install -d test
```

이렇게 진행하면 .test로 접속이 가능해진다.


## 결론

.dev를 사용할 방법은 있는 것 같지만 좋은 방법은 아니니 권장하지 않고 `.localhost`나 `.test` 같은 다른 도메인을 이용하길 권장하는 것 같다.



## 참조한 사이트

1. <a href="http://pow.cx/manual.html" target="_blank">Pow User's Manual</a>
2. <a href="https://github.com/puma/puma-dev/issues/127">puma-dev github issue: Chrome to force .dev domains to HTTPS via preloaded HSTS</a>
3. <a href="https://rsec.kr/?cat=40" target="_blank">HSTS (HTTP Strict Transport Security) 개념과 설정</a>
4. <a href="https://ma.ttias.be/chrome-force-dev-domains-https-via-preloaded-hsts/" target="_blank">Chrome to force .dev domains to HTTPS via preloaded HSTS</a>
