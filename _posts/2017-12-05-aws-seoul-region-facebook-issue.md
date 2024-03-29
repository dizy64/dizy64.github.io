---
layout: post
title:  "AWS 서울 리전과 페이스북 로그인 이슈"
subtitle: "Facebook Oauth 지연 관련 문제"
date: 2017-12-05 22:35:12 +0900
categories: 'dev'
tags: [AWS, facebook, oauth]
permalink: dev/2017/12/05/aws-seoul-region-facebook-issue.html
---

새로 입사한 회사의 서비스에 페이스북 로그인 하기 기능이 있는데 이게 제대로 작동하지 않는다 제보가 지난 주 부터 있었다고 한다.

페이스북에서 인증 토큰을 돌려받고 나면 Timeout이 나고 로그인이 안 되는데 이 문제에 대한 임시 해결책을 게시한다.

## 증상

1. 이미 인증이 되고 있는 사람들은 로그인이 잘 됨 (느리지만)
2. 새로운 인증 (App 삭제 후) 요청시 Timeout error (504)
3. users/auth/facebook/callback... 으로 오는 URL에서 멈춤.
4. 미들웨어 처리단에서의 문제인지 App의 Controller 단계까지 오지 않음.
5. 새로고침시 간헐적으로 된다...?


## 원인

특정 서버에서 페이스북 Graph API 서버로 요청하면 응답률이 떨어짐.

결론은 네트워크 장애 문제인 것이고 DNS 로 추측함.

## 문제 해결 방법

[페이스북 AWSKRUG에 관련 이슈 글 발견](https://www.facebook.com/groups/awskrug/permalink/1213665808735441/?pnref=story)으로 문제 해결.

그나마 빠르게 응답하는 아이피로 연결하는 방법이었다.

운영중인 서버에 들어가서 `/etc/hosts` 를 아래와 같이 수정한다. (root 권한 필요함)

```
31.13.68.12 graph.facebook.com
```


## 결론

DNS의 문제라고도 하고, 결국은 한국에서 해외 대역망 문제라고도 하는데

확실히 요즘 KT에서도 해외망이 느리다고 그러고.. 전반적으로 해외망 속도가 안나오는 것 같다.

**임시방편이기 때문에 꼭 나중에 안정화되면 풀어줘야 함.**

만약 이걸 풀어주지 않으면 서버 아이피가 바뀌거나 등등의 문제일때 아예 서비스가 안될수도 있음.

그렇기 때문에 종종 서버에 ping을 날리는 등 테스트를 해보는 게 좋을 듯 하다.
