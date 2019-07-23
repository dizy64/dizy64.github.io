---
layout: post
title: ActiveRecord는 어떻게 Database의 컬럼과 매핑할까?
date: 2019-07-23 19:00:17 +0900
meta-image: "https://blog.dizy.dev/images/ruby.png"
categories: 'rails'
---

최근에 질문을 받았다.

> Active Record는 다른 ORM 과 달리 어떻게 알아서 데이터를 매핑하나요?

너무 당연히 쓰고 있어서 대답을 하지 못했다.<br/>
그냥 schema 파일을 알아서 읽어서 하는 게 아닐까?라고 어렴풋이 생각하고 검색해보고 넘어갔기에 설명을 해줄 수 있을 만큼 자세히 알고 있지 못했다.<br/>
그리고 이 글에서도 아주 자세히 쓰진 못할 것 같다.<br/>
어렴풋이 생각한 게 대충 맞았지만 자세히 설명하기 위해서는 많은 부분을 설명해야 하기 때문이다.

ActiveRecord는 어떻게 알아서 DB의 컬럼을 매핑해서 [ActiveRecord 패턴](https://en.wikipedia.org/wiki/Active_record_pattern) 을 만들어줄까?

## Convention over configuration

Ruby on Rails를 접하면 많이 들어 본 문장 Convention over configuration.(줄여서 CoC)<br/>
Rails 프레임워크는 컨벤션(관례)을 통해 암묵적으로 설정을 정의하지 않아도 된다는 특징이 있다.<br/>
이 점이 매핑을 알아서 해주는 맹점이었다.

공식 [Rails Guide](https://guides.rubyonrails.org/active_record_basics.html)를 보면 Model은 단수형, 데이터베이스 컬럼은 복수형 네이밍을 하게끔 되어있고, 관계 테이블의 네이밍 또한 제시해준다.

예를 들면 모델/클래스와 테이블/스키마 간의 컨벤션은 아래와 같다.

| Model / Class  | Table / Schema|
|:---------:|:------------------:|
|   Article  |      articles     |
|  LineItem  |    line_items     |
|    Deer    |       deers       |
|   Mouse    |       mice        |
|   Person   |      people       |

외래키(Foreign key)의 경우에도 단수형 이름으로 생성한다. (예: `user_id`, `order_id)<br/>
주 키(Primary Key) 또한 기본적으로 `id` 를 사용한다.

이외에도 다양한 규칙들이 있는데 [Rails Guide](https://guides.rubyonrails.org/active_record_basics.html)를 참고하면 된다.

만약 이 규칙을 지키지 않을 경우에는 직접 명시해서 사용하는 방법도 있다. `self.table_name`, `self.inheritance_column` 의 값을 변경함으로 테이블 명이나 STI 컬럼을 변경할 수 있다.

## ActiveRecord::Base

Rails에서 모델에 상속받는 `ActiveModel`는 `ActiveRecord::Base`를 상속받는다.

그래서 모든 이유는 여기에 있지 않을까 하여 뜯어보았다.

`ActiveRecord::Base`에서 발견한 [ActiveRecord::Attributes](https://github.com/rails/rails/blob/31105c81cc82ae829c382a4eee2c5aa362882dea/activerecord/lib/active_record/attributes.rb#L11) 모듈에서 의심이 되는 코드를 발견하였다.

```ruby 
class_attribute :attributes_to_define_after_schema_loads, instance_accessor: false, default: {} # :internal:
```

이 코드가 결국 동작하는게 클래스에 Attribute를 세팅해주는 것 같았다.<br/>
확인을 해보기 위해 아래와 같이 콘솔에서 실행했다.

```ruby
Class::class_attribute :test, default: [] # =>  [:test]
Class.test # => []
Class.test = 1 # => 1
Class.test # => 1
```

해당 코드는 아주 단순히 찾았지만 블로그에 포스팅을 하기 위해 조금 더 찾아보니 정말 복잡하게 구현되어 있었다.

## 결론 

컨벤션(불가피 할 경우 명시적인 설정)에 의하여 schema에서 모델 클래스의 DB 이름을 찾아 attribute를 세팅한다.

세팅을 할 때 default 값 등이 있을 경우 이에 대한 내용도 함께 세팅한다.

예를 들면

```ruby
# Schema.rb
create_table "users", force: :cascade do |t|
  t.string "name", null: false
  t.string "nickname", default: '익명유저', null: false
  t.string "email", null: false
end
```

다음과 같은 스키마가 있다면

```ruby
class User < ApplicationRecord
  attribute :name, :string
  attribute :nickname, :string, default: '익명유저'
  attribute :email, :string,
end
```

와 같이 만들어준다고 생각하면 될 듯 하다. (사실은 더욱 복잡하지만..)

내부적으로 호출하는 `ActiveModel::Naming` `ActiveModel::Atribute`, `ActiveRecord::ModelSchema` `ActiveRecord::Attributes`등 각각 기능과 이름이 명확한 모듈들이 나눠서 역할을 분배하고 있었다.

종종 코어 부분을 분석해봐야겠다는 생각이 들었다.

## 느낀 점

루비를 왜 메타 프로그래밍 언어라고 부르는 지 정말 잘 알 수 있었다.<br/>
아직도 자세히 알고 말했다고 할 수 없을 정도로 복잡하고 어렵다.

그리고 너무 돌아가는 코드만 짜기에 급급했던 것은 아니었나 반성해보며 조금 더 코어의 내용을 학습해야겠다는 생각이 들었다.