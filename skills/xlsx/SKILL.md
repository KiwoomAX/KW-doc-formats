---
name: xlsx
description: 엑셀(.xlsx)을 만들 때 document-skills:xlsx와 함께 반드시 연다. 셀 글자 크기를 따로 바꾸지 말고 11로 두는 규칙이 여기 있다. 엑셀로 열 CSV의 인코딩은 kw-doc-formats:common에 있다.
---

# 엑셀을 만들 때

**`kw-doc-formats:common` 을 함께 본다.** 파일을 열고 쓸 때의 인코딩과, 어떤 형식이 바로
읽히는지가 거기 있다.

일반적인 엑셀 다루기는 `document-skills:xlsx` 에 있다. 여기는 이 PC에서 그 기본값이 틀리거나
그 도구가 없는 자리만 적는다.

## 엑셀을 만들 때 항상 지킬 것

셀 글자 크기는 **11**로 둔다. 엑셀의 기본값이 11이고, `openpyxl`이 새로 만드는 통합 문서의
`Normal` 스타일도 11이다. 셀마다 크기를 따로 지정하지 않는다. 지정해야 하는 자리가 있어도
11로 적는다. 머리글을 돋보이게 하려면 크기가 아니라 굵기와 채우기 색으로 한다. 글꼴 이름은
이 규칙이 다루지 않는다.

```python
from openpyxl.styles import Font
ws["A1"].font = Font(bold=True)             # 크기를 적지 않는다. 11을 물려받는다
ws["A1"].font = Font(size=11, bold=True)    # 적어야 한다면 11이다
```
