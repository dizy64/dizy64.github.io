---
layout: post
title: Docker 멀티 스테이지 빌드에 대해서 알아보자
date: 2023-07-15 10:40:00 +0900
categories: 'docker'
---

도커를 통한 서비스를 배포해 본 경험이 있다면 은근히 빌드한 이미지의 용량을 줄이는 것에 대해서 스트레스를 많이 겪었을 것이다.<br/>
예전에는 별도의 빌드용 도커파일과 그 빌드용 도커파일이 만든 이미지를 베이스로 다시 도커파일로 경량화 된 아웃풋을 만들어주는 방법을 많이 사용했었는데 우연히 지인을 통해 도커에 멀티 스테이지 빌드 방식이 있다는 것을 알게 되었다.<br/>
이 방법을 이용하면 굳이 불필요하게 도커 파일을 여러개를 관리 할 필요 없이 의존성 주입 단계와 런타임용 이미지를 만드는 단계를 하나의 도커파일로 관리할 수 있다.

나의 경우 참조해야 하는 파이썬 패키지 중 일부가 GitHub의 Priviate Repo에 있어서 GitHub 민감 정보도 함께 주입을 해야 하는 경우가 있는데, 이럴 때도 멀티 스테이지 빌드를 쓰면 최종 결과물에는 민감 정보가 넘어가지 않아 온전히 빌드 단계에서만 민감 정보를 참조하고 버릴 수 있어서 장점이 있었다.

물론 장점만 있는 것은 아니다. 도커파일이 복잡해진다. 스테이징 별로 `AS`를 이용하여 별명을 지정해야 하고 여러 단계를 거치기 때문에 어느 시점에 `--from=AliasName` 이 붙는지 흐름도 봐야한다. 빌드 시간도 서로 블로킹이 없는 부분까지는 비동기로 진행되지만 빌드 시간이 더 걸릴 수 있다. 

아래 예시는 GitHub 민감 정보를 주입했고, 이를 통해 Pip 파일의 의존성 패키지를 모두 빌드 한 뒤 종료한다.<br/>
이후 runtime 용 도커 파일 라인에서 COPY --from=builder를 통해 빌드 스테이지에 /usr/local 파일을 복제하여 빌드된 결과물을 가져온다.

```docker
# 첫 번째 스테이지: 빌드 환경 구성
FROM python:3.9 AS builder

WORKDIR /app

# Inject GitHub credentials for private repos
ARG GITHUB_USERNAME
ARG GITHUB_PERSONAL_ACCESS_TOKEN
RUN echo "machine github.com\nlogin ${GITHUB_USERNAME}\npassword ${GITHUB_PERSONAL_ACCESS_TOKEN}\n" > ~/.netrc

# Pipenv 설치
RUN pip install pipenv

# Pipfile 복사 후 의존성 설치
COPY Pipfile* /app/
RUN pipenv install --system --deploy --ignore-pipfile

# 두 번째 스테이지: 런타임 환경 구성
FROM python:3.9-slim

WORKDIR /app

# 빌드 환경에서 설치한 의존성 복사
COPY --from=builder /usr/local /usr/local

# 애플리케이션 코드 복사
COPY . /app/

CMD ["python", "manage.py", "runserver"]
```

도커 파일에서 사용하는 이미지를 보면 알겠지만 `python:3.9`이미지를 쓰다가 `python:3.9-slim`을 기준으로 의존성 패키지만 복제해서 최종 결과물을 내놓는다.<br/>
이를 통해 조금 더 경량화 된 이미지를 기반으로 런타임용 이미지를 만들 수 있었다.<br/>
주의 해야 할 점은 RDB 등을 사용하면 DB 클라이언트 라이브러리가 필요할 수 있는데 이 부분은 직접 잘 챙겨봐야 한다.

참조 사이트: [Docker Docs](https://docs.docker.com/build/building/multi-stage/)
