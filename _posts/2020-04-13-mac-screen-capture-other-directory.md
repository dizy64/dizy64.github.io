---
layout: post
title: MacOS 스크린샷 저장 위치 변경하기
date: 2020-04-13 23:02:00 +0900
categories: 'tools'
permalink: tools/2020/04/13/mac-screen-capture-other-directory.html
---

기본적으로 맥에서 [기본 기능을 이용하여 스크린 샷](https://support.apple.com/ko-kr/guide/mac-help/mh26783/mac)을 하게 되면 바탕 화면에 저장이 된다.

하지만 iCloud 연동을 통해 바탕화면, 내 문서 등을 동기화 해놓은 경우 불필요하게 스크린 샷이 쌓이기도 하고, 개인적으로는 바탕화면에 아이콘을 두는걸 선호하지 않는 편이라 위치를 변경하고 싶었다.

특히 과거 Dropbox를 쓸때는 캡쳐를 지정한 드랍박스 내 폴더에 할 수 있었기 때문에 방법이 없을까 하고 찾다가 방법을 찾았다.

터미널에서 아래와 같이 입력하면 된다.

```shell
defaults write com.apple.screencapture location "저장할 경로"
```

나 같은 경우는 홈 디렉토리에 ScreenCapture 디렉토리를 만들고 아래와 같이 설정하였다.

```shell
defaults write com.apple.screencapture location ~/ScreenCapture
```
