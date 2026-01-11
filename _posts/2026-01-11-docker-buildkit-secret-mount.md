---
layout: post
title: BuildKit Secret Mount로 Docker 빌드 보안 강화하기
date: 2026-01-11 10:00:00 +0900
categories: 'docker'
---

이전에 [Docker 멀티 스테이지 빌드에 대해서 알아보자](/docker/2023/07/15/docker-multi-stage-build.html)라는 글에서 멀티 스테이지 빌드를 활용해 민감 정보를 최종 이미지에서 제거하는 방법을 다뤘었다.

하지만 기존 방식에는 한 가지 문제가 있었다.

## 기존 방식의 문제점

이전 글에서 사용했던 방식을 다시 보자.

```docker
ARG GITHUB_USERNAME
ARG GITHUB_PERSONAL_ACCESS_TOKEN
RUN echo "machine github.com\nlogin ${GITHUB_USERNAME}\npassword ${GITHUB_PERSONAL_ACCESS_TOKEN}\n" > ~/.netrc
```

이 방식은 멀티 스테이지 빌드 덕분에 **최종 이미지**에는 민감 정보가 포함되지 않는다. 하지만 문제는 **빌드 레이어 캐시**에 민감 정보가 남을 수 있다는 점이다.

Docker는 각 명령어를 레이어로 저장하는데, `ARG`와 `RUN` 명령어가 실행된 레이어에 토큰 정보가 그대로 남게 된다. `docker history` 명령어로 확인하면 해당 값이 노출될 수 있다.

## BuildKit의 --mount=type=secret

Docker BuildKit은 이 문제를 해결하기 위해 `--mount=type=secret` 기능을 제공한다. 이 방식은 시크릿을 빌드 시점에 임시로 마운트하고, **빌드가 끝나면 레이어에 전혀 남지 않는다**.

### 개선된 Dockerfile

```docker
# syntax=docker/dockerfile:1
# 첫 번째 스테이지: 빌드 환경 구성
FROM python:3.9 AS builder

WORKDIR /app

# Secret mount를 사용하여 .netrc 파일 생성 및 의존성 설치
# --mount=type=secret으로 마운트된 파일은 레이어에 남지 않음
RUN --mount=type=secret,id=netrc,target=/root/.netrc \
    pip install pipenv

COPY Pipfile* /app/
RUN --mount=type=secret,id=netrc,target=/root/.netrc \
    pipenv install --system --deploy --ignore-pipfile

# 두 번째 스테이지: 런타임 환경 구성
FROM python:3.9-slim

WORKDIR /app

# 빌드 환경에서 설치한 의존성 복사
COPY --from=builder /usr/local /usr/local

# 애플리케이션 코드 복사
COPY . /app/

CMD ["python", "manage.py", "runserver"]
```

### 빌드 명령어

시크릿 파일을 생성하고 빌드 시 전달한다.

```bash
# .netrc 파일 생성
echo "machine github.com
login ${GITHUB_USERNAME}
password ${GITHUB_PERSONAL_ACCESS_TOKEN}" > .netrc

# BuildKit 활성화 후 빌드
DOCKER_BUILDKIT=1 docker build \
  --secret id=netrc,src=.netrc \
  -t myapp:latest .

# 빌드 후 로컬 .netrc 파일 삭제
rm .netrc
```

## 기존 방식 vs BuildKit Secret Mount

| 구분 | 기존 ARG 방식 | BuildKit Secret Mount |
|------|--------------|----------------------|
| 최종 이미지 | 민감 정보 없음 | 민감 정보 없음 |
| 빌드 레이어 캐시 | **민감 정보 남음** | 민감 정보 없음 |
| docker history | 토큰 노출 가능 | 노출 없음 |
| 설정 복잡도 | 낮음 | 약간 높음 |

## Docker Compose에서 사용하기

Docker Compose v2에서도 build secrets를 지원한다. `docker-compose.yml`에서 다음과 같이 설정할 수 있다.

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      secrets:
        - netrc

secrets:
  netrc:
    file: .netrc
```

빌드 시 Compose가 자동으로 시크릿을 전달한다.

```bash
# .netrc 파일 생성
echo "machine github.com
login ${GITHUB_USERNAME}
password ${GITHUB_PERSONAL_ACCESS_TOKEN}" > .netrc

# Docker Compose로 빌드
docker compose build

# 빌드 후 .netrc 삭제
rm .netrc
```

### 환경 변수로 시크릿 전달하기

파일 대신 환경 변수에서 직접 시크릿을 가져올 수도 있다.

```yaml
secrets:
  netrc:
    environment: NETRC_CONTENT
```

이 방식은 CI/CD 환경에서 파일을 생성하지 않고 바로 환경 변수로 전달할 때 유용하다.

## 실제 적용 후기

기존 ARG 방식을 사용하면서 "최종 이미지에는 안 남는다지만, 빌드 캐시에는 남아있지 않을까?" 하는 찜찜함이 있었다. 실제로 확인해보니 그 우려가 맞았고, `--mount=type=secret` 옵션을 통해 이 문제를 깔끔하게 해결할 수 있었다.

설정이 조금 더 복잡해지긴 하지만, 보안 측면에서 확실히 안심이 되는 방식이다.

## 마무리

보안은 "최종 결과물만 안전하면 된다"가 아니라 **전체 과정이 안전해야 한다**. BuildKit의 secret mount는 빌드 과정에서도 민감 정보가 노출되지 않도록 보장해준다.

참조 사이트:
- [Docker BuildKit Secret Mount](https://docs.docker.com/build/building/secrets/)
- [Dockerfile frontend syntaxes](https://docs.docker.com/build/dockerfile/frontend/)
- [Docker Compose Build Secrets](https://docs.docker.com/compose/how-tos/use-secrets/)
