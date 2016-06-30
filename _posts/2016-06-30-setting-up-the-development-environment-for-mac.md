---
layout: post
title:  "맥 개발 환경 설정하기"
subtitle: "나의 개발 환경 세팅을 위한 정리"
date: 2016-06-30 12:03:05 +0900
categories: 'dev'
---

### XCODE 설치 및 Command Line tools 설치

AppStore에서 설치하면 됨.
다운로드 속도가 느릴 땐 XCODE 공식 홈페이지를 이용하면 조금 빠를 때가 있더라.

설치가 완료되면 

```
$ xcode-select --install
```

### Homebrew 설치
<a href="http://brew.sh/" target="_blank">Homebrew</a>에서 시키는대로 설치하면 된다.<br/>
이 글을 작성하는 시기에는 아래와 같다.

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

설치 후 brew cask 사용하기 위해서 아래와 같이 설치합니다.

```
$ brew tap caskroom/cask
$ brew tap caskroom/versions
```

### iterm2 설치하기

맥에서 지원하는 기본 터미널은 불편하니까 iterm2 을 사용한다.

```
$ brew cask install iterm2
```

### zsh 설치

개인적으론 기본 bash shell 보다 zsh가 편해서 zsh를 사용하고 있다.<br/>
추가로 zsh의 플러그인인 oh-my-zsh를 설치하는데 개인적으로는 이만큼 편한게 있나 싶을 정도(...)<br/>
물론 이외에도 많은 shell이 많다.

```
$ brew install zsh
$ chsh -s $(which zsh)
```

만약 shell 경로를 잘못 지정해서 터미널 접근이 안되고 logout 된다면 기본 터미널의 설정을 열어서 아래와 같이 기본 bash 를 연결하면 된다.

<img src="{{ site.url }}/images/shell_error.png">

oh-my-zsh 설치하기

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

### GNU 유틸리티 설치하기

```
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

```
$ brew cask install google-chrome
$ brew cask install firefox
$ brew cask install vivaldi
$ brew cask install java
```

