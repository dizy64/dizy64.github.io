---
layout: post
title: Django의 unittest에서 SQL 로그 확인하기
date: 2021-11-11 18:49:00 +0900
categories: 'django'
---

이직을 했더니 파이썬을 쓰고 있어서 파이썬, 장고에 대해서 쓰게 된 첫 포스팅이다.

N+1 쿼리 제거 및 성능 개선 작업을 맡게 되면서 테스트케이스를 실행하면서 동작한 쿼리셋에 대한 SQL을 확인하려고 했는데 원하는대로 되지 않는 문제가 발생했다.

로깅 관련 설정을 하고 settings 환경에서 
`DEBUG = True`를 처리하면 장고 서버를 실행한 환경에서는 분명 SQL 로그가 출력되는 것을 확인했는데 이상하게 unittest 에서만 출력되지 않았다.

몇 주간 불편하게 직접 query를 프린트 해보면서 작업하다가 이대로는 안 될 것 같아서 동료분들에게 SOS를 요청했는데 그 중에 유효한 답을 얻을 수 있었다. 

unittest 환경에서 `DEBUG`값이 `False`로 오버라이딩 된다는 것이다.

그렇게 오버라이딩 하는 이유는 공식 문서에서 찾을 수 있었는데 DEBUG 모드로 설정된 경우 production과 동일한 환경으로 테스트가 되지 않을 가능성을 막고자 오버라이딩 한다고 한다.

이를 해결하기  위해선 두가지 방법이 있다.

## 1. 테스트 케이스 별로 세팅을 오버라이딩 시키는 방법

테스트의 설정을 재정의 할 때 사용할 때 사용하는 방법이라고 한다. [(참고 링크)](https://docs.djangoproject.com/en/3.2/topics/testing/tools/#django.test.override_settings)

디버깅 모드가 영향을 주는 것을 지양하는 정책에 따른다면 원하는 테스트케이스에서만 SQL을 볼 수 있기 때문에 더 적절하지 않을까 싶다.

```python
from django.test import override_settings

@override_settings(DEBUG=True)
def test_시나리오(self):
  pass
```

## 2. 테스트 러너의 옵션에 디버깅 옵션을 주입하는 방법

다른 하나의 방법은 테스트 러너에 옵션으로 디버그 모드로 진입하게 하는 방법이다.<br/>
`--debug-sql` 혹은 `-d` 라는 옵션을 주어 실행하게 되면 로그를 볼 수 있다.

이렇게 실행하게 된다면 러너가 실행한 모든 테스트케이스에 대해서 SQL 로그를 출력할 수 있다.

## 로깅을 할 수 있도록 환경 설정하기

참고로 settings.py 파일 혹은 settings 디렉토리 하위에 각 설정에 다음과 같이 로깅과 관련된 주입을 해야 SQL 쿼리를 볼 수 있다. 이 설정은 콘솔 화면으로 출력하는 방식인데 옵션을 조정하면 파일로 출력한다거나 포멧을 조정한다거나 할 수 있을 것으로 보인다.

```python
LOGGING = {
    'version': 1,
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
        }
    },
    'loggers': {
        'django.db.backends': {
            'level': 'DEBUG',
            'handlers': ['console'],
        }
    }
}
```

# 참고 문서

- [테스트 러너 옵션 정보](https://docs.djangoproject.com/en/3.2/ref/django-admin/#test-runner-options)
- [테스트케이스에서 Debug = False 가 되는 설명](https://docs.djangoproject.com/en/3.2/topics/testing/overview/#other-test-conditions)