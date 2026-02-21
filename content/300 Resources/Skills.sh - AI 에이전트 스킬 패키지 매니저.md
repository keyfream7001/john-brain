---
tags:
  - ai/skills
  - dev/workflow
  - methodology/workflow
  - ai/claude
  - dev/tools
created: 2026-02-13
source: https://skills.sh
status: completed
---

# Skills.sh - AI 에이전트 스킬 패키지 매니저

> **핵심 개념**: "npm이 코드 라이브러리의 패키지 매니저라면, skills.sh는 AI 지식의 패키지 매니저"

## 📌 개요

**Skills.sh**는 Vercel에서 만든 **AI 에이전트를 위한 오픈 스킬 에코시스템**이다. AI 코딩 에이전트(Claude Code, Cursor, Codex 등)에 재사용 가능한 지식과 능력을 추가할 수 있다.

- **공식 사이트**: https://skills.sh
- **GitHub**: https://github.com/vercel-labs/skills
- **총 설치 수**: 55,000+ (2026년 2월 기준)

### 지원 에이전트 (35개+)
- Claude Code ⭐
- OpenClaw ⭐
- Cursor
- Codex (OpenAI)
- Windsurf
- Gemini CLI
- GitHub Copilot
- Roo Code
- 등등...

---

## 🔧 설치 방법

### 기본 명령어
```bash
# 기본 설치 (GitHub shorthand)
npx skills add vercel-labs/agent-skills

# 특정 스킬만 설치
npx skills add vercel-labs/agent-skills --skill frontend-design

# 전역 설치 (모든 프로젝트에서 사용)
npx skills add vercel-labs/agent-skills -g

# 특정 에이전트에만 설치
npx skills add vercel-labs/agent-skills -a claude-code -a opencode
```

### 소스 형식
```bash
# GitHub 단축형
npx skills add vercel-labs/agent-skills

# GitHub URL
npx skills add https://github.com/vercel-labs/agent-skills

# 특정 스킬 직접 경로
npx skills add https://github.com/vercel-labs/agent-skills/tree/main/skills/web-design-guidelines

# 로컬 경로
npx skills add ./my-local-skills
```

### 관리 명령어
```bash
npx skills list          # 설치된 스킬 목록
npx skills find [query]  # 스킬 검색
npx skills remove [name] # 스킬 제거
npx skills check         # 업데이트 확인
npx skills update        # 스킬 업데이트
npx skills init [name]   # 새 스킬 템플릿 생성
```

---

## 📂 설치 위치

| 범위 | 플래그 | 경로 | 용도 |
|------|--------|------|------|
| 프로젝트 | (기본) | `.claude/skills/` | 팀과 공유, 프로젝트별 |
| 전역 | `-g` | `~/.claude/skills/` | 모든 프로젝트에서 사용 |

**OpenClaw의 경우:**
- 프로젝트: `skills/`
- 전역: `~/.moltbot/skills/`

---

## 🏆 인기 스킬 TOP 20

| 순위 | 스킬 | 제작자 | 설치 수 | 용도 |
|------|------|--------|---------|------|
| 1 | find-skills | vercel-labs | 202K | 스킬 검색 |
| 2 | vercel-react-best-practices | vercel-labs | 126K | React 베스트 프랙티스 |
| 3 | web-design-guidelines | vercel-labs | 95K | 웹 디자인 가이드 |
| 4 | remotion-best-practices | remotion-dev | 87K | 영상 제작 |
| 5 | **frontend-design** | anthropics | 64K | 프론트엔드 디자인 |
| 6 | vercel-composition-patterns | vercel-labs | 37K | 컴포넌트 패턴 |
| 7 | agent-browser | vercel-labs | 32K | 브라우저 자동화 |
| 8 | **skill-creator** | anthropics | 32K | 스킬 제작 |
| 9 | browser-use | browser-use | 28K | 브라우저 사용 |
| 10 | vercel-react-native-skills | vercel-labs | 27K | React Native |
| 11 | ui-ux-pro-max | nextlevelbuilder | 23K | UI/UX 디자인 |
| 12 | audit-website | squirrelscan | 18K | 웹사이트 감사 |
| 13 | brainstorming | obra | 18K | 브레인스토밍 |
| 14 | seo-audit | coreyhaines31 | 18K | SEO 감사 |
| 15 | **supabase-postgres-best-practices** | supabase | 16K | Supabase/Postgres |
| 16 | pdf | anthropics | 14K | PDF 처리 |
| 17 | copywriting | coreyhaines31 | 13K | 카피라이팅 |
| 18 | agent-tools | inf-sh | 13K | 에이전트 도구 |
| 19 | pptx | anthropics | 11K | PPT 제작 |
| 20 | **next-best-practices** | vercel-labs | 11K | Next.js |

---

## 🎯 Claude Code에서 활용법

### 스킬 적용 원리
1. 스킬 설치 → `.claude/skills/` 폴더에 `SKILL.md` 파일 생성
2. Claude Code 실행 시 자동으로 스킬 인식
3. 관련 작업 시 Claude가 스킬 지식을 참조하여 코드 작성

### 스킬 호출 방법
```bash
# 자동 호출: Claude가 관련 작업 감지 시 자동 적용
# 수동 호출: /skill-name 명령어로 직접 호출
/frontend-design
/fix-issue 123
```

### SKILL.md 구조
```yaml
---
name: my-skill
description: 스킬 설명 (Claude가 언제 사용할지 판단)
disable-model-invocation: true  # true면 수동 호출만 가능
allowed-tools: Read, Grep       # 허용할 도구 제한
context: fork                   # 서브에이전트에서 실행
---

# 스킬 내용
여기에 Claude가 따를 지침 작성...
```

### 유용한 스킬 조합

#### 웹 개발 (Vercel + Next.js + React)
```bash
npx skills add vercel-labs/agent-skills --skill vercel-react-best-practices
npx skills add vercel-labs/agent-skills --skill web-design-guidelines
npx skills add vercel-labs/next-skills --skill next-best-practices
npx skills add anthropics/skills --skill frontend-design
```

#### 백엔드/DB (Supabase)
```bash
npx skills add supabase/agent-skills --skill supabase-postgres-best-practices
npx skills add wshobson/agents --skill api-design-principles
npx skills add wshobson/agents --skill postgresql-table-design
```

#### 개발 워크플로우
```bash
npx skills add obra/superpowers --skill systematic-debugging
npx skills add obra/superpowers --skill test-driven-development
npx skills add obra/superpowers --skill writing-plans
npx skills add obra/superpowers --skill subagent-driven-development
```

#### 마케팅/SEO
```bash
npx skills add coreyhaines31/marketingskills --skill seo-audit
npx skills add coreyhaines31/marketingskills --skill copywriting
npx skills add coreyhaines31/marketingskills --skill content-strategy
```

---

## 🚀 우리 프로젝트에 적용

### EasyAPI 프로젝트
**추천 스킬:**
```bash
# API 설계
npx skills add wshobson/agents --skill api-design-principles
npx skills add wshobson/agents --skill nodejs-backend-patterns

# Supabase (백엔드로 사용 시)
npx skills add supabase/agent-skills --skill supabase-postgres-best-practices

# 타입스크립트
npx skills add wshobson/agents --skill typescript-advanced-types

# 테스트
npx skills add anthropics/skills --skill webapp-testing
```

### 10고개 앱빌더
**추천 스킬:**
```bash
# React/Next.js 프론트엔드
npx skills add vercel-labs/agent-skills --skill vercel-react-best-practices
npx skills add anthropics/skills --skill frontend-design

# UI/UX
npx skills add vercel-labs/agent-skills --skill web-design-guidelines
npx skills add nextlevelbuilder/ui-ux-pro-max-skill --skill ui-ux-pro-max

# 모바일 (React Native 고려 시)
npx skills add vercel-labs/agent-skills --skill vercel-react-native-skills
npx skills add expo/skills --skill building-native-ui
```

---

## 📝 커스텀 스킬 만들기

### 기본 템플릿
```bash
npx skills init my-custom-skill
```

### 예시: 프로젝트 컨벤션 스킬
```yaml
---
name: project-conventions
description: 우리 프로젝트의 코딩 컨벤션과 패턴
---

# 프로젝트 컨벤션

## 폴더 구조
- `src/components/` - React 컴포넌트
- `src/lib/` - 유틸리티 함수
- `src/api/` - API 라우트

## 네이밍 규칙
- 컴포넌트: PascalCase
- 함수: camelCase
- 상수: UPPER_SNAKE_CASE

## 코드 스타일
- TypeScript 필수
- Prettier 사용
- ESLint 규칙 준수
```

---

## 🔗 관련 링크

- [[Claude Code]] - Claude의 공식 CLI
- [[AI 코딩 도구 비교]]
- [[개발 워크플로우 최적화]]

## 참고 자료
- [Skills.sh 공식](https://skills.sh)
- [Claude Code Skills 문서](https://code.claude.com/docs/en/skills)
- [Vercel Skills GitHub](https://github.com/vercel-labs/skills)
