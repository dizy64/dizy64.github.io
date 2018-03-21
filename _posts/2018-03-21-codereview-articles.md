---
layout: post
title:  "코드 리뷰와 관련 된 아티클 모음"
date: 2018-03-21 17:52:21 +0900
categories: 'dev'
tags: [codereview, team, culture]
---

최근의 IT기업들은 대부분 코드리뷰를 진행하고 있다.

코드 리뷰를 진행하는 이유는 크게 팀원들끼리의 작업을 공유하고, 배포 전에 위험이 될 수 있는 코드를 제거하고 소프트웨어의 품질을 높이기 위해서 필수가 되어가고 있다.

필요는 하지만 미루는 팀도 꽤 있을 것이고 진행하고는 있지만 뭔가 아쉬운 팀도 많을 것 같다.

내가 일하는 회사의 개발팀에서도 우리만의 문화를 만들기 위해 애를 쓰고 있는 중이다.

다른 팀은 어떻게 하고 있는지, 우리가 놓치고 있는 부분은 없는지 공유하기 위해서 아티클들을 정리하던 중에 공유해서 함께 본다면 더 좋을 것 같아서 공유하게 되었다.

아래는 인터넷 등을 통해서 수집한 코드리뷰와 관련된 글들이다.

여러분에 팀에도 안전한 문화를 만들기를 바란다.

## 코드 리뷰 가이드 및 팁

[코드 리뷰 가이드 - Edward Kim](http://www.haruair.com/blog/3116)

[코드 리뷰, 5가지만 기억하자.](https://silentsoft.kr/archives/20)

[매끄러운 ‘코드 리뷰’를 돕는 10가지 방법](http://www.bloter.net/archives/238819)

[소스코드 리뷰에 대한 짧은 이야기...](https://brunch.co.kr/@supims/11)

## 코드 리뷰 경험기

[코드리뷰, GitHub로 바로 적용하기](https://academy.realm.io/kr/posts/codereview-howto/)

[드라마의 Pair Programming과 Code Review 도입 후기 – DRAMA&COMPANY Engineering](http://blog.dramancompany.com/2016/05/%EB%93%9C%EB%9D%BC%EB%A7%88%EC%9D%98-pair-programming%EA%B3%BC-code-review-%EB%8F%84%EC%9E%85-%ED%9B%84%EA%B8%B0/)

[카카오스토리 웹팀의 코드리뷰 경험](https://www.slideshare.net/OhgyunAhn/ss-61189141)

[JavaScript 코드 리뷰 - 코드 리뷰 문화 – 좋은 JavaScript 코드 작성을 위한 블로그](https://cimfalab.github.io/deepscan/2016/08/code-review-1)

[코드리뷰, 이렇게 하고 있습니다. JANDI Tech](https://tosslab.github.io/codereview/2015/12/18/%EC%BD%94%EB%93%9C%EB%A6%AC%EB%B7%B0-%EC%9D%B4%EB%A0%87%EA%B2%8C-%ED%95%98%EA%B3%A0-%EC%9E%88%EB%8B%A4.html)

[코드 리뷰어 활동 후기 - 리디주식회사 RIDI Corporation](https://www.ridicorp.com/blog/2017/06/26/code-review/)

[NUNDEFINED :: 카카오스토리팀의 코드리뷰에 대한 질문과 답](http://blog.nundefined.com/62)

[카카오스토리 팀의 코드 리뷰 도입 사례 - 코드 리뷰, 어디까지 해봤니?](http://tech.kakao.com/2016/02/04/code-review/)

[구글의 깐깐한 코드리뷰 환경 - ㅍㅍㅅㅅ](http://ppss.kr/archives/90212)

[코드 리뷰 이야기 1 Popit](http://www.popit.kr/%EC%BD%94%EB%93%9C-%EB%A6%AC%EB%B7%B0-%EC%9D%B4%EC%95%BC%EA%B8%B0-1/)

[코드 리뷰 이야기 2 Popit](http://www.popit.kr/%EC%BD%94%EB%93%9C-%EB%A6%AC%EB%B7%B0-%EC%9D%B4%EC%95%BC%EA%B8%B02/)

## 결론

결국에는 팀이 처한 상황마다 코드리뷰를 할 수 있는 프로세스가 다를 것이다.

그래서 자동화 툴들을 많이 활용하는게 중요하다고 생각한다.

코드 정적 분석기로 문법에서의 방어를 우선적으로 하고, 통합 테스트 코드를 작성하여 검증하고 CI를 통해서 검증하는 자동화 인프라를 구축해둔다면 좀 더 유연한 개발 문화를 만들 수 있을 것 같다.
