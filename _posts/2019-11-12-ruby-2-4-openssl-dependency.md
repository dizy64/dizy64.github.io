---
layout: post
title: Ruby 2.4 미만 버전 설치시 openssl 의존성 문제 발생시 
date: 2019-11-12 23:31:18 +0900
meta-image: "https://blog.dizy.dev/images/ruby.png"
categories: 'rails'
---

> The Ruby openssl extension was not compiled.<br/>
> ERROR: Ruby install aborted due to missing extensions

위와 같은 에러 발생시 homebrew에서 설치한 최신 버전의 openssl 경로를 Ruby 옵션에 명시해주면 해결된다.

우선 최신 openssl이 설치가 안된 경우 `brew install openssl` 해당 명령어를 통해 openssl를 설치하고 아래와 같이 명시하면 된다.

`RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/opt/openssl"`

주요 ruby vm 설치시 아래와 같이 환경변수를 함께 전달하면 해결!

```shell
# For asdf 
RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/opt/openssl" asdf ruby install 2.3.3
# For RBENV
RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/opt/openssl" rbenv install 2.3.3
# For RVM
RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/opt/openssl" rvm install 2.3.3
```

* 출처
    * <a href="https://github.com/rbenv/ruby-build/issues/1353" target="_blank" rel="noopener">Cannot install Ruby versions < 2.4 because of openssl@1.1 dependency</a>