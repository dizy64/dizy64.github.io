---
layout: post
title:  "Jekyll를 이용하여 Github Pages에 블로그 구동하기"
subtitle: "깃허브 페이지 호스팅을 통해 공짜로 블로그를 시작해보자."
date:   2016-05-10 18:08:53 +0900
categories: 'dev'
---

Github에서는 [Pages](https://pages.github.com/)라는 서비스를 제공하고 있다.
이 서비스를 이용하면 정적인 페이지를 올릴 공간을 호스팅 받을 수 있는데 이를 활용하여 블로그를 할 수 있게끔 해주는 라이브러리들이 있다.
각 언어별로 지원하는 오픈소스 라이브러리들이 많으니 참고하길 바란다.

그 중에서도 나는 Jekyll이라는 Ruby Gem을 이용하여 블로그를 시작했다.

우선 Ruby가 설치되어있다는 가정을 하고 진행하기 때문에 혹여나 루비를 설치하지 않은 분들은 [Gorails](https://gorails.com/setup/osx/10.11-el-capitan)에서 루비를 설치하는 과정을 따라하길 바란다.

나의 작업 환경은 OSX El-capitan, Ruby 2.3.0 다.

우선 github에서 repository를 생성한다. 이때 생성할 이름은 자신의 깃허브 아이디를 포함하여 아래와 같이 생성한다.

`username.github.io`

이렇게 생성한 repository를 clone으로 내려 받는다.

`# git clone git@github.com:userid/userid.github.io.git blog`

나의 경우에는 디렉토리 이름을 **blog**로 지정하였다.

`# cd blog`

해당 디렉토리로 가서  버전 관리를 위하여 .ruby-version에 루비 2.3.0 버전을 명시한다.

`# echo "2.3.0" > .ruby-version`

그리고 Gemfile을 생성하기 위해 vi를 연다.

`# vi Gemfile`

Gemfile 에는 다음과 같은 내용을 작성한다.

```bash
source 'https://rubygems.org'

gem 'github-pages'
```

이제 잼 파일을 설치한다.

`bundle install`

의존성이 있는 라이브러리를 설치하는데 시간이 조금 걸린다. 설치를 했다면 이제 jekyll blog 환경을 초기화 한다.

`# jekyll new . --force'`

명령어를 입력하면 여러 파일이 생길 것이다.

아래와 같이 명령어를 입력하면 github에 push 하기전에 내용을 확인할 수 있다.

`# jekyll serve`

실행이 된다면 내용을 웹  브라우저에서  localhost:4000으로 접속하여 내용을 확인하고, 필요한 파일들을 수정한 뒤 커밋하면 된다.

_config.yml 파일에 대부분의 설정과 명시할 내용들이 들어가므로 관련 내용을 수정하면 되고

_post/ 디렉토리에 있는 마크다운을 추가하고 push 하면 github page에 글이 작성되므로 해당 파일의 포멧을 확인해보는 것이 좋다.

오늘은 여기까지..
