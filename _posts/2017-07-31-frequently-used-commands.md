---
layout: post
title:  "내가 자주 사용하는 명령어 정리"
subtitle: "MYSQL 백업, 파일 전송, 파일 압축하기 등등.."
date: 2017-07-31 14:41:42 +0900
categories: 'dev'
tags: [command, terminal]
permalink: dev/2017/07/31/frequently-used-commands.html
---

블로그에 글을 너무 안쓰기도 했고 매번 MYSQL 덤프 뜰때, 압축할때, 파일 전송할때 검색을 해보기도 해서 이 부분들을 정리하려고 한다.

## MYSQL 백업

외부 서버에서 가져다가 백업할 경우 -h 옵션을 이용하면 됨.

이때 접근 권한 (실제 권한이나 아이피 문제 등등)을 잘 확인해야한다.

### MYSQL 백업하기

`mysqldump -u[userID] -p[PASSWORD] --all-databases > dump.sql`

`mysqldump -u[userID] -p[PASSWORD] --databases [DBNAME] > dump.sql`

`mysqldump -u[userID] -p[PASSWORD] [DBNAME] [TABLE]`

### MYSQL 복원하기

`mysql -u[userId] -p[password] [DBNAME] < dump.sql`


## SCP 사용법

계정 설정이나 관련 부분을 편하게 하고 싶으면 `~/.ssh/config` ssh 를 설정해두면 편리하다.
-P 는 포트 옵션이다. :로 경로를 지정하기 때문에 포트는 따로 전달인자로 넘긴다.
-r 는 폴더 복사 옵션이다.

### 다른 서버로 복사하기

`scp filename account@server_ip:/path/`

`scp test.text zero@dizy.me:/home/zero`

### 다른 서버에서 복사해오기

`scp account@server_ip:/path/filename path/filename`

`scp zero@dizy.me:/home/zero/test.text ./test.text`

## 파일 압축하기

tar과 tar.gz 의 차이에 대해서 자세히 잘 몰랐는데 검색해보니 아래와 같다고 한다.

tar : 압축보다는 파일을 묶는 용도. 주로 백업을 위해 사용됨.<br/>
tar.gz : 파일을 묶어서 압축함.

### tar 로 파일 묶기

`tar -cvf filename.tar target_path`

### tar 파일 풀기

`tar -xvf filename.tar`

### tar.gz 압축

`tar -zcvf filename.tar target_path`

### tar.gz 압축 풀기

`tar -zxvf filename.tar.gz`
