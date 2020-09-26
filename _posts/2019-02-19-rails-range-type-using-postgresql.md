---
layout: post
title: ActiveRecord에서 Postgresql의 RangeType 사용 후기
date: 2019-02-19 22:40:15 +0900
meta-image: "https://blog.dizy.dev/images/ruby.png"
categories: 'dev'
---

회사에서 개발자 채용 서비스를 개발 중에 잡 포지션에 게시될 채용할 개발자의 경력(N년차) 설정과 관련된 데이터 타입을 이용할
때 Postgresql의 <a href="https://www.postgresql.org/docs/current/rangetypes.html" target='_blank'>**int4range**</a>를
사용해보기로 했습니다.

이유는 단순히 컬럼을 여러 개 만들기 싫어서였는데 결과적으로 말씀드리자면 Range를 띄엄띄엄 알고 있던 저희에게는 불편한
점이 투성이었습니다.

Range 절에 질의를 하는 쿼리문을 작성하는 것도 조금 불편했기도 했고 경력 범위라는 게 Range Object 개념과는 미묘하게 다른
부분이 있었기 때문입니다.

다시 RangeType에 대해서 소개하자면
<a href="https://edgeguides.rubyonrails.org/active_record_postgresql.html#range-types" target="_blank">Ruby on Rails
Edge Guide</a>에서 안내되고 있듯이 Ruby의 <a href="http://ruby-doc.org/core-2.5.3/Range.html" target="_blank">Range</a>
Object와 매핑됩니다.

해당 가이드에 예시를 보겠습니다.

```ruby
# Usage
Event.create(duration: Date.new(2014, 2, 11)..Date.new(2014, 2, 12))
 
event = Event.first
event.duration # => Tue, 11 Feb 2014...Thu, 13 Feb 2014
 
## All Events on a given date
Event.where("duration @> ?::date", Date.new(2014, 2, 12))
 
## Working with range bounds
event = Event.
  select("lower(duration) AS starts_at").
  select("upper(duration) AS ends_at").first
 
event.starts_at # => Tue, 11 Feb 2014
event.ends_at # => Thu, 13 Feb 2014
```

저희에게 기본적으로 혼란을 줬던 부분이 저장된 데이터였습니다. 예제 코드를 보면 duration을 `Date.new(2014, 2,
    11)..Date.new(2014, 2, 12)`로 설정하지만 DB에 저장될 때는 ``Tue, 11 Feb 2014...Thu, 13 Feb 2014`` 로 저장이
됩니다.<br/>
즉 생각한 것보다 하루 더 저장이 되었는데요. 동일하게 저희 회사 코드에서 `(1..3)`차로 저장을 했는데 `(1...4)`로 저장이
되는 문제가 있었습니다.

흔히 루비에서 Range를 쓸 때는 `(1..5)`와 같은 코드를 사용하는데요. Range Object에서 Doble Dot(..) 이외에도 Triple Dot
(...)이 존재합니다. Triple Dot의 경우 Max Range의 자신을 포함하지 않습니다. 아래와 같습니다.

```ruby
(1..5).to_a #=> [1, 2, 3, 4, 5]
(1...6).to_a #=> [1, 2, 3, 4, 5]
```

Rails에서 **int4range** 타입이 Tripedot의 형태로 DB에 저장을 하고 데이터를 불러오기 때문에<br/>
개발 의도는 1년 차에서 3년 차의 데이터를 (1..3)으로 저장해주길 기대했지만, 실제로는 (1..4)로 저장이 되었고 화면 표현에서
기대한 년차보다 1년 차 더 많이 노출 되는 버그가 발생하게 된 것입니다.

문제는 이런 차이가 있다는 걸 알고 있는 개발한 코드와 그렇지 않은 상태에서 개발된 코드가 서로 문제를 일으켰습니다.<br/>
아무래도 협업을 하거나 컨텍스트 체인지가 일어나다 보면 충분히 일어날 수 있는 문제라고 생각합니다.

저희 회사는 나름 테스트 커버리지를 높이고 있고 테스트 코드를 꼼꼼히 짠다고 생각했었지만 아무래도 새로운 타입이 막연히
제대로 잘 저장이 되겠지 하고 놓쳤던 부분에서 문제가 발생하게 된 것입니다.

마침 <a href="https://stdout.fm/" target="_blank">stdout.fm 팟캐스트 방송</a>에서 Ruby 2.6의 새로운 점에 대해서
이야기하는 걸 들은 기억이 나서 금방 눈치채고 해결할 수 있었습니다.

## 교훈

- 익숙하지 않은 것을 사용할 때는 매뉴얼을 정독하자.
- Range Type을 쓰고 싶을 땐 정말 기간을 판단하는 코드에서 쓰자.
- 테스트 코드를 잘 작성하자.
- ~~역시 많이 보고 듣다보면 뭐라도 얻어걸린다.~~
