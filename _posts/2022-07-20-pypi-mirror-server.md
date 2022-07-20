---
layout: post
title: PyPi Mirror 서버 이용하기
date: 2022-07-20 21:00:00 +0900
categories: 'python'
---

공식 pypi 서버가 장애가 발생하거나, 물리적으로 가까운 한국 서버를 이용하는게 이점이 있다고 판단될 때 사용하면 되는 방법을 소개하고자 한다.

루비를 사용할때도 카카오(다음)에서 제공하는 미러 서버를 이용했는데 역시나 파이썬에 대해서도 제공해주고 있었다.

주로 설정을 이용한 방법, 커멘드 라인의 옵션 전달인자를 이용한 방법, Package 명세 파일(requirements.txt / Pipfile.lock)에 미러 서버를 명세하는 방법으로 나뉜다.

pip와 pipenv에 대한 방법을 작성해둔다.

# pip를 사용할 경우

## 1. pip의 설정을 통해 변경하기

```bash
pip config --user set global.index-url https://mirror.kakao.com/pypi/simple
pip config --user set global.trusted-host mirror.kakao.com
```

`~/.pip/pip.conf`

다음과 같이 설정

```bash
[global]
index-url=http://mirror.kakao.com/pypi/simple
trusted-host=mirror.kakao.com
```

이 방식을 사용하게 될 경우 문제가 될 수 있는 것은 항상 미러 서버를 바라보게 되기 때문에 발생하는 사이드 이펙트가 있다.<br/>
특히 미러 서버의 경우 최신본을 가져오는 시간과 차이가 발생할 수 있어서 원하는 최신 버전을 가져올 수 없는 문제가 발생할 수도 있다.

## 2. 인스톨 명령시 전달인자를 이용하여 설치하는 방법

```bash
pip install --index-url [https://mirror.kakao.com/pypi/simple](https://mirror.kakao.com/pypi/simple) {package}
pip install -i https://mirror.kakao.com/pypi/simple {package}
```

나는 이 방법이 제일 깔끔하다고 생각한다. 전달인자를 이용하여 해당 커멘드 라인에서만 인덱스 서버를 미러서버로 바라 볼 수 있다.<br/>
가끔 공식 인덱스 서버가 터져서 다운로드가 안될 때 사용하기 좋다.

## 3. requirements.txt 파일에 전달 인자를 추가

```markdown
-i https://mirror.kakao.com/pypi/simple 
```

requirements.txt 상단에 다음과 같이 옵션을 주면 된다. 이 경우에도 이 프로젝트는 항상 미러를 바라본다는 것이 되기 때문에 주의해야한다.

# pipenv를 사용할 경우

## 1. Pip 파일의 Source를 변경하거나 추가하는 방법

```python
[[source]]
url = "https://mirror.kakao.com/pypi/simple/"
verify_ssl = true
name = "kakao"

# ...

requests = {version="==2.18.4", index="kakao"}

```

이렇게 설치하게 될 경우 항상 인덱스를 미러를 바라보게 되고 Pipfile.lock → requirements.txt 파일의 -i 옵션이 추가 되기 때문에 주의해야함

## 2. 인스톨 명령시 전달인자로 미러 옵션을 추가하는 방법

```bash
pipenv install --pypi-mirror https://mirror.kakao.com/pypi/simple
```

pip 설명에서도 말했지만 나는 이 방법이 가장 안전하다고 생각한다.

## 3. 환경 변수에 설정하는 방법

```bash
PIPENV_PYPI_MIRROR=https://mirror.kakao.com/pypi/simple
```

위의 환경 변수를 설정해두면 pipenv가 pypi 미러 서버를 변경하여 바라보게 된다.

# 참고 자료

- [https://stackoverflow.com/questions/60814982/how-to-setup-pip-to-download-from-mirror-repository-by-default](https://stackoverflow.com/questions/60814982/how-to-setup-pip-to-download-from-mirror-repository-by-default)
- [https://pipenv-fork.readthedocs.io/en/latest/advanced.html#using-a-pypi-mirror](https://pipenv-fork.readthedocs.io/en/latest/advanced.html#using-a-pypi-mirror)
