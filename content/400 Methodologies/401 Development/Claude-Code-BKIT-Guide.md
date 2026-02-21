---
created: 2026-02-11
tags:
  - type/guide
  - dev/claude
  - ai/agents
  - methodology/bkit
---

# Claude Code BKIT 가이드

## ⚠️ 필수 플래그 (중요!)

```bash
claude --dangerously-skip-permissions
```

- **파일 읽기/쓰기 허가 안 물어봄**
- 멀티에이전트 작업 시 필수!
- 없으면 매번 허가 물어서 작업 막힘
- tmux에서 실행할 때 특히 중요

## 🎯 목표

웬디가 Claude Code + bkit으로 작업해서 **90% 완성된 결과물** 전달

## 📋 기본 작업 흐름

### 1. 프로젝트 시작
```bash
cd C:\JohnCodeQ\{프로젝트명}
claude --dangerously-skip-permissions
```

### 2. PDCA 사이클
```bash
/pdca plan {기능명}     # 계획
/pdca design {기능명}   # 설계
/pdca do {기능명}       # 구현
/pdca analyze {기능명}  # 갭 분석
/pdca iterate {기능명}  # 자동 개선 (90% 목표)
/pdca report {기능명}   # 완료 보고서
```

### 3. QA 검증
```bash
/zeroscript-qa
```

## 🏗️ Agent Teams (복잡한 작업)

```bash
/pdca team {기능}      # 여러 에이전트 협업 시작
/pdca team status     # 진행 모니터링
```

> 환경변수: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`

## 📊 핵심 명령어

| 명령어 | 용도 |
|--------|------|
| `/dynamic` | 풀스택 프로젝트 시작 |
| `/pdca plan` | 계획 |
| `/pdca do` | 구현 |
| `/pdca iterate` | 자동 개선 |
| `/zeroscript-qa` | 자동 테스트 |

## 🔗 참고

- GitHub: https://github.com/popup-studio-ai/bkit-claude-code
- 영상: https://youtu.be/EZwffHVx05U
