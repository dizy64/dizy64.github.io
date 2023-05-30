---
layout: post
title: Git 원격 기본 레포 자동으로 설정하기
date: 2023-05-30 21:42:00 +0900
categories: 'development'
---

늘 별 생각없이 `git push origin`으로 push를 하면 아래와 같이 원격지를 설정하라는 안내를 받게 된다.

> fatal: The current branch feature/branch\_name has no upstream branch.
> To push the current branch and set the remote as upstream, use
> 
> git push --set-upstream origin feature/branch\_name

이럴때 곧이 곧대로 원격지를 `--set-upstream {remoteName} {branchName}`으로 설정을 했었다.

근데 최근에 안내 메세지를 보니 다음과 같은 안내가 추가 되었다.

> To have this happen automatically for branches without a tracking
> upstream, see 'push.autoSetupRemote' in 'git help config'.

뭔가 새로운 옵션이 생긴 것 같아 확인해보니 git v2.37 버전부터 존재하는 기능인듯 하다. (릴리즈 노트에서 안보이는데 대부분의 페이지에서 그렇게 언급하고 있다.)<br/>
실제 동작은 `push.default current` 로 하는 것과 동일해보였다.

아래와 같이 push.autoSetupRemote 값을 true로 설정하면 된다. (repo 별로 설정을 다르게 하고 싶다면 --global 은 생략)

```shell
git config --global --add push.autoSetupRemote true
```

## 참고 링크

[git-scm: push.autoSetupRemote](https://git-scm.com/docs/git-config#Documentation/git-config.txt-pushautoSetupRemote)
