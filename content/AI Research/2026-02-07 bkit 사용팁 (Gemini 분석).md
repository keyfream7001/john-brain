---
tags: [type/research, ai/claude, ai/agents, ai/gpt, status/completed]
created: 2026-02-07
---

# bkit 사용 팁 - Gemini 분석 버전

> **영상**: [바이브코딩의 근본 문제들을 해결해주는 도구 bkit](https://youtu.be/EZwffHVx05U)
> **채널**: 코드깎는노인
> **분석일**: 2026-02-07
> **분석 방식**: Gemini 스타일 (공식 문서 + 웹 리서치 기반)

---

## 📌 한줄 요약

**bkit = 바이브코딩의 "무계획 난개발" 문제를 PDCA 방법론으로 해결하는 Claude Code 플러그인**

---

## 🎯 bkit이 해결하는 문제

| 문제 | bkit 해결책 |
|------|------------|
| 무작정 코딩 시작 | PDCA 순서 강제 (계획→설계→구현→검증→개선) |
| 컨텍스트 유실 | 단계별 문서 자동 생성 |
| 뭘 해야할지 모름 | `/pdca status`, `/pdca next` 명령어 |
| 품질 검증 어려움 | Zero Script QA (AI 실시간 검증) |
| 레벨별 기술스택 혼란 | 3단계 레벨 시스템 (Starter/Dynamic/Enterprise) |

---

## 🚀 핵심 워크플로우

### 1️⃣ 설치 (최초 1회)
```bash
# Claude Code에서 실행
/plugin marketplace add popup-studio-ai/bkit-claude-code
/plugin install bkit
```

### 2️⃣ 프로젝트 시작
```bash
# 레벨 선택
/starter    # 정적 웹 (HTML/CSS/JS)
/dynamic    # 풀스택 앱 (Next.js + BaaS)
/enterprise # 마이크로서비스 (K8s, Terraform)
```

### 3️⃣ PDCA 사이클 (핵심!)
```bash
/pdca plan "기능명"     # 1. 계획 문서 생성
/pdca design "기능명"   # 2. 설계 문서 생성
/pdca do "기능명"       # 3. 구현 가이드 + 코딩
/pdca analyze "기능명"  # 4. 갭 분석 (설계 vs 구현)
/pdca iterate "기능명"  # 5. 자동 개선 (최대 5회)
/pdca report "기능명"   # 6. 완료 보고서
```

### 4️⃣ 상태 확인
```bash
/pdca status  # 현재 진행 상태
/pdca next    # 다음에 뭘 해야 하는지 안내
```

---

## 💡 실전 팁

### ⭐ Tip 1: PDCA 순서 엄수
```
❌ "로그인 기능 만들어줘" (바로 코딩)
✅ "/pdca plan 로그인" → 계획부터 시작
```

### ⭐ Tip 2: 한국어 설정
```json
// ~/.claude/settings.json
{
  "language": "korean"
}
```

### ⭐ Tip 3: `/pdca status` 습관화
- 작업 시작할 때마다 현재 위치 확인
- 어디까지 했는지, 뭐가 남았는지 한눈에

### ⭐ Tip 4: 문서가 컨텍스트를 유지
- 각 PDCA 단계마다 문서 자동 생성
- 세션 끊겨도 문서가 맥락 보존

### ⭐ Tip 5: iterate는 90% 임계값
- `/pdca iterate`는 Evaluator-Optimizer 패턴 사용
- 90% 품질 달성할 때까지 최대 5회 반복

---

## 🧩 bkit 구성요소

| 구성요소 | 수량 | 역할 |
|---------|------|------|
| AI Agents | 11개 | 역할별 전문가 (PM, 아키텍트 등) |
| Skills | 21개 | 도메인별 지식 (프론트엔드, 백엔드 등) |
| Scripts | 39개 | 훅 실행 스크립트 |
| Functions | 132개 | 상태 관리, 의도 감지 |
| 지원 언어 | 8개 | 한국어 포함 |

---

## 🔑 핵심 명령어 요약

| 명령어                                           | 용도         |
| --------------------------------------------- | ---------- |
| `/bkit`                                       | 전체 도움말     |
| `/starter`, `/dynamic`, `/enterprise`         | 프로젝트 레벨 선택 |
| `/pdca plan/design/do/analyze/iterate/report` | PDCA 사이클   |
| `/pdca status`                                | 현재 상태 확인   |
| `/pdca next`                                  | 다음 단계 안내   |
| `/code-review`                                | 코드 리뷰      |
| `/claude-code-learning`                       | 학습 가이드     |

---

## 📚 참고 자료

- [bkit GitHub](https://github.com/popup-studio-ai/bkit-claude-code)
- [bkit 공식 사이트](https://www.bkit.ai/)
- [TILNOTE 개념 정리](https://tilnote.io/en/pages/6971d065324e33cc1df11173)

---

## 🎬 관련 영상

- [[2026-02-07 Claude Code Agent Teams]] - 에이전트 팀즈 기능
- [[2026-02-06 Claude Code로 앱 양산]] - Claude Code 활용

---

*Gemini 스타일 분석: 공식 문서 + 웹 리서치 기반*

#bkit #claude-code #pdca #vibecoding
