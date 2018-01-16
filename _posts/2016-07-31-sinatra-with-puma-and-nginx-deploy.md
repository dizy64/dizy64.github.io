---
layout: post
title:  "Sinatra 프로젝트 배포하기"
date: 2016-07-31 23:18:35 +0900
categories: 'dev'
tags: [sinatra, deploy, operation]
---

인덱스 페이지 하나만 있는데 Rails로 배포하고 있었던 <a href="http://www.880322.com">880322.com</a>를 이번에 Sinatra로 변경했다.

추가로 이런저런 프로젝트를 작게 해보고 싶은데 너무 큰 프레임워크는 필요없을 것 같아서 변경하고 배포하는데 고생을 많이해서 간단하게 작성해본다.

### Gemfile 생성

```ruby
source 'https://rubygems.org'

gem 'sinatra'
gem 'sass'
gem 'puma'
```

### Sinatra 프로젝트 생성하기.

/static 은 /public 로 변경해줘도 됨. 취향에 따라서. 작업하면 됨

작업한 대로 nginx의 public 폴더 이름도 변경해주면 됨.


```ruby
require 'sinatra'

set :public_folder, File.dirname(__FILE__) + '/static'

configure {
  set :server, :puma
}

get '/' do
  erb :index
end

get '/common.css' do
  scss :common
end
```

이후 작업한 내용은 views/index.erb, views/common.scss 에 필요한 파일을 만들어주면 된다.

### config.ru 파일 만들기

```ruby
require 'sinatra'
set :env, :production
disable :run

require './app.rb'

run Sinatra::Application
```

Puma AppServer 를 실행시킬 때의 설정을 한다.
서버에 맞게 설정해주면 된다.

### config/puma.rb
```ruby
root = "#{ Dir.getwd }"

puma_base_dir = "#{ root }/tmp/puma"
bind "unix://#{ puma_base_dir }/socket"
pidfile "#{ puma_base_dir }/pid"
state_path = "#{ puma_base_dir }/state"
rackup "#{ root }/config.ru"

threads 2, 4
```


### /etc/nginx/nginx.conf 또는 /etc/nginx/sites-avaliable/

```ruby
upstream app_name {
  server unix:///app_dir/tmp/puma/socket;
}

server {
  listen 80;
  server_name 880322.com www.880322.com;

  root /app_dir/static;
  access_log /app_dir/log/nginx.access.log;
  error_log /app_dir/log/nginx.error.log info;

  location / {
    try_files $uri @zero_app;
  }

  location @app_name {
    include proxy_params;

    proxy_pass http://app_name;
  }
}
```


### 서버에서 설정 및 실행할 것들

```bash
bundle install
mkdir -p tmp/puma
mkdir log

# 앱 실행시 명령어
bundle exec puma -e production --config config/puma.rb > dev/null 2& &
```
