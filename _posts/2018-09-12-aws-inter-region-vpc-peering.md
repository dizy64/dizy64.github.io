---
layout: post
title:  "AWS 다른 Region간의 peering 설정"
date: 2018-09-12 19:08:21 +0900
categories: 'dev'
tags: [aws, devops]
---

회사에서 EC2 인스턴스를 만드는데 해당 인스턴스 클래스를 서울 리전에서는 100대 밖에 늘릴 수 없다고 해서 500대의 용량이 있는 일본 서버를 함께 사용해야되는 상황이었다.

다만 이 인스턴스가 하는 일이 내부에서 잡을 처리하는 서버들이기 때문에 외부에 노출될 필요가 없고, 노출되어서도 안된다고 판단하여 알아보던 찰라에 다른 Region 간의 peering이 가능하다는 소식을 듣고 작업을 진행했다.

우선 주의해야 할 점이 있는데 한 쪽 리전은 기본 VPC를 사용할 수 없다.

당연하겠지만 peering을 하기 위해서는 VPC 대역대가 겹치면 안된다는 문제가 있는데 AWS의 기본 대역대는 **172.31.0.0/16** 이다.

겹치지 않는 Private Network 대역대를 사용해야 하기 때문에 [rfc1918](https://tools.ietf.org/html/rfc1918)의 기준에 따라 대역대는 아래의 기준에 맞게 설정하면 된다.

```
3. Private Address Space

   The Internet Assigned Numbers Authority (IANA) has reserved the
   following three blocks of the IP address space for private internets:

     10.0.0.0        -   10.255.255.255  (10/8 prefix)
     172.16.0.0      -   172.31.255.255  (172.16/12 prefix)
     192.168.0.0     -   192.168.255.255 (192.168/16 prefix)
```

우리는 이미 서울 리전이 기본 VPC를 사용하고 있었기 때문에 도쿄 리전에 CIDR 대역대가 다른 VPC를 새로 생성해주었다.

생성 후 서울 리전의 VPC 관리 화면에 피어링 메뉴에서 도쿄 리전을 선택한 후 VPC ID는 새로 생성한 VPC ID를 입력한 뒤 연결을 요청하면, 도쿄 리전 VPC 관리 화면에서 수락을 해줄 수가 있다.

수락 후 VPC와 라우트 테이블을 조절 해주고 보안 그룹에서 INBOUND / OUTBOUND를 잡아주면 대부분 문제 없이 진행되었다.

## 만난 문제점

일본 리전에서는 VPC를 새로 만들었기 때문에 기본 VPC가 아니면 ipv4 자동 생성 옵션이 꺼져있어서 EC2 instance 들이 외부 인터넷 망을 연결하지 못하는 문제들이 발생했었다. (덕분에 S3도 접근할 수 없었음.)

VPC 서브넷에서 ipv4 자동 생성 옵션을 켜주면 도움이 될 것이다.

## 참고 문서

- [https://aws.amazon.com/ko/blogs/korea/new-almost-inter-region-vpc-peering/](https://aws.amazon.com/ko/blogs/korea/new-almost-inter-region-vpc-peering/)
- [https://aws.amazon.com/ko/blogs/korea/inter-region-vpc-peering-in-seoul-region/](https://aws.amazon.com/ko/blogs/korea/inter-region-vpc-peering-in-seoul-region/)
