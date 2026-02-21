---
tags: [type/index, methodology/cmds, media/youtube, status/completed]
created: 2026-02-04
---

# 🎨 700 Creatives

> CMDS **Share** 단계 — 창작물, 콘텐츠, 디자인

---

## 💡 설명

창작 활동의 결과물을 모아두는 곳.
글, 디자인, 영상, 음악, 프롬프트 아트 등 모든 창작물.

### 사용법
- 블로그 글 초안 → 여기에 기록
- 디자인 작업물 → 여기에 기록
- AI 생성 콘텐츠 → 여기에 기록
- 프레젠테이션 → 여기에 기록

---

## 📊 이 폴더의 노트

```dataview
TABLE tags AS "태그", file.ctime AS "생성일"
FROM "700 Creatives"
WHERE file.name != "700 Creatives"
SORT file.ctime DESC
```
