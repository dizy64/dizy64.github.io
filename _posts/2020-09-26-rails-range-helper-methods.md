---
layout: post
title: Rails의 시간 범위 메서드들
date: 2020-09-26 16:44:24 +0900
meta-image: "https://blog.dizy.dev/images/ruby.png"
categories: 'Rails'
---

ActiveRecord의 ORM을 이용하여 기간에 대한 쿼리를 사용하는 경우가 종종 있다.

```ruby
range = Time.current.beginning_of_day..Time.current.end_of_day
Post.where(created_at: range)
```

ActiveSupport에 시간 범위를 처리해주는 헬퍼 메서드를 이용하면 조금 더 쉽게 이를 해결 할 수 있다.

## all_day() <a href="https://api.rubyonrails.org/classes/DateAndTime/Calculations.html#method-i-all_day)" rel="noreferrer" target="_blank">(Doc)</a>

```ruby
Time.current.all_day
# => Sat, 26 Sep 2020 00:00:00 KST +09:00..Sat, 26 Sep 2020 23:59:59 KST +09:00
```

## all_week(start_day = Date.beginning_of_week) <a href="https://api.rubyonrails.org/classes/DateAndTime/Calculations.html#method-i-all_week)" rel="noreferrer" target="_blank">(Doc)</a>

한 주간의 기간을 Range 로 반환한다.
해당하는 주의 첫날을 월요일로 할지 일요일로 할지도 전달인자를 통해 설정 할 수 있다. 예: all_week(:sunday)

```ruby
1.week.ago.all_week
# => Mon, 14 Sep 2020 00:00:00 KST +09:00..Sun, 20 Sep 2020 23:59:59 KST +09:00

1.week.ago.all_week(:sunday)
# => Sun, 13 Sep 2020 00:00:00 KST +09:00..Sat, 19 Sep 2020 23:59:59 KST +09:00
```

## all_month() <a href="https://api.rubyonrails.org/classes/DateAndTime/Calculations.html#method-i-all_month" rel="noreferrer" target="_blank">(Doc)</a>

해당하는 달의 한달간의 기간을 반환한다. (9월일 경우 9월 1일부터 9월 30일까지)
참고로 2월이 윤년이라 29일인 해는 그것도 계산하여 반환하다.

```ruby
Time.current.all_month

# => Tue, 01 Sep 2020 00:00:00 KST +09:00..Wed, 30 Sep 2020 23:59:59 KST +09:00
```

## all_year() <a href="https://api.rubyonrails.org/classes/DateAndTime/Calculations.html#method-i-all_year" rel="noreferrer" target="_blank">(Doc)</a>

해당하는 한 해의 기간을 반환한다. (1월 1일 00시부터 12월 31일 오후 11시 59분까지)

```ruby
1.year.ago.all_year 
# => Tue, 01 Jan 2019 00:00:00 KST +09:00..Tue, 31 Dec 2019 23:59:59 KST +09:00
```

## all_quarter() <a href="https://api.rubyonrails.org/classes/DateAndTime/Calculations.html#method-i-all_quarter" rel="noreferrer" target="_blank">(Doc)</a>

해당하는 분기를 반환한다. 1~3월, 4~6월, 7~9월, 10월~ 12월의 분기에 대한 기간이 반환된다.

```ruby
3.month.ago.all_quarter
# => Wed, 01 Apr 2020 00:00:00 KST +09:00..Tue, 30 Jun 2020 23:59:59 KST +09:00
```


이외에도 날짜, 시간과 관련된 헬퍼 메서드들이 많으니 참고하면 좋다.