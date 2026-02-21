---
tags: [type/dashboard, type/index, methodology/cmds, status/completed]
created: 2026-02-04
---
[^1]
# 🧠 John's Brain

> CMDS 기반 개인 지식 관리 시스템

---

## 📚 CMDS 목차

### 🔗 Connect
- [[100 Theme]] — 테마, 아이디어, 노트
  - [[101 Ideas]]
  - [[102 Notes]]

### 🔀 Merge
- [[200 Literatures]] — 문헌, 개념, 참고자료
  - [[201 Concepts]]
  - [[202 References]]

### 🔧 Develop
- [[300 Data]] — 데이터, 데이터셋
- [[400 Methodologies]] — 방법론, 프레임워크
- [[500 Products]] — 제품, 프로토타입
- [[600 Specialties]] — 전문 분야
  - [[601 Flutter Dev]]

### 📤 Share
- [[700 Creatives]] — 창작물, 콘텐츠
- [[800 Outputs]] — 결과물, 앱
  - [[Mohim Dashboard|Mohim]]
- [[900 Divisions]] — 부서, 조직, 개인
  - [[901 Personal]]

---

## 🛠️ 도구
- [[Templates Index]] — 템플릿 모음
- [[CMDS Guide]] — CMDS 방법론 가이드
- [[Projects/]] — 진행 중인 프로젝트

---

## 📊 최근 활동

### 최근 수정된 노트
```dataview
TABLE file.mtime AS "수정일", file.folder AS "위치"
FROM ""
WHERE file.name != "Dashboard"
SORT file.mtime DESC
LIMIT 10
```

### 최근 생성된 노트
```dataview
TABLE file.ctime AS "생성일", file.folder AS "위치"
FROM ""
WHERE file.name != "Dashboard"
SORT file.ctime DESC
LIMIT 5
```

### 태그별 현황
```dataview
TABLE length(rows) AS "노트 수"
FROM ""
WHERE file.name != "Dashboard"
GROUP BY file.folder
SORT length(rows) DESC
```

[^1]: 
