# KW-doc-formats

클로드 코드 플러그인이다. 사내 문서 형식을 다루는 스킬 `document-formats` 하나가 들어 있다. 한글(.hwp)과 구형 오피스와 PDF를 읽는 법, 긴 PDF에서 볼 쪽만 고르는 법, PPT를 만들 때 지킬 글꼴·윤곽선 규칙, 엑셀을 만들 때 지킬 글자 크기 규칙을 담는다.

## 설치

새 PC 설치기 `kw_install`이 이 플러그인을 함께 깐다. 손으로 깔려면 이렇게 한다.

```
claude plugin marketplace add KiwoomAX/KW-doc-formats
claude plugin install kw-doc-formats@kw-doc-formats
```

스킬은 `kw-doc-formats:document-formats`로 불린다.

## 전제

이 스킬은 kw_install이 깔아 주는 파이썬 3.12 라이브러리와 Poppler가 있는 PC를 전제한다. 라이브러리 목록의 정본은 kw_install 레포의 `requirements.txt`다. 이 레포는 그 목록을 다시 적지 않는다.

스킬 본문에서 새 파이썬 모듈을 부르게 되면 kw_install의 `requirements.txt`도 손으로 맞춰야 한다. 두 레포 사이에는 자동 대조가 없다.
