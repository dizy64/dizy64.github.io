---
layout: post
title: Ruby on Rails 4의 before_validate 처리시 주의 할 점
date: 2021-04-20 00:00:00 +0900
meta-image: "https://blog.dizy.dev/images/ruby.png"
categories: 'rails'
---

최근에 겪은 이슈를 정리한다.<br/>
Rails 4에서 발생하는 이슈라 대부분의 신규 프로젝트의 경우에는 전혀 문제가 되지 않는다.<br/>
다만, 레거시를 운용해야 하는 프로젝트에서 발생할 수 있는데 최근에 겪어서 공유하게 된다.

예시 코드로 다음과 같은 callback 처리를 했는데 평소에 발생하지 않던 `ActiveRecord::RecordInvalid` 가 발생되면서 레코드를 저장하지 못하는 이슈가 발생하였다.

```ruby
before_validate :default_value

def default_value
  default_value = DEFAULT_VALUE
  
  bool_type_attributes = false if condition  
end
```

`if condition` 의 `condition`이 `true` 경우 `bool_type_attributes` 값에 `false`를 할당하게  되는데 할당과 동시에 루비의 마지막 절에 해당하기 때문에 암묵적으로 `false` 값을 리턴하게 된다.<br/>
문제는 Ruby on Rails 4의 Callback에서는 콜백의 마지막이 `false`로 리턴할 경우 콜백을 중단하고 `ActiveRecord::RecordInvalid` 를 내뱉게 되는데 이 문제를 겪게 된 것이다.<br/>
Ruby on Rails 5 부터는 명시적으로 `throw :abort` 를 던져야 중단이 되도록 수정되었다. [참조](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#halting-callback-chains-via-throw-abort)

이 문제를 해결하기 위해서는 낮은 버전의 Ruby on Rails 4를 Ruby on Rails 5 이상으로 업데이트하는게 제일 좋고, 그렇지 않다면 마지막 절에 false가 오지 않도록 조심해야 한다.


```ruby
before_validate :default_value

def default_value
  default_value = DEFAULT_VALUE  
  bool_type_attributes = false if condition  

  true # 명시적으로 항상 true를 선언하여 방어하는 방법
end
```

우선 위의 코드와 같이 묵시적으로 false가 리턴 될 수 있는 코드가 있을 때 명시적으로 true를 리턴하는 방법이 있다. 불필요한 코드가 들어가는 것이 찝찝함이 있다.

```ruby
before_validate :default_value

def default_value
  bool_type_attributes = false if condition # false가 할당 될 수 있는 절을 상위로 올리는 방법
  default_value = DEFAULT_VALUE  
end
```

위의 코드와 같이 순서를 조절하여 마지막 절이 boolean 값이 오지 않도록 막는 방법도 있다.<br/>
단, 누군가 코드 순서를 바꾸면 문제가 발생할 수 있기 때문에 명시를 잘 해주는 것이 좋을 것 같다. (근데 한편으론 누가 순서를 바꿀까? 싶긴 하다.)

# 결론

Ruby on Rails 4에서는 before_validate 에서 콜백의 라이프사이클을 중단하고 싶은 경우 명시적으로 false를 리턴하는 방법을 사용하고 있고, 이는 원하지 않는 상황에서 동작할 수 있기 때문에 주의가 필요하다.<br/>
Ruby on Rails 5 에서는 명시적인 방법을 사용하게 되는데, 그렇기 때문에 Rails 4에서 Rails 5 이상으로 업데이트 할 때, 의도적으로 콜백을 중단하는 코드가 있다면 수정해줘야 할 필요가 있을 수 있다.

# 진짜 결론

메뉴얼을 잘 숙지하자.

# 참고 문서

[Active Record Callbacks (Rails 4.2.11)](https://api.rubyonrails.org/v4.2.11/classes/ActiveRecord/Callbacks.html)