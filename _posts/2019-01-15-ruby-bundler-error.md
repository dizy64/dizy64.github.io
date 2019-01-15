---
layout: post
title:  "can't find gem bundler (>= 0.a) with executable bundle (Gem::GemNotFoundException) 에러 발생시 처리 방법"
date: 2019-01-15 22:38:40 +0900
categories: 'dev'
tags: [ruby, error]
---

새로 루비를 설치하고 `gem install bundler`로 번들러를 설치하면 2.0 버전으로 설치가 된다.

기존의 프로젝트들은 대부분 bundler 버전이 1.16 버전대였기 때문에 해당 프로젝트에서 `bundle install`을 하게 되면 이런 오류가 난 것으로 판단된다.

해당 프로젝트의 Gemfile.lock 의 bundler 버전을 확인 한 후 명시적으로 bundler 를 설치한 뒤 `bundle install`를 입력하면
문제가 해결된다.

`gem install bundler -v 1.16.1` 

이렇게 해서 해결했다.
