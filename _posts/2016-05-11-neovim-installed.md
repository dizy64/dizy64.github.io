---
layout: post
title:  "OS X El Capitan에서 neovim 설치하기"
subtitle: "NEOVIM을 사용해보자"
date:   2016-05-11 13:14:50 +0900
categories: 'dev'
tags: [development tools, vim, neovim]
---

나는 최근까지 MACVIM을 사용하고 있었다.

작년에 [NEO VIM](http://www.neovim.io)에 대한 이야기를 듣기는 했지만 어떤 녀석인지 잘 몰라서 사용하지 않고 있다가 최근에 관심이 생겨서 드디어 오늘 설치를 해보았다.

NEO VIM는 오래 된 VIM을 리팩토링하고, 개선해나가는 버전이라고 한다. 호환성도 최대한 유지되어있다고 하고.. 자세한 내용을 몰라서 정리를 못했지만.. 다른 분들의 평가를 들어보면 빠르다는건 알겠다(...)

설치 자체는 [Homebrew](http://www.brew.sh)를 사용하기 때문에 간단하게 할 수 있었고 설정 파일이 있어야 하는 경로를 몰라서 조금 헤맸다.

### 설치방법

```bash
brew install neovim/neovim/neovim
```

끝...

그리고 설정 파일 경로는 `~/.config/nvim/`에 두면 된다.
나 같은 경우는 `~/.config/nvim/init.nvim` 으로 뒀다.

`cp -r ~/.vimrc ~/.config/nvim/init.nvim`

그리고 nvim은 손이 많이가니까 nvi 로 alias 걸어줬다.

`echo alias nvi="nvim" > ~/.zshrc`

사용해보고 괜찮으면 macvim보다 neovim을 더 많이 사용하게 되지 않을까 생각된다.


### 결론

일단은 사용해보고 평가를 하는 걸로.
