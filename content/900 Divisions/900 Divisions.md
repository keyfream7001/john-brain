---
tags: [type/index, methodology/cmds, status/completed]
created: 2026-02-04
---

# 🏢 900 Divisions

> CMDS **Share** 단계 — 부서, 조직, 개인

---

## 📂 하위 폴더

- [[901 Personal]] — 개인 관련

---

## 💡 설명

조직, 팀, 개인과 관련된 문서를 정리하는 곳.
업무 분장, 팀 구조, 개인 목표 등.

### 사용법
- 개인 목표/계획 → `901 Personal/`
- 팀/조직 관련 → 여기에 기록
- 네트워킹, 연락처 → 여기에 기록

---

## 📊 이 폴더의 노트

```dataview
TABLE tags AS "태그", file.ctime AS "생성일"
FROM "900 Divisions"
WHERE file.name != "900 Divisions"
SORT file.ctime DESC
```
