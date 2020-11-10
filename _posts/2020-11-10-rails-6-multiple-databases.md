---
layout: post
title: Rails 6 Multiple Databases 기능 적용하기
date: 2020-11-10 22:25:00 +0900
meta-image: "https://blog.dizy.dev/images/ruby.png"
categories: 'rails'
---

최근에 회사의 신규 프로젝트를 Rails 6를 업데이트했다.

업데이트를 한 이유 중에는 DB 부하를 줄이기 위한 이유가 있었는데 기존의 Rails에서 Read / Write 데이터베이스를 분산하기 위해서는 별도의 Gem을 사용해야 했고 실제로 레거시 프로젝트에서는 Gem을 사용하여 처리하고 있다.

대표적인 Gem으로는 [Octopus](https://github.com/thiagopradi/octopus)가 있는데 드디어 Rails 6에서도 Multiple Databases 기능을 공식지원한다고 한다.<br/>
기왕이면 공식으로 지원하는 방법을 사용하고 싶어서 Rails 6으로 업그레이드를 했고 업그레이드를 했으니 바로 적용해보았다.

우선 우리 서비스는 명함 관리 서비스를 근간으로 다양한 서비스를 제공하고 있기 때문에 DB Read/Write 자체가 빈번하게 일어난다.<br/>
이를 조금이라도 개선하기 위해서 DB를 분산으로 사용하는 것이 권장되고 있고 오로라 데이터베이스에서 Primary DB와 Replica DB를 적절히 섞어서 쓰도록 애플래케이션을 개발하고 있고 최근에 맡아서 개발하고 있는 인재검색 서비스에도 동일하게 분산 처리를 적용하였다.


## 설정 방법

우선 `config/database.yml` 파일에 아래와 같이 선언하면 세팅은 되었다고 보면 된다.

```yaml
test:
  primary:
    database: my_primary_database
    user: root
    adapter: mysql
  primary_replica:
    database: my_primary_database
    user: root_readonly
    adapter: mysql
    replica: true
development:
  primary:
    database: my_primary_database
    user: root
    adapter: mysql
  primary_replica:
    database: my_primary_database
    user: root_readonly
    adapter: mysql
    replica: true
production:
  primary:
    database: my_primary_database
    user: root
    adapter: mysql
  primary_replica:
    database: my_primary_database
    user: root_readonly
    adapter: mysql
    replica: true
```

**환경별로 동일하게 세팅해주면 된다**

테스트/개발 환경들도 모두 동일한 DB를 바라보게 하고 동일하게 한 쌍씩 맞춰주었다.<br/>
이유는 전체 로직에서 DB를 선택하는 등의 로직이 들어가기 때문에 동작이 잘못될 수 있고 환경별로 설정을 해주는 것보다는 동일하게 맞춰주는 편이 용이하다고 판단하였다.


그 다음 *app/models/application_record.rb* 파일에 다음과 같이 쓰기와 읽기에서 어떤 디비를 사용할지 명시하면 기본적인 설정은 끝이 난다.


```ruby
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
 
  connects_to database: { writing: :primary, reading: :primary_replica }
end
```

용도 별로 DB를 분산하거나 하는 다양한 케이스는 [레일즈 공식 가이드 문서](https://guides.rubyonrails.org/active_record_multiple_databases.html)를 참고하면 된다. 

## 자동으로 연결 전환하도록 활성화 하기

*config/application.rb* 파일에 주석 처리가 된 아래 내용을 해제하면 자동으로 DB의 읽기 쓰기를 판단하여 전환해준다.

```ruby
config.active_record.database_selector = { delay: 2.seconds }
config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session
```

판단 기준은 우리가 흔히 쓰기/수정/삭제 가 일어난다고 판단하는 POST, PUT, PATCH, DELETE 메서드의 API에 호출 될 경우 Primary DB를 접근하며, GET, HEAD의 경우 복제본에서 읽어오도록 설정할 수 있다.<br/>
쓰기 직후에 딜레이 옵션을 통해서 쓰기가 일어난 다음 발생한 GET / HEAD의 경우 직전의 연결을 유지하기 때문에 Replica Lag 도 피할 수 있다.

## 적용 후 주의 해야 할 점

이렇게 편리하게 자동으로 적용해주어서 대부분 편하게 사용하였지만 직접 설정해주어야 하는 부분도 있었다.

### 1. GET 메서드의 API 일 경우라도 쓰기가 발생하는 경우

예를 들면 읽는 즉시 카운터를 차감해야하는 쿼리가 발생해야 할 수 있다.<br/>
이럴 때 자동 연결 전환 설정을 해두고 그냥 사용 할 경우에는 `ActiveRecord::ReadOnlyError`가 발생한다.<br/>
이를 해결 하기 위해서는 명시적으로 Primary DB를 연결하도록 명시해주면 해결할 수 있다.

```ruby

# GET posts/:id
def show
  ActiveRecord::Base.connected_to(role: :writing) do
    @post = Post.find(params[:id])
    @post.increment!
  end
end
```

### 2. ApplicationJob에서 돌아가는 작업은 모두 Primary DB로 연결됨

마이그레이션을 위한 잡들이나 데이터 보정이 필요한 경우들은 당연히 Primary DB를 잡아야하고, 이를 코드 구문을 보고 판단할 수 없기 때문에 기본적으로 Primary DB로 잡히는 것 같다.<br/>

하지만 단순히 대상을 추려 푸시나 이메일 등의 Notify 용도의 잡들의 경우 Replica DB를 읽는 편이 좋다. 특히 복잡한 조건으로 대상을 추리는 경우 기왕이면 부하를 줄이는 것이 좋기 때문에 확인을 해보고 명시적으로 연결을 읽기 DB로 수정해주는 편이 좋다.

```ruby
ActiveRecord::Base.connected_to(role: :reading) do
  # something
end
```

## 결론

Rails 6에는 멀티 데이터베이스 기능이 추가가 되었고, 이를 사용하는 방법에 대해서 알아보았다.<br/>
아직 샤딩이나 서로 다른 데이터베이스간의 결합 처리는 부족한 것으로 알려져있다.

다만 곧 릴리즈 될 Rails 6.1에서는 멀티 데이터베이스 기능에 대한 기능 향상과 샤딩 기능이 포함되어 있다고 하니 기대가 된다.

손쉽게 DB를 분산 할 수 있는 방법이 있어서 한결 개발하기 좋아졌다. 하지만 국내에 레일즈 개발자가 많이 없는 것이 너무 아쉽다.