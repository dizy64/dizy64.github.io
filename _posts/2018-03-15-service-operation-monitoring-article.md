---
layout: post
title:  "서비스 운영을 하기 위한 모니터링 시스템에 대한 아티클 정리"
date: 2018-03-15 16:41:21 +0900
categories: 'operation'
tags: [log stash, fluentd, operation]
---

회사에서 각종 이벤트에 서버를 증설을 하고 모니터링을 해야할 일이 많은데 비해 로그는 제각각 서버에 있어서 분석하기 어려워서 고민하던 차에 몇가지 아티클들을 검색해보았고 똑같이 고민하는 곳이 있을 것 같아서 공유해봅니다.


## 실제 적용 사례에 대한 아티클들

### 드라마 컴파니(REMEMBER)에서의 서버 모니터링

[안정적인 서비스 운영을 위한 서버 모니터링 #1 – DRAMA&COMPANY Engineering](http://blog.dramancompany.com/2015/12/%EC%95%88%EC%A0%95%EC%A0%81%EC%9D%B8-%EC%84%9C%EB%B9%84%EC%8A%A4-%EC%9A%B4%EC%98%81%EC%9D%84-%EC%9C%84%ED%95%9C-%EC%84%9C%EB%B2%84-%EB%AA%A8%EB%8B%88%ED%84%B0%EB%A7%81-1/)

APM(Application Performance Management)를 이용한 모니터링에 관련된 이야기

나도 newRelic이나 다른 APM에 대한 경험이 있으므로 로그 수집 이외의 글 이걸로 줄인다.

어떤 서비스들이 있는지는 [100+ Top Server Monitoring & Application Monitoring Tools](https://haydenjames.io/50-top-server-monitoring-application-performance-monitoring-apm-solutions/) 를 보면 도움이 될 듯 하다.

[안정적인 서비스 운영을 위한 서버 모니터링 #2 – DRAMA&COMPANY Engineering](http://blog.dramancompany.com/2015/12/%EC%95%88%EC%A0%95%EC%A0%81%EC%9D%B8-%EC%84%9C%EB%B9%84%EC%8A%A4-%EC%9A%B4%EC%98%81%EC%9D%84-%EC%9C%84%ED%95%9C-%EC%84%9C%EB%B2%84-%EB%AA%A8%EB%8B%88%ED%84%B0%EB%A7%81-2/)

ELK(Elastic Search, Log statsh, Kibana) 스택을 이용한 다중 서버 로그 수집에 대한 고민을 엿 볼 수 있습니다.


### 카카오에서의 모니터링 시스템

[카카오의 전사 리소스 모니터링 시스템 - KEMI(Kakao Event Metering & monItoring)](http://tech.kakao.com/2016/08/25/kemi/)

카카오의 리소스 모니터링 시스템에 대한 소개. 확실히 큰 규모의 서비스를 하는 업체라서 고민한 흔적이 많이 보인다.

만약 작은 스타트업에서 모니터링을 위한 결정을 내리라고 하면 어떤 방법이 있을지에 대한 고민을 할 수 있을 듯.

### 그 외

[ELKR (ElasticSearch + Logstash + Kibana + Redis) 를 이용한 로그분석 환경 구축하기](https://medium.com/chequer/elkr-elasticsearch-logstash-kibana-redis-%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9C-%EB%A1%9C%EA%B7%B8%EB%B6%84%EC%84%9D-%ED%99%98%EA%B2%BD-%EA%B5%AC%EC%B6%95%ED%95%98%EA%B8%B0-f3dd9dfae622)

설치 방법이나 구축 구조를 볼 수 있던 아티클이다.

## 기술에 관련된 아티클

검색을 해보니 elk 이외에도 몇가지 log 수집을 하는 것들이 있고 fluentd 를 추천 받았다. (위의 카카오 아티클에서도 fluentd를 사용한다.)

그래서 관련 글들을 조금 검색해보았음.

[Fluentd vs. Logstash: A Comparison of Log Collectors](https://logz.io/blog/fluentd-logstash/)

[슭의 개발 블로그: Log Aggregator 비교 - Scribe, Flume, Fluentd, logstash](http://blog.seulgi.kim/2014/04/log-aggregator-scribe-flume-fluentd.html)

위 두개의 아티클은 Log Stash와 비교한 아티클이다.

[조대협의 블로그 :: 분산 로그 & 데이타 수집기 Fluentd](http://bcho.tistory.com/1115)

Fluentd 소개 글.

## 결론

음... 아직 내가 모르는 세계가 많다는 건 확실하다. 그리고 꽤 많은 선배들의 고민이 있으므로 윤곽이 잡힐 듯 하다.

대부분은 각 서버에 로그 수집기를 두고 다시 중앙에 Redis나 메세징 시스템을 이용해서 로그를 인덱싱해주는 로그 수집기가 있고 그걸 토대로 수집하는 형태인 듯 하다.
