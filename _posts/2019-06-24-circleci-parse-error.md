---
layout: post
title: CircleCI에서 Rspec 테스트 결과를 파싱하지 못할 때
date: 2019-06-24 22:11:07 +0900
categories: 'rails'
---

개인 프로젝트를 할때 항상 CircleCI의 도움을 한다.<br/>
그런데 결과에 Test Summary를 보니 아래와 같은 메세지가 발생하였다.

> The following errors were encountered parsing test results:<br/>
> rspec/results.xmlParseError at [row,col]:[1,1] Message: Content is not allowed in prolog.

처음에는 저장 경로가 없는가 하고 ssh에 접속하는 옵션으로 테스트 해봤는데 경로에는 문제가 없었다.<br/>
이렇게 저렇게 구글링 하다가 의심이 된 것은 다른 분들이 설정한 Workflow 설정에는 `--format RspecJunitFormatter` 라는 옵션이 있었다.

그렇게 찾아낸 결과 [rspec_junit_formatter](https://github.com/sj26/rspec_junit_formatter) 잼을 이용해서 해당 포멧으로 결과를 저장해야 됨을 알게 되었다.<br/>
rspec_junit_formatter는 RSpec의 결과를 Jenkins, CircleCI와 같은 CI가 읽을 수 있는 포멧을 지원하는 잼이라고 한다.

다음과 같이 파일에 추가하면 CircleCI에서 읽을 수 있다.

### Gemfile

```
gem 'rspec_junit_formatter'
```

### .circleci/config.yml

```
bundle exec rspec \
              --format progress \
              --format RspecJunitFormatter \
              --out /tmp/test-results/rspec/results.xml \
              $TEST_FILES
```