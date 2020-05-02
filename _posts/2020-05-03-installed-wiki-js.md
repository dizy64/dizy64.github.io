---
layout: post
title: Wiki.js 설치하기 
date: 2020-05-03 1:00:00 +0900
categories: 'tools'
---

최근 블로그에 글을 쓰지 않는 문제점에 대해서 고민하다 대안으로 위키를 써보는건 어떨까? 하는 생각을 하고 있던 차에 wiki.js 프로젝트를 추천받았다.<br/>
"블로그도 열심히 하지 않는데 위키가 왠말이냐?"라고 생각할 수 있지만 블로그의 글을 시작하여 마무리해야한다는 부담이 있는 반면 위키의 경우 꾸준히 추가하면서 글을 완성시켜 나가도 된다는 장점이 있다.

Wiki 솔루션을 찾아보다가 우연히 [wiki.js](https://wiki.js.org/) 라는 프로젝트를 확인하게 되어 설치를 진행하였다.<br/>
wiki.js는 오픈소스이며, 설치가 쉽고 확장성이 높다고 본인들은 설명하고 있으며 실제로 사용해 본 경험으로 확실히 확장성 있는 플랫폼은 맞다.<br/>
하지만 이쁜 인터페이스인지는 잘 모르겠다.

# 설치 과정

설치는 Dcoker-Compose 를 통해서 했고, 참고한 페이지는 [공식 문서](https://docs.requarks.io/install/docker)를 참고하였다.

도커는 제공된 파일을 임의로 볼륨, 연결할 포트 등만 일부 수정하여 진행하였고 자세하게 안내하는 것은 서버에 보안상 문제가 있을 것 같아 기존 코드에 포트만 수정하여 작성했다.

## Docker Compose를 이용하여 환경 조성하기

```docker
version: "3"
services:
  db:
    image: postgres:11-alpine
    environment:
      POSTGRES_DB: wiki
      POSTGRES_PASSWORD: wikijsrocks
      POSTGRES_USER: wikijs
    logging:
      driver: "none"
    restart: unless-stopped
    volumes:
      - db-data:/var/lib/postgresql/data

  wiki:
    image: requarks/wiki:2
    depends_on:
      - db
    environment:
      DB_TYPE: postgres
      DB_HOST: db
      DB_PORT: 5432
      DB_USER: wikijs
      DB_PASS: wikijsrocks
      DB_NAME: wiki
    restart: unless-stopped
    ports:
      - "5678:3000"

volumes:
  db-data:
```

작성 후 `docker-compose up -d` 커맨드라인을 실행하면 된다.

## Nginx Proxy 처리

http용 80번 포트는 다른 용도로 사용하고 있기 때문에 nginx 에서 한번 프록시 하도록 처리하였다.

아래와 같이 내부적으로 5678 포트를 프록시하게 하여 80포트의 도메인과 연결하도록 하였다.

```
upstream wiki_app {
  server 127.0.0.1:5678;
}

server {
  listen 443 ssl http2 default;
  listen [::]:443 ssl http2 default;
  
  location / {
    try_files $uri @wiki_app;
  }

  location @wiki_app {
    include proxy_params;

    proxy_pass http://wiki_app;
  }
}
```

# 설치 후기

Docker (혹은 Docker Compose)로 띄울 수 있는 앱들이 늘어나고 있는 추세인데 확실히 설치가 편하다.
다만 걱정되는 것은 공통된 자원 (DB)은 빼내는게 더 인스턴스 효율을 적게 먹지 않을까 생각도 드는데, Docker-Compose 간의 네트워크 구성이 다소 복잡해지겠다는 생각이 들었다.

# wiki.js 사용 후기

사용해보니 생각보다 좋은지는 모르겠다. 특히 이쁘지도 않고, 내가 메뉴얼 정독을 못한 것도 있겠지만 트리 구조가 원하는대로 직관적으로 나오지 않는 경험을 했다.

![]({{ "/images/wiki-search.png" | absolute_url }})

![]({{ "/images/wiki-backup.png" | absolute_url }})

백업, 분석, 검색 기능의 경우 다양한 선택 폭을 가지고 있어서 좋았다. 백업의 경우 AWS S3, Git, SFTP 등의 옵션이 있었고, 검색도 DB 뿐만 아니라 검색 엔진을 통한 검색 등도 지원하고 있다.

![]({{ "/images/wiki-analytics.png" | absolute_url }})

분석 툴도 Google Analytics 는 물론이며 Hotjar, Newrelic 등 무료, 상용 분석툴을 간단하게 붙일 수 있는 점은 좋았다.



# 끝으로

설치한 URL은 [https://wiki.dizy.dev](https://wiki.dizy.dev) 이다.<br/>
글 정리를 위키에서 하고 그 글을 제대로 마무리하게 되면 블로그에 작성하는 식으로 생각하고 있다.<br/>
검색 된 글에 중복된 내용이 포함되는 문제는 생기겠지만 이렇게 정리하는 것이 나에게 좋을 것 같단 생각이 들었다.<br/>
지금 사용하고 있는 개인적인 노트 툴도 있어서 사실 이걸 잘 지킬 수 있을지는 모르겠지만, 민감 정보가 없는 데이터들은 웹에 많이 작성하는 습관을 들였으면 하는 마음에 진행해보려고 한다.<br/>