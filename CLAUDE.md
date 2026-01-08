# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

Jekyll 기반 개인 블로그. GitHub Pages를 통해 배포 (github-pages gem 232, Jekyll 3.10.0).

- **사이트**: https://blog.dizy.dev
- **Ruby 버전**: 3.3.4 (`.ruby-version` 참조)

## 개발 명령어

```bash
# 의존성 설치
bundle install

# 로컬 개발 서버 (http://localhost:4000)
bundle exec jekyll serve

# 실시간 리로드 포함
bundle exec jekyll serve --livereload

# Docker 환경
docker-compose up
```

## 블로그 포스트 작성

### 파일명 규칙
`_posts/YYYY-MM-DD-title-with-hyphens.md`

### Front Matter
```yaml
---
layout: post
title: 포스트 제목
date: 2024-11-16 10:40:00 +0900
categories: 'dev'
---
```

### 카테고리
| 카테고리 | 용도 |
|---------|------|
| `dev` | 개발 일반 |
| `rails`, `ruby` | Ruby/Rails |
| `python`, `django` | Python/Django |
| `docker` | Docker |
| `tools` | 개발 도구 |
| `operation` | 서버 운영 |
| `review` | 회고 |
| `life` | 개인 |

## 아키텍처

### 핵심 디렉토리
- `_posts/`: 블로그 포스트 (마크다운)
- `_layouts/`: 레이아웃 템플릿 (`default.html`, `post.html`, `page.html`)
- `_includes/`: 재사용 HTML 조각 (header, footer, head, meta)
- `_sass/`: SCSS 스타일시트
- `_data/`: 데이터 파일 (`category_colors.yml`)
- `images/`: 이미지 저장소

### 레이아웃 계층
```
default.html (헤더/푸터)
├── post.html (포스트 + Disqus 댓글 + 이전/다음 글)
└── page.html (정적 페이지)
```

### 주요 설정 (`_config.yml`)
- 마크다운: kramdown
- 코드 하이라이터: rouge
- 페이지네이션: 10개/페이지
- 플러그인: jekyll-paginate, jekyll-coffeescript, jekyll-redirect-from

## 카테고리 색상 배지

`_data/category_colors.yml`에서 카테고리별 그라데이션 색상 관리:

```yaml
# 새 카테고리 추가 예시
javascript: ["#f7df1e", "#ffed4e"]  # [시작색, 끝색]
```

색상 가이드:
- 개발/기술: 파란색 계열
- 언어별: 해당 언어 대표 색상
- 도구: 초록색 계열
- 리뷰: 보라색 계열
- 개인: 분홍색 계열

## 의존성 관리

### GitHub Pages 버전 확인
```bash
# 현재 프로젝트 버전 확인
bundle show github-pages

# GitHub Pages 공식 최신 버전 확인
curl -s https://pages.github.com/versions.json | jq '.["github-pages"]'
```

### 버전 업데이트
```bash
# 의존성 업데이트
bundle update

# 특정 gem만 업데이트
bundle update github-pages
```

### 호환성 체크 포인트
- **공식 버전 확인**: https://pages.github.com/versions/
- **릴리스 노트**: https://github.com/github/pages-gem/releases
- `github-pages` gem이 모든 의존성 버전을 관리하므로, 이 gem만 업데이트하면 Jekyll/kramdown/rouge 등이 함께 호환 버전으로 맞춰짐
- `nokogiri` 등 보안 패치는 Dependabot이 자동 PR 생성 (github-pages 요구사항 범위 내에서 호환)
