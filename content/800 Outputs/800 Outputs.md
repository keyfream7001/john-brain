---
tags: [type/index, methodology/cmds, project/app, status/completed]
created: 2026-02-04
---

# 📦 800 Outputs

> CMDS **Share** 단계 — 결과물, 배포, 앱

---

## 📂 하위 폴더

- [[Mohim Dashboard|801 Apps / Mohim]] — 모힘 목표 관리 앱

---

## 💡 설명

실제로 세상에 나간 결과물을 정리하는 곳.
배포된 앱, 출판물, 공개된 프로젝트 등.

### 사용법
- 배포된 앱 정보 → `801 Apps/`
- 출판/발표 자료 → 여기에 기록
- 오픈소스 기여 → 여기에 기록

---

## 📊 이 폴더의 노트

```dataview
TABLE tags AS "태그", file.ctime AS "생성일"
FROM "800 Outputs"
WHERE file.name != "800 Outputs"
SORT file.ctime DESC
```
