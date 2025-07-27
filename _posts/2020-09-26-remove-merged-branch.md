---
layout: post
title: 사용하지 않는 브랜치 삭제하기
date: 2020-09-26 10:40:00 +0900
categories: 'development'
---

이미 리뷰를 통해 머지되었지만, 로컬에는 남아있는 브랜치를 정리하기 위해서 이미 머지된 브랜치들을 찾아서 삭제하도록 하는 방법을 찾아보았다.

### 현재 로컬에 존재하는 브랜치 목록 보기

기본적으로 Git에서 지원하는 명령어 중 브랜치 목록을 보여주는 명령어

```shell
git branch
```

### 머지된 브랜치 목록 보기

이미 머지된 적이 있는 브랜치 목록을 보여주는 옵션이 `--merged` 이다.

다만, `master` 브랜치와 `develop` 브랜치도 종종 머지가 될 수도 있기 때문에 함께 목록에 나온다.

```shell
git branch --merged
```

### master, develop 을 제외한 브랜치 목록

목록 중 `master`와 `develop` 을 제거하기 위해 파이프라인을 통해 해당 목록을 제거한다.

```shell
git branch --merged | egrep -v "(^\*|master|develop)"
```

### 이미 머지된 브랜치를 삭제하기

그렇게 추린 다음 아래와 같이 삭제하게 되면 이미 머지된 브랜치만 삭제할 수 있다.

```shell
git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -D
```
