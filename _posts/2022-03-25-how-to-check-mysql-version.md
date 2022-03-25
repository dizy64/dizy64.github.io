---
layout: post
title: MySQL/MariaDB 버전  확인하기 
date: 2022-03-25 21:24:00 +0900
categories: 'development'
---

# 1. MySQL/MariaDB 서버에서 SQL 질의로 버전 확인 하는 방법

## 1. 버전만 확인해도 무방 할 경우

```sql
SELECT VERSION();
```

다음과 같은 응답이 나온다

| `VERSION()` |
| --- |
| 10.3.34-MariaDB-0ubuntu0.20.04.1 |

## 2. 버전과 함게 상세 정보를 조회하고 싶은 경우

```sql
SHOW VARIABLES LIKE '%VERSION%'
```

설치 환경이나 내부 엔진 버전 등에 대해서 확인하고자 하는 경우 다음과 같이 질의 할 경우 아래와 같은 응답을 얻을 수 있다.

| Variable_name | Value |
| --- | --- |
| innodb_version | 10.3.34 |
| protocol_version | 10 |
| slave_type_conversions |  |
| version | 10.3.34-MariaDB-0ubuntu0.20.04.1 |
| version_comment | mariadb.org binary distribution |
| version_compile_machine | x86_64 |
| version_compile_os | debian-linux-gnu |
| version_malloc_library | bundled jemalloc |

# 2. MySQL 클라이언트 버전 확인

이 경우에는 MySQL Server이 환경 내 설치 되었을 때만 버전 정보가 정확히 나오며, MySQL Server는 설치하지 않고 MySQL Client 만 설치했을 경우 클라이언트 버전이 응답되기 때문에 주의해야 함.

```bash
> mysql --version 
mysql  Ver 8.0.28 for macos12.0 on x86_64 (Homebrew)

> mysql -V 
mysql  Ver 8.0.28 for macos12.0 on x86_64 (Homebrew)
```