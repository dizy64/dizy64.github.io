---
layout: post
title: git 초기화때 기본 브랜치를 main으로 설정하기
date: 2022-05-22 15:00:00 +0900
categories: 'development'
---

GitHub과 GitLab에서 대표 브랜치를 `main`으로 사용하도록 변경됨에 따라 기존 대표 브랜치였던 `master`에서 `main`으로 브랜치를 변경하는 경우가 발생한다. 물론 이 방침에 동의하지 않거나, CI/CD나 다수 설정에서 브랜치를 연동해두어서 변경이 어려운 경우도 있다.

master 라는 단어가 노예제도를 연상하기 때문에 변경한다고 하는데 사실 한국의 정서에서는 체감이 되지 않을 수 있지만 보다 나아지기 위해 시도하는 것에 동의하기 때문에 나도 동참하고자 한다.

우선 GitHub과 GitLab의 정책이지만 Git의 기본 정책은 아니기 때문에 Git에서는 기본 브랜치가 여전히 `master`이다.<br/>
새로 만드는 브랜치에 대해서 기본 브랜치를 `master`가 아닌 `main`으로 생성하려면 다음과 같이 설정하면 된다. 

```shell
git config --global init.defaultBranch main
```

`--global` 옵션을 주었기 때문에 이제 해당 머신에서는 항상 `git init`을 할 경우 `main`브랜치가 기본 브랜치로 설정된다. 