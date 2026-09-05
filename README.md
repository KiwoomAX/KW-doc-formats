# KW-doc-formats

클로드 코드 플러그인이다. 사내 문서 형식을 다루는 스킬 여섯이 들어 있다. 공식 `document-skills`는 리눅스 샌드박스를 전제하므로 이 PC에서는 기본값이 틀리거나 도구가 아예 없다. 이 플러그인은 그 자리만 덮는다.

## 들어 있는 스킬

| 스킬 | 언제 열리나 | 무엇이 있나 |
|---|---|---|
| `kw-doc-formats:common` | 문서 파일을 파이썬으로 읽거나 쓸 때 | 어떤 형식이 바로 읽히는지, `encoding=`을 적는 규칙, 사내 CSV의 cp949 판별, 엑셀로 열 CSV의 `utf-8-sig` |
| `kw-doc-formats:hwp` | `.hwp` `.hwpx` `.doc` `.ppt` `.xls`를 받았을 때 | 한/글과 오피스를 조종해 최신 형식으로 바꾸는 법 |
| `kw-doc-formats:pdf` | 긴 PDF를 읽을 때와 PDF로 내보낼 때 | 볼 쪽만 고르는 법, 엣지 헤드리스 인쇄 |
| `kw-doc-formats:pptx` | 한국어 발표자료를 만들거나 고칠 때 | 글자 윤곽선과 `fontFace`와 테마의 로마자 슬롯 |
| `kw-doc-formats:xlsx` | 엑셀을 만들 때 | 셀 글자 크기를 11로 두는 규칙 |
| `kw-doc-formats:docx` | 워드 문서를 만들거나 읽을 때 | `python-docx`로 만들고 `markitdown`으로 읽는다 |

`common`은 나머지 다섯이 본문에서 함께 열라고 가리킨다. 스킬은 서로를 자동으로 부르지 않으므로, `common`의 `description`이 형식을 가리지 않고 파일을 열고 쓰는 모든 작업에 걸리도록 적혀 있다.

## 설치

새 PC 설치기 `kw_install`이 이 플러그인을 함께 깐다. 손으로 깔려면 이렇게 한다.

```
claude plugin marketplace add KiwoomAX/KW-doc-formats
claude plugin install kw-doc-formats@kw-doc-formats
```

## 전제

이 스킬은 kw_install이 깔아 주는 파이썬 3.12 라이브러리와 Poppler가 있는 PC를 전제한다. 라이브러리 목록의 정본은 kw_install 레포의 `requirements.txt`다. 이 레포는 그 목록을 다시 적지 않는다.

공식 `document-skills`도 함께 깔려 있어야 한다. `pdf`와 `pptx`와 `xlsx`와 `docx`는 그 스킬을 대체하지 않고 이 PC에서 어긋나는 자리만 덮으므로, 둘을 함께 연다. kw_install이 둘 다 깐다.

스킬 본문에서 새 파이썬 모듈을 부르게 되면 kw_install의 `requirements.txt`도 손으로 맞춰야 한다. 두 레포 사이에는 자동 대조가 없다.
