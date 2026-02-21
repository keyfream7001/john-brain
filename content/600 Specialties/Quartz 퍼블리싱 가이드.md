---
tags:
  - type/guide
  - dev/tools
  - methodology/workflow
  - status/completed
publish: true
created: 2026-02-21
summary: 옵시디언 노트를 선택적으로 웹에 공개하는 Quartz 퍼블리싱 시스템 사용법
---

# Quartz 퍼블리싱 가이드

> 옵시디언 노트를 **선택한 것만** 웹에 공개하는 시스템
> 🌐 사이트: https://keyfream7001.github.io/john-brain/

---

## 핵심 개념

- **기본값 = 비공개** → `publish: true` 없으면 절대 공개 안 됨
- **선택 공개** → 원하는 노트에만 태그 추가
- **자동 배포** → push 하면 GitHub Actions가 자동으로 사이트 업데이트

---

## 노트 공개하는 법

공개하고 싶은 노트 맨 위 frontmatter에 추가:

```yaml
---
publish: true
---
```

공개 취소하려면:
- `publish: false` 로 변경
- 또는 해당 줄 그냥 삭제

---

## 업데이트 방법

### 방법 1 — 웬디한테 말하기 (제일 쉬움)
```
웬디, 퀄츠 업데이트해줘
```

### 방법 2 — 직접 실행 (PowerShell)
```powershell
cd C:\JohnCodeQ\obsidian-quartz

# Step 1: publish:true 노트만 복사
.\sync-obsidian.ps1

# Step 2: GitHub에 push (자동 배포)
git add -A
git commit -m "update notes"
git push
```

배포 완료까지 약 **1~2분** 소요

---

## 파일/폴더 구조

```
C:\JohnCodeQ\obsidian-quartz\
├── content\              ← 공개된 노트들 (sync 후 자동 채워짐)
│   └── index.md          ← 홈페이지 (수정 가능)
├── sync-obsidian.ps1     ← 동기화 스크립트
├── quartz.config.ts      ← 사이트 설정 (제목, URL 등)
└── .github\workflows\
    └── deploy.yml        ← 자동 배포 설정
```

---

## 제외 폴더 (공개 안 됨)

`sync-obsidian.ps1` 의 `$ExcludeDirs` 에 지정된 폴더:
- `.obsidian`
- `.trash`
- `private`
- `archive`

추가 제외하고 싶은 폴더 있으면 이 목록에 추가하면 됨

---

## 사이트 설정 변경

`C:\JohnCodeQ\obsidian-quartz\quartz.config.ts` 파일에서:

| 항목 | 기본값 | 설명 |
|------|--------|------|
| `pageTitle` | John's Brain 🧠 | 사이트 제목 |
| `baseUrl` | keyfream7001.github.io/john-brain | 사이트 주소 |
| `locale` | ko-KR | 언어 |

---

## 관련 링크

- [[웬디 Git 버전관리 가이드]] — Git 기본 명령어
- GitHub 레포: https://github.com/keyfream7001/john-brain
- Quartz 공식문서: https://quartz.jzhao.xyz
