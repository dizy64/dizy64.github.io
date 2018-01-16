---
layout: post
title:  "레일즈에서 Hash 접근을 심볼과 문자열 동시에 할 수 있게하기"
subtitle: "with_indifferent_access 메서드 이야기."
date: 2017-12-27 23:24:21 +0900
categories: 'dev'
tags: [ruby, ruby on rails]
---

우연히 대표님의 코드를 보고 처음 본 메서드를 찾아보다 발견한 메서드.

ruby에서는 hash의 key는 symbol로 접근한다. `hash[:key]`

하지만 웹의 특성상 문자열 처리를 자주 하는 Rails에서는 `with_indifferent_access` 메서드를 지원한다.

```ruby
  hash = { a: 'test'}.with_indifferent_access
  hash['a']  # => 'test'
  hash[:a]   # => 'test'
```

`with_indifferent_access` 는 정확히는 `ActiveSupport::HashWithIndifferentAccess` 로 연결해준다.

```ruby
rgb = ActiveSupport::HashWithIndifferentAccess.new

rgb[:black] = '#000000'
rgb[:black]  # => '#000000'
rgb['black'] # => '#000000'

rgb['white'] = '#FFFFFF'
rgb[:white]  # => '#FFFFFF'
rgb['white'] # => '#FFFFFF'
```
위와 같이 symbol과 string 어떤 것으로도 접근 할 수 있다.

덕분에 문자열 처리 후 `.to_sym`을 하는 일을 줄일 수 있어서 편한 것 같다. 종종 사용할 듯하다.

똑같은 이유로

`.to_h` 는 `ActiveSupport::HashWithIndifferentAccess` 이고 `.to_hash`는 일반 `hash`로 변환된다.

`.to_h`로 변환한 경우 `hash.symbolize_keys` 를 해주지 않아도 된다.

## 참고

* [APIdock: with_indifferent_access](https://apidock.com/rails/Hash/with_indifferent_access)
* [Api dock: ActiveSupport::HashWithIndifferentAccess](https://apidock.com/rails/ActiveSupport/HashWithIndifferentAccess)
* [RubyOnRails API: .to_h](http://api.rubyonrails.org/v5.0.2/classes/ActionController/Parameters.html#method-i-to_h)
