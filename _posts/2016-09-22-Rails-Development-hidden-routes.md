---
layout: post
title:  "Ruby On Rails 개발환경에서만 볼 수 있는 접속 경로들"
subtitle: "Rails의 정보를 한눈에 볼 수 있는 개발환경의 info pagee들"
date: 2016-09-22 18:09:22 +0900
meta-image: "https://blog.dizy.dev/images/ruby.png"
categories: 'rails'
permalink: dev/2016/09/22/Rails-Development-hidden-routes.html
---

나는 보통 Rails에서 일부러 주소를 오타내서 라우트 정보를 확인하곤 했었는데

이걸 보여주는 주소가 따로 없는건가..? 하는 생각을 하긴 했었다.

하지만 그냥 그게 습관이 되서 한번도 제대로 된 경로를 찾아볼 생각을 안했는데 우연히 일본어로 된 페이지에서 <a href="http://qiita.com/satoruk/items/529c19d5c77e6aa79cb1" target="_blank">관련 글</a>을 찾게 되어 적어본다.


# 히든 주소

* <a href="http://localhost:3000/rails/mailers" target="_blank">http://localhost:3000/rails/mailers</a>
* <a href="http://localhost:3000/rails/info/properties" target="_blank">http://localhost:3000/rails/info/properties</a>
* <a href="http://localhost:3000/rails/info/routes" target="_blank">http://localhost:3000/rails/info/routes</a>

관련 내용은 <a href="https://github.com/rails/rails/blob/d6dec7fcb6b8fddf8c170182d4fe64ecfc7b2261/railties/lib/rails/application/finisher.rb#L22-L33" target="_blank">github 소스</a>를 참고하면 좋을 듯 하다.

# 미리보기

## http://localhost:3000/rails/info/properties

<img src="{{ site.url }}/images/rails_routes_properties.png">

레일즈 버전이나 관련 정보들을 볼 수 있다.

## http://localhost:3000/rails/info/routes

<img src="{{ site.url }}/images/rails_routes_routes.png">

흔히 개발중에 오타를 내면 나오던 페이지가 나온다.

레일즈 4.1버전 이후부터 5.0 까지 다 정상적으로 잘 나오는 것으로 확인했다.
