---
layout: post
title: Sidekiq에서 재시도로 쌓인 큐를 일괄 삭제 하는 방법
date: 2020-09-26 20:30:00 +0900
meta-image: "https://blog.dizy.dev/images/ruby.png"
categories: 'rails'
---

자주 발생되어서도 안되고, 자주 발생하지는 않지만 아주 가끔 잡이 대량 실패하는 경우가 발생한다.

예상되는 이슈는 아래와 같다

- Background Job의 스펙이 변경되었는데 트리거 쪽이 호출을 잘못 한 경우
- 인프라나, 외부 서비스의 장애로 잡이 실패한 경우
- 그 외 배포나 운영에서 어플리케이션의 버전 관리를 실패한 경우 (첫번째 조건과 유사함)

실패한 잡은 재시도가 되어 해소되면 되지만 그렇지 않은 경우가 종종 있다. 

- 적시에 동작하지 않으면 의미가 없는 경우
- 지금 실행되었을때 고객에게 불편을 끼칠 수 있는 스케줄 잡
- 잘못 실행된 것이라 재시도를 해도 무의미한 경우

이럴 때 재시도 중인 잡이 너무 많아서 Sidekiq의 모니터링 화면에서 일일히 삭제하기 힘들 수 있는데 이럴 때 삭제하기 위해서는 다음과 같은 시도를 할 수 있다.

### 재시도 전체를 삭제하는 방법

```ruby
rs = Sidekiq::RetrySet.new
rs.size
rs.clear
```

다음과 같이 바로 `clear` 해버리면 된다. 

### 특정 잡만 찾아서 일괄 삭제하는 방법

```ruby
job_name = UserWeeklyReportJob.name
queues = Sidekiq::RetrySet.new

queues.select do |job|
  job.args[0]['job_class'] == job_name
end.each(&:delete)
```

위와 같이 일일히 잡의 클래스명을 비교해서 일괄 삭제하는 방법도 있다.

자주 발생하면 안되는 문제이지만 간혹 발생할 수 있는 문제라 생각하여 포스팅을 해본다.