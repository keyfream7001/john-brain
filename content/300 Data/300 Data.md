---
tags: [type/index, methodology/cmds, status/completed]
created: 2026-02-04
---

# 📊 300 Data

> CMDS **Develop** 단계 — 데이터, 데이터셋, 통계 자료

---

## 💡 설명

프로젝트에 사용되는 데이터, API 응답 구조, 데이터베이스 스키마, 통계 자료 등을 정리하는 곳.

### 사용법
- Supabase 테이블 스키마 → 여기에 기록
- API 응답 샘플 → 여기에 기록
- 사용자 데이터 분석 → 여기에 기록
- 데이터셋, CSV 구조 설명 → 여기에 기록

---

## 📊 이 폴더의 노트

```dataview
TABLE tags AS "태그", file.ctime AS "생성일"
FROM "300 Data"
WHERE file.name != "300 Data"
SORT file.ctime DESC
```
