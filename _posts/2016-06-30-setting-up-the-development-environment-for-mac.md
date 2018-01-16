---
layout: post
title: "맥 개발 환경 설정하기"
subtitle: "나의 개발 환경 세팅을 위한 정리"
date: 2016-06-30 12:03:05 +0900
meta-image: "http://dizy64.github.io/images/thumb_develop_env.jpg"
categories: 'dev'
tags: [mac, development environment, development tools, homebrew]
---

### XCODE 설치 및 Command Line tools 설치

AppStore에서 설치하면 됨. 다운로드 속도가 느릴 땐 XCODE 공식 홈페이지를 이용하면 조금 빠를 때가 있더라.

설치가 완료되면

```bash
$ xcode-select --install
$ xcodebuild -license
```

### Homebrew 설치

<a href="http://brew.sh/" target="_blank">Homebrew</a>에서 시키는대로 설치하면 된다.<br/> 이 글을 작성하는 시기에는 아래와 같다.

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

설치 후 brew cask 사용하기 위해서 아래와 같이 설치합니다.

```bash
$ brew tap caskroom/cask
$ brew tap caskroom/versions
$ brew tap caskroom/fonts
$ brew tap homebrew/dupes
```

### iterm2 설치하기

맥에서 지원하는 기본 터미널은 불편하니까 iterm2 을 사용한다.

```bash
$ brew cask install iterm2
```

### zsh 설치

개인적으론 기본 bash shell 보다 zsh가 편해서 zsh를 사용하고 있다.<br/> 추가로 zsh의 플러그인인 oh-my-zsh를 설치하는데 개인적으로는 이만큼 편한게 있나 싶을 정도(...)<br/> 물론 이외에도 많은 shell이 많다.

```bash
$ brew install zsh
$ chsh -s $(which zsh)
```

만약 shell 경로를 잘못 지정해서 터미널 접근이 안되고 logout 된다면 기본 터미널의 설정을 열어서 아래와 같이 기본 bash 를 연결하면 된다.

<img src="{{ site.url }}/images/shell_error.png">

### oh-my-zsh 설치하기

zsh을 좀 더 편리하게 사용할 수 있도록 도와준다.

플러그인과 테마등을 활용하면 편리한 개발 환경을 도와준다.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

### GNU 유틸리티 설치하기

이 부분은 예전에 Kenny형의 환경 설정에서 가져와서 메모해뒀던 내용인데 아무래도 기본 유틸리티보다는 GNU 버전의 최신 유틸리티로 변경하는 것이 좋은 것 같다.

```bash
$ brew install gnu-sed --with-default-names
$ brew install gnu-tar --with-default-names
$ brew install gnutls --with-default-names
$ brew install grep --with-default-names
$ brew install coreutils
$ brew install binutils
$ brew install diffutils
$ brew install gzip
$ brew install watch
$ brew install tmux
$ brew install wget
$ brew install nmap
$ brew install gpg
$ brew install htop
$ brew install macvim --with-override-system-vim
$ brew linkapps macvim
```

### 필요한 어플리케이션 설치하기

caskroom을 설치하고 나면 유틸리티성 패키지 설치 뿐만 아니라 일반적인 맥 어플리케이션도 설치/관리 할 수 있다.<br/>
우선 크롬, 파이어폭스, 비발디 브라우저, 그리고 git을 설치한다.

```bash
$ brew cask install google-chrome
$ brew cask install firefox
$ brew cask install vivaldi
$ brew cask install java
$ brew install git
```

추가로 D2-coding 폰트를 추가한다.

```bash
$ brew cask install font-d2coding
```

### 결론

이외의 개발환경(Ruby, Python 등등..)은 다음에 다시 정리해서 올리겠다.<br/> 이번엔 정말 최소한의 환경에 대한 포스팅이다.<br/> 사실 내가 까먹지 않으려고 썼다고 봐야..

혹여나 처음 맥을 구입하거나, 아직 제대로 환경설정을 못해본 분이라면 조금 참고해서 본인의 환경을 만들 수 있기를 바란다.
