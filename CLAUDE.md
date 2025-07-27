# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

이 프로젝트는 Jekyll 기반의 개인 블로그입니다. GitHub Pages를 통해 배포되며, 개발/운영/리뷰/도구 등의 카테고리별로 기술 포스트를 작성합니다.

## 개발 명령어

### 로컬 개발 서버 실행
```bash
bundle exec jekyll serve
```
- 브라우저에서 http://localhost:4000 으로 접속
- 파일 변경시 자동 리빌드 (--livereload 옵션 추가 가능)

### Docker 환경에서 실행
```bash
docker-compose up
```
- Docker를 통해 일관된 환경에서 개발 가능
- 포트 4000으로 서비스 제공

### 의존성 설치
```bash
bundle install
```

## 블로그 포스트 작성

### 파일명 규칙
`_posts/YYYY-MM-DD-title-with-hyphens.md`

### Front Matter 예시
```yaml
---
layout: post
title: 포스트 제목
date: 2024-11-16 10:40:00 +0900
categories: 'dev'  # 카테고리: dev, operation, review, tools, life, etc.
---
```

### 카테고리별 분류
- `dev`: 개발 관련 포스트
- `rails`: Ruby on Rails 관련
- `tools`: 개발 도구 및 유틸리티
- `operation`: 서버 운영 및 인프라
- `review`: 회고 및 리뷰
- `life`: 개인적인 경험

## 아키텍처

### Jekyll 디렉토리 구조
- `_posts/`: 블로그 포스트 마크다운 파일
- `_layouts/`: 페이지 레이아웃 템플릿 (default.html, post.html, page.html)
- `_includes/`: 재사용 가능한 HTML 조각 (header, footer, head, meta)
- `_sass/`: SCSS 스타일시트 (_base.scss, _layout.scss)
- `css/`: 컴파일된 CSS 및 메인 SCSS 파일

### 레이아웃 시스템
- `default.html`: 기본 페이지 레이아웃 (헤더, 푸터 포함)
- `post.html`: 블로그 포스트 레이아웃 (Disqus 댓글, 이전/다음 글 네비게이션 포함)
- `page.html`: 정적 페이지 레이아웃

### 주요 설정
- 사이트 제목: "Epilogue"
- 도메인: blog.dizy.dev
- 페이지네이션: 10개 포스트per page
- 마크다운 엔진: kramdown
- 코드 하이라이터: rouge
- 플러그인: jekyll-paginate, jekyll-coffeescript

### 스타일링
- Bootstrap 기반 반응형 디자인
- SCSS를 통한 모듈화된 스타일시트
- 다크/라이트 테마 지원 없음 (기본 라이트 테마)

## 특이사항

- Disqus 댓글 시스템 통합
- 소셜 미디어 링크 (Twitter, GitHub, Facebook)
- 포스트 내 한국어 네비게이션 ("이전 글", "다음 글")
- 카테고리별 URL 구조 (pretty permalinks)
- 이미지는 `/images/` 디렉토리에 저장

## 카테고리별 색상 배지 시스템

### 새로운 카테고리 색상 추가하기
`_data/category_colors.yml` 파일을 수정하여 새로운 카테고리의 색상을 설정할 수 있습니다.

```yaml
# 새로운 카테고리 추가 예시
javascript: ["#f7df1e", "#ffed4e"]  # 노란색 - JavaScript
kubernetes: ["#326ce5", "#4285f4"]  # 파란색 - Kubernetes
```

### 배지 사용법
포스트의 Front Matter에서 카테고리를 설정하면 자동으로 해당 색상의 배지가 표시됩니다.

```yaml
---
layout: post
title: "포스트 제목"
categories: 'javascript'  # category_colors.yml에 정의된 카테고리
---
```

### 색상 선택 가이드
- **개발/기술**: 파란색 계열 (#2563eb, #3b82f6)
- **언어별**: 해당 언어의 대표 색상 사용
- **도구/유틸**: 초록색 계열 (#059669, #10b981)
- **리뷰/회고**: 보라색 계열 (#7c3aed, #8b5cf6)
- **개인/라이프**: 분홍색 계열 (#db2777, #ec4899)