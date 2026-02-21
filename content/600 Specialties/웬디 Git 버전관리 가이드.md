---
type: guide
aliases: ["웬디 git", "워크스페이스 버전관리"]
author: "[[John]]"
date created: 2026-02-20
tags: [type/guide, status/completed, ai/agents, project/wendy, methodology/workflow]
status: completed
---

# 🌸 웬디 Git 버전관리 가이드

> 웬디 워크스페이스(`clawd/`)를 Git으로 관리하는 방법

## 개요

웬디의 핵심 파일(메모리, 설정, 스킬 등)을 Git으로 버전관리해서, 설정 변경이나 실험 전에 세이브 포인트를 만들고 문제 시 즉시 복구할 수 있다.

## 명령 규칙

| 존이 말하면 | 의미 | 대상 폴더 |
|------------|------|----------|
| **"웬디 git 커밋해"** | 웬디 워크스페이스 커밋 | `C:\Users\phase\clawd\` |
| **"웬디 git 복구해"** | 웬디 워크스페이스 롤백 | `C:\Users\phase\clawd\` |
| **"웬디 git 로그"** | 웬디 커밋 히스토리 | `C:\Users\phase\clawd\` |
| **"커밋해" / "프로젝트 커밋해"** | 프로젝트 레포 커밋 | `C:\JohnCodeQ\프로젝트\` |

> 웬디 git과 프로젝트 git은 완전히 별개 레포. 절대 혼동하지 않는다.

## 폴더 구조

```
C:\Users\phase\clawd\  ← 웬디 Git 레포
│
├── 📌 핵심 파일 (정체성/설정)
│   ├── SOUL.md           ← 웬디 성격
│   ├── AGENTS.md         ← 에이전트 규칙
│   ├── USER.md           ← 존 정보
│   ├── IDENTITY.md       ← 이름/이모지
│   ├── TOOLS.md          ← 도구 설정
│   ├── MEMORY.md         ← 메모리 인덱스
│   └── HEARTBEAT.md      ← 할 일
│
├── 🧠 memory/            ← 웬디 기억
│   ├── core-*.md
│   ├── proj-*.md
│   ├── know-*.md
│   └── YYYY-MM-DD.md
│
├── 🛠️ skills/            ← 커스텀 스킬
├── 📜 스크립트들
│
└── 🚫 Git에서 제외 (.gitignore)
    ├── node_modules/
    ├── tmp/
    ├── sikbi-proto/
    ├── .env (보안)
    └── .agents/, .claude/, .pi/
```

별도 폴더 (Git 미포함):
```
C:\Users\phase\.openclaw\   ← 게이트웨이 설정, 인증, 노드 페어링
```

## 주요 명령어

```bash
# 세이브 포인트 만들기
cd C:\Users\phase\clawd
git add -A
git commit -m "🔖 설명"

# 전체 복구 (마지막 커밋으로)
git restore .

# 특정 파일만 복구
git restore SOUL.md
git restore memory/MEMORY.md

# 히스토리 보기
git log --oneline

# 차이점 보기
git diff
```

## 언제 커밋하나?

- 큰 설정 변경 전 (새 에이전트 추가, 노드 설정 등)
- 하루 작업 마무리할 때
- 중요한 메모리 업데이트 후
- 존이 "웬디 git 커밋해"라고 할 때

## 용량 정보 (2026-02-20 기준)

- Git 관리 대상 (핵심 파일): ~1 MB
- 제외 파일 (node_modules, tmp 등): ~250 MB
- `.gitignore` 덕분에 레포 자체는 가벼움

## 🔗 관련 문서

- [[웬디 하드웨어 생태계 - 인프라 기술서]]
- [[웬디 (Wendy)]]

---

*작성: 웬디 🌸 | 2026-02-20*
