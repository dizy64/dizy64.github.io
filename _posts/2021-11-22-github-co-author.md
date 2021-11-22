---
layout: post
title: 여러명의 작업자와 함께 커밋하기
date: 2021-11-22 19:49:00 +0900
categories: 'co-work'
---

페어 프로그래밍을 하다보면 작업을 하게 될 컴퓨터에 git 설정에 따라 커밋의 작성자가 결정된다.<br/>
함께 작업을 했으니 커밋 로그를 통해 공동작업자의 기여를 인정해주고, 또 협업자가 트래킹이 가능하다면 좋겠다고 생각했다.

GitHub PR리뷰를 진행할 때 Suggestion Code를 작성했을 때 해당 코드를 채용하여 즉시 적용하면 협업자의 이름도 함께 커밋에 뜨는 것을 우연히 본 적이 있다.

이를 활용하면 페어 프로그래밍을 할 때 공동 작성자를 명시할 수 있지 않을까? 하는 생각에 검색을 해보니 GitHub에서 2018년부터 지원을 했다고 한다.

다만, Git의 공식적인 프로토콜은 아니고 GitHub이 최초로 파싱하여 사용 보여줄 수 있도록 구현하였고 GitLab도 따라 지원하기 시작한 것 같다.

적용하는 방법은 커밋의 본문 영역에 `Co-authored-by`라고 이름을 붙이고 뒤에 이름과 이메일 주소를 명시해주면 된다.

터미널에서 커밋을 한다면 아래와 같은 방식이 될 것이고

```shell
git commit -m "Commit message

Co-authored-by: Joel Califa <602352+califa@users.noreply.github.com>
Co-authored-by: Matt Clark <44023+mclark@users.noreply.github.com>"
```

직접 커밋 메세지를 작성하는 별도의 에디터를 사용할 경우 아래와 같이 작성하면 된다.

```
Commit message

Co-authored-by: Joel Califa <602352+califa@users.noreply.github.com>
Co-authored-by: Matt Clark <44023+mclark@users.noreply.github.com>
```

<img style="width: 640px; height: 338px;" src="https://github.blog/wp-content/uploads/2018/01/35053024-b818ee72-fbb1-11e7-93f8-11baf411f1c1.gif?resize=685%2C362">

공식 이미지를 보면 이런 식으로 나온다고 한다.

다들 즐겁게 페어 프로그래밍하시고 또 서로의 작업을 잘 남기시길 바란다.

# 참고 문서

- [Github - Commit together with co-authors](https://github.blog/2018-01-29-commit-together-with-co-authors/)
- [Github - Creating a commit with multiple authors](https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/creating-a-commit-with-multiple-authors)
- [Gitlab - Add banzai filter to detect commit message trailers and properly link the users](https://gitlab.com/gitlab-org/gitlab-foss/-/merge_requests/17919)