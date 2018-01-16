---
layout: post
title:  "Jekyll에 Bootstrap 적용기"
date:   2016-05-11 01:22:04 +0900
categories: 'dev'
tags: [jekyll, bootstrap]
---

디자인 센스가 없는 개발자가 의지할 곳이라고는 Bootstrap 밖에 없으므로..
Bootstrap을 블로그에 삽입해보려고 한다.

삽입 방법은 [이 곳](https://github.com/benbalter/jekyll-bootstrap-sass)에서 참조했다.

Gemfile에 아래와 같이 추가한다.

`gem 'jekyll-bootstrap-sass'`

그 뒤 \_config.yml 파일을 열어서 아래와 같이 추가해 준다.

```
gems:
  - jekyll-bootstrap-sass
bootstrap:
  assets: true
```

그리고 css/main.scss 에 @import 부분을 찾아서 아래와 같이 추가해준다.

`'bootstrap';`


### 중간 결론
이대로 하면 css는 제대로 로드해오는 것 같은데..

JS쪽은 로드해오지 않는 것 같다.

현재 블로그에 부트스트랩을 적용하지 않았는데, 그 이유는 Jekyll의 기본 테마와 Bootstrap 프레임워크를 로드해올 경우 디자인 충돌이 있으므로 제대로 된 적용은 유보했다.

내 마음에 드는 스타일로 디자인을 잡게 된다면 작업을 한 뒤 다시 한번 포스팅 하도록 해야겠다.
