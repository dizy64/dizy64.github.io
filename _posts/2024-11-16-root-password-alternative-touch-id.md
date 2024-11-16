---
layout: post
title: 터미널에서 관리자 비밀번호 대신 Touch ID 로 로그인하기
date: 2024-11-16 10:40:00 +0900
categories: 'tools'
---

터미널에서 관리자 패스워드가 필요한 경우 매번 입력하기 귀찮을 때가 있다. Touch ID 로 로그인하는 방법을 알아보자

방법은 간단하다. `/etc/pam.d/sudo` 파일에 Touch ID 인증 모듈을 추가하면 된다.
단, 관리자 권한이 필요하므로 sudo로 접근하여 Overwrite 하거나 사전에 권한을 755 정도로 바꾼 다음 다시 권한을 수정해줘야 한다.

다행히도 sudo 를 통해서 vi로 접근했을때 overwrite(`!`)가 가능해서 나는 이 방법을 통해서 수정하였다.

```shell
sudo vi /etc/pam.d/sudo
```


```
auth       sufficient     pam_tid.so
``` 

이 문구를 2번째 라인에 추가한다. 그리고 overwrite로 저장한다 (`:w!`)

최종 완료된 예시

```shell
auth       sufficient     pam_tid.so
auth       include        sudo_local
auth       sufficient     pam_smartcard.so
auth       required       pam_opendirectory.so
account    required       pam_permit.so
password   required       pam_deny.so
session    required       pam_permit.so
```

---

이렇게 터미널에서 매번 관리자 패스워드를 입력할 필요 없이 Touch ID를 이용해 간편하게 인증할 수 있다. <br/>
나의 경우는 Touch ID가 없는 맥북에서는 설정하지 않고 주로 노트북으로 작업하는 서브용 맥북 에어에 설정해서 사용하고 있다.<br/>

만약 모니터를 덮었거나 해서 Touch ID를 사용할 수 없는 경우에 Touch ID로 설정한 경우 확인 다이얼로그에서 패스워드를 입력하거나 Apple Watch로 비밀번호를 해제할 수도 있다.
