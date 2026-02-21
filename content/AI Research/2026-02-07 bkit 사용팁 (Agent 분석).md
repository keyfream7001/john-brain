---
tags: [type/research, ai/claude, ai/agents, dev/python, status/completed]
created: 2026-02-07
---

# bkit 사용팁 (Agent 분석)

> **영상 출처**: [바이브코딩의 근본 문제들을 해결해주는 도구 bkit | AI 인공지능 클로드코드](https://youtu.be/EZwffHVx05U)
> **채널**: 코드깎는노인
> **업로드**: 2026.01.30 | 조회수 2.6만회 | 25분 45초
> **분석일**: 2026-02-07

---

## 📌 핵심 요약

**bkit**은 Claude Code 플러그인으로, **PDCA 방법론**을 통해 바이브 코딩의 근본적 문제들을 해결하는 도구다.

### 바이브 코딩의 문제점
- AI가 만든 코드는 문법적으로 완벽하지만 **논리적으로 허술**할 수 있음
- 파일마다 코드 스타일이 제각각
- AI가 요청사항을 **잊어버리고 구현 누락**
- 코드 검증에 만드는 시간의 **몇 배 이상** 소요
- 체계 없이 대충 요청하면 결과물 품질 저하

### bkit이 해결하는 것
- **체계적인 개발 워크플로우** 제공
- AI가 알아서 **체계를 갖춰서** 일하도록 조율
- **문서 기반 개발** (Docs = Code 철학)
- 자동 **테스트 및 검증**
- **반복적 개선** (Evaluator-Optimizer 패턴)

---

## 🔧 bkit 설치 방법

### Marketplace 설치 (권장)
```bash
# Step 1: 마켓플레이스 추가
/plugin marketplace add popup-studio-ai/bkit-claude-code

# Step 2: 플러그인 설치
/plugin install bkit
```

### 자동 업데이트 설정
```json
// ~/.claude/settings.json
{
  "plugins": {
    "autoUpdate": true
  }
}
```

---

## 📋 PDCA 방법론

**P**lan - **D**o - **C**heck - **A**ct의 순환 구조

| 단계         | 설명                   | bkit 명령어                  |
| ---------- | -------------------- | ------------------------- |
| **Plan**   | 계획 수립, 브레인스토밍        | `/pdca plan {feature}`    |
| **Design** | 설계 문서 작성             | `/pdca design {feature}`  |
| **Do**     | 구현 가이드               | `/pdca do {feature}` no   |
| **Check**  | 차이 분석 (Gap Analysis) | `/pdca analyze {feature}` |
| **Act**    | 반복 개선                | `/pdca iterate {feature}` |
| **Report** | 완료 보고서               | `/pdca report {feature}`  |
| **Status** | 현재 상태 확인             | `/pdca status`            |
| **Next**   | 다음 단계 안내             | `/pdca next`              |

---

## ⚡ 주요 명령어

### 프로젝트 초기화
```bash
/starter      # 정적 웹사이트 (간단한 프로젝트)
/dynamic      # 풀스택 앱 (BaaS 활용)
/enterprise   # 마이크로서비스 (K8s, Terraform)
```

### 학습 모드
```bash
/claude-code-learning   # Claude Code 사용법 학습
```

### QA 테스트
```bash
/zeroscript-qa   # 코드 문제점 자동 테스트 및 수정
```

### CTO-Led Agent Teams (v1.5.1+)
```bash
/pdca team {feature}    # 팀 시작
/pdca team status       # 진행 상황 모니터링
/pdca team cleanup      # 리소스 정리
```

> ⚠️ Agent Teams 사용 시: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` 환경변수 필요

---

## 🎯 실전 워크플로우 (영상 예시)

### 1. MVP 먼저 만들기
```bash
/init-dynamic  # 다이나믹 프로젝트로 초기화
```
- 한 줄 아이디어로 **아주 간단한 형태**의 MVP 먼저 생성
- 이 밑바탕을 **눈덩이**처럼 굴려서 확장

### 2. 브레인스토밍
```bash
/pdca plan {feature}
```
- AI가 질문하고, 사용자가 답하는 **티키타카** 방식
- 아이디어 조각들을 모아서 **계획 문서** 자동 생성

### 3. 단계별 구현
```bash
/pdca do page-1   # 1페이지 구현
/pdca do page-2   # 2페이지 구현
...
```
- 문서 기반으로 **체계적인 구현**
- 각 단계마다 **테스트 + 개선** 자동 수행

### 4. 스모크 테스트
- 기계 부품에서 연기가 나는지 확인하는 것처럼
- 각 부분의 **기본 작동 여부** 검증

### 5. Gap Analysis
```bash
/pdca analyze {feature}
```
- 요구사항 vs 현재 구현 **차이 분석**
- 보고서 기반으로 **코드 수정** 진행

### 6. 반복 개선
```bash
/pdca iterate {feature}
```
- **Evaluator-Optimizer 패턴**으로 품질 향상
- 최대 5회 반복 (90% 임계값)

---

## 🏗️ bkit 아키텍처

### Context Engineering 3계층
| 계층 | 구성요소 | 목적 |
|------|---------|------|
| Domain Knowledge | 26개 Skills | 구조화된 전문 지식 |
| Behavioral Rules | 16개 Agents | 역할 기반 제약 (opus/sonnet/haiku 모델 선택) |
| State Management | 165개 Functions | PDCA 상태, 의도 감지, 팀 조정 |

### 5-Layer Hook System
1. `hooks.json` (Global)
2. Skill Frontmatter
3. Agent Frontmatter
4. Description Triggers (8개 언어 지원)
5. Scripts (43개 모듈)

### CTO-Led Agent Teams
| Agent | Model | 역할 |
|-------|-------|------|
| cto-lead | opus | 팀 오케스트레이션, PDCA 워크플로우 관리 |
| frontend-architect | sonnet | UI/UX 설계, 컴포넌트 아키텍처 |
| product-manager | sonnet | 요구사항 분석, 기능 우선순위 |
| qa-strategist | sonnet | 테스트 전략, 품질 메트릭 조정 |
| security-architect | opus | 취약점 분석, 인증 설계 검토 |

---

## 💡 실전 팁

### 1. 작은 것부터 시작
> "한 줄의 아이디어로 MVP를 먼저 만들고, 거기서 확장해 나가는 방식"

### 2. 문서화의 중요성
- bkit은 **문서를 가드레일**로 활용
- 단순히 코드만 만드는 게 아니라 **검증 + 개선**까지

### 3. 색상 팔레트 정의
영상에서 보여준 디자인 개선 과정:
1. 화면 구성 요소 정리
2. 색상 팔레트 선택 (예: VS Code Dark Theme, Dracula, Monokai)
3. 일관된 디자인 적용

### 4. 단계 확인
```bash
/pdca status   # 현재 어느 단계인지 확인
/pdca next     # 다음에 뭘 해야 하는지 안내
```

---

## 🔗 관련 링크

- **공식 사이트**: https://www.bkit.ai/
- **GitHub**: https://github.com/popup-studio-ai/bkit-claude-code
- **bkit-starter** (초보자용): https://github.com/popup-studio-ai/bkit-starter
- **bkit-gemini** (Gemini CLI용): https://github.com/popup-studio-ai/bkit-gemini

---

## 📚 핵심 철학 (3 Core Philosophies)

1. **Automation First** - 자동화 우선
2. **No Guessing** - 추측 금지, 명확한 요구사항
3. **Docs = Code** - 문서가 곧 코드

---

## 🤔 개인 생각

bkit은 **Context Engineering**의 실용적 구현체라고 볼 수 있다. 단순한 프롬프트 작성을 넘어서, 시스템 전체가 AI에게 최적의 컨텍스트를 제공하도록 설계되어 있다.

바이브 코딩을 하면서 느꼈던 **"AI가 맥락을 자꾸 잊어버리는 문제"**, **"코드 품질 검증의 어려움"** 등을 체계적으로 해결하려는 시도가 인상적이다.

특히 PDCA 사이클과 Evaluator-Optimizer 패턴의 결합은, 단순히 코드를 생성하는 것을 넘어 **지속적으로 품질을 개선**하는 방향성을 제시한다.

---

#bkit #ClaudeCode #PDCA #바이브코딩 #AI코딩 #ContextEngineering
