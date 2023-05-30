---
layout: post
title: TablePlus 앱에서 aws session manager 접속이 안되는 문제
date: 2023-05-30 21:52:00 +0900
categories: 'development'
---

회사에서는 JetBrains 지원을 해주기 때문에 DataGrip을 사용하고 있지만 개인적으로는 [TablePlus](https://tableplus.com/)를 사용하고 있다.
그리고 더 이상 PEM키를 발급받아 서버 인증을 하지 않고 AWS Session Manager를 통해서 ssh를 접근하고 있는데 이때 터널링을 하기 위해 ssh\_config에서 ProxyCommand에 ssm을 호출하여 접근할 수 있도록 설정하고 있다.

근데 TablePlus에서는 이게 적용이 안되는 문제가 발생해서 찾아보니 Debug 모드로 실행해보라고 했고, 놀랍게도 Debug 모드에서는 잘 접근이 되었다.

많은 검색 끝에 ProxyCommand에 패스를 잡아주니 해결이 되었다.

원인은 모르겠지만 그냥 실행할때는 잡히던 패스가 TablePlus 에서 실행할때는 잡히지 않는 문제였던 것 같다.

```bash
Host hostname
    ProxyCommand sh -c "PATH=/usr/local/bin:$PATH aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
```

apple slicon의 경우 PATH가 아래와 같음

```bash
Host hostname
  ProxyCommand sh -c "PATH=/opt/homebrew/bin/:$PATH aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
```
