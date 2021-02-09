---
layout: post
title: Rails에서 HTTP HEADER에 접근하기
date: 2021-02-09 20:52:00 +0900
meta-image: "https://blog.dizy.dev/images/ruby.png"
categories: 'rails'
---

HTTP의 헤더값은 필요한 경우 통신의 Request Body와 별개로 인증이나 별개의 상태를 전달하기 위해 사용하는 경우가 종종 있다.

최근에 HTTP HEADER를 접근 하려고 했는데 생각대로 접근이 되지 않는 문제가 있었다.

아래와 같이 `request.headers`의 접근자로 접근할 수 있는게 당연한데 접속이 안되는 문제였다.

```ruby
request.headers[:API_AUTH]
```

원인을 확인해보니 주로 사용하는 헤더 키가 아닌 경우에는 헤더에 접근해야 할 경우에는 `HTTP_` 라는 접두어가 붙고, 대문자로 접근해야하며, snake_case로 접근해야했다.

참고 코드: [https://github.com/rails/rails/blob/main/actionpack/lib/action_dispatch/http/headers.rb](https://github.com/rails/rails/blob/main/actionpack/lib/action_dispatch/http/headers.rb)

```ruby
# Converts an HTTP header name to an environment variable name if it is
# not contained within the headers hash.
def env_name(key)
  key = key.to_s
  if HTTP_HEADER.match?(key)
    key = key.upcase
    key.tr!("-", "_")
    key.prepend("HTTP_") unless CGI_VARIABLES.include?(key)
  end

  key
end
```
