---
layout: post
title:  "OS X에서 Ruby on Rails 개발 환경 세팅하기"
subtitle: "이거슨 내가 필요해서 작성하는 세팅"
date: 2016-09-19 14:06:22 +0900
meta-image: "https://blog.dizy.dev/images/ruby.png"
categories: 'dev'
tags: [development environment, ruby, ruby on rails]
---

사실 맥에 기본적으로 루비가 설치되어있긴 한데 시스템 루비 사용을 권장하지 않는다. <a href="https://robots.thoughtbot.com/psa-do-not-use-system-ruby" target="_blank">PSA: Do not use system Ruby</a> 참고

그러므로 루비를 설치하기 위해 brew를 설치한다.

brew 설치 관련 내용은 <a href="http://dizy64.github.io/dev/2016/06/30/setting-up-the-development-environment-for-mac.html">맥 개발 환경 설정하기</a> 글을 참고한다.

## rbenv 설치

요즘 다양한 언어에서 개발 환경을 위해 버전을 관리해주는 버전 관리를 해주는 툴들이 많은데 루비에서는 RVM과 RBENV가 있다고 한다.

각각의 차이는... 들었는데 잘 기억은 안난다;

rvm이 환경 변수를 많이 변형하다보니 자주 꼬이는 경우가 많고 무겁다고 들었다.

나는 Rbenv 를 설치할 것이다.

```shell
brew install rbenv ruby-build

echo 'if which rbenv > /dev/null; then eval "$(rbenv init - )"; fi' >> ~/.zshrc
source ~/.zshrc
```

## Ruby 설치

루비는 우선 최신 버전으로 설치한다.

```shell
# rbenv를 통해 2.3.1 을 설치
rbenv install 2.3.1
# 전역에서 ruby 2.3.1을 사용하겠다고 선언.
rbenv global 2.3.1
ruby -v

> ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-darwin15]
```

루비 버전이 2.3.1로 정상적으로 나오면 끝.

프로젝트 별로 다른 버전을 쓰고 싶다면 rbenv install [version] 으로 설치 후 해당 프로젝트에서 `echo 'version' > .ruby-version` 해주면 된다.


## Rails 설치

```shell
gem install rails -v 4.2.6
```

끝.
