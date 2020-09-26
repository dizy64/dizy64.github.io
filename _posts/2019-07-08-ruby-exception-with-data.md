---
layout: post
title: Ruby에서 Exeception 처리시 데이터를 포함하여 처리하기 
date: 2019-07-08 19:00:17 +0900
meta-image: "https://blog.dizy.dev/images/ruby.png"
categories: 'ruby'
permalink: ruby/2019/07/08/ruby-exception-with-data.html
---

보통의 경우 Exeception은 메세지만 함께 보내서 처리합니다.<br/>
하지만 만약 에러 처리시 이외의 데이터를 함께 보내야만 한다면 어떻게 해야할까요?

다음은 예시로 접근을 허용하는 토큰의 권한이 없음을 처리하기 위한 에러입니다.

```ruby
class PermissionDeniedError < StandardError
  attr_reader :token

  def initialize(message = 'Permission Denied!', token = nil)
    @token = token
    super(message)
  end
end
```

이렇게 생성한 에러는 다음과 같이 처리할 수 있습니다.

```ruby
class ApplicationController
  def start_token!
    raise PermissionDeniedError.new('Permission Denied!', current_token) if current_token.expired? || current_token.revoked?

    current_token.start!
  rescue PermissionDeniedError => exception
    @message = exception.message
    @token = exception.token
    @user = @token.user
    # Something do...
  end
end
```

보통은 컨트롤러에서 발생한 예외처리는 rescue_from에서 일괄적으로 300, 400, 500번대의 에러페이지에 메세지와 함께 렌더합니다.<br/>
하지만 예외적으로 서비스 내에서 에러 페이지 내에서 에러를 일으킨 객체를 통해 다이나믹한 페이지를 연출하기 위해 위와 같이 Custom Exeception 객체를 만들어서 예외 처리를 해보았습니다.

## 참고 사이트

1. [How to add context data to exceptions in Ruby](https://www.honeybadger.io/blog/how-to-add-context-data-to-exceptions-in-ruby/)
2. [Passing Data With Ruby Exceptions](https://thejqr.com/2009/02/11/passing-data-with-ruby-exceptions.html)

****2019년 10월 30일 업데이트 함*
