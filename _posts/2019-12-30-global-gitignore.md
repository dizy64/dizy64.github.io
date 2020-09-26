---
layout: post
title: 모든 git 저장소에 적용되는 gitignore 만들기 
date: 2019-12-30 21:58:18 +0900
categories: 'development'
permalink: development/2019/12/30/global-gitignore.html
---

다양한 프로젝트를 하다보면 모든 프로젝트에서 Tracking 하지 않고 싶은 파일들이 있다.<br/>
예를 들면 민감 데이터가 들어있는 direnv의 rc 파일인 `.envrc` 라거나 각 프로젝트별 공통으로 만들어지는 Cache 파일들을 무시하고 싶을때가 많다.

그럴 때 아래와 같이 세팅하고 자신의 User 최상위 디렉토리에서 .gitignore 파일을 관리하면 된다.

### For MAC

```shell
git config --global core.excludesfile ~/.gitignore
```

### For Windows

```shell
git config --global core.excludesfile "%USERPROFILE%\.gitignore"
```