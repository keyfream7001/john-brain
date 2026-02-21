---
type: guide
aliases: [AI 모델 설정, 에이전트 모델]
author: "[[John]]"
date created: 2026-02-19
tags: [type/guide, status/inProgress, ai/claude, ai/agents, methodology/workflow]
status: inProgress
---

# AI Agent 모델 설정

## 웬디 (OpenClaw) 서브에이전트
- **모델**: `anthropic/claude-sonnet-4-6`
- **용도**: sessions_spawn으로 파견하는 모든 서브에이전트

## Claude Code 에이전트 팀
- **메인 에이전트**: Sonnet 4.6
- **하위 에이전트**: Haiku
- **용도**: 존이 "에이전트 팀즈 사용해"라고 할 때

## 유튜브 분석
- **모델**: `google/gemini-3-pro-preview`
- **Thinking**: high
- **용도**: 유튜브 영상 분석 시 사용

## 정리

| 상황 | 메인 모델 | 하위 모델 |
|------|-----------|-----------|
| 웬디 서브에이전트 | Sonnet 4.6 | - |
| Claude Code 팀 | Sonnet 4.6 | Haiku |
| 유튜브 분석 | Gemini 3 Pro | - (thinking: high) |

---

> 설정일: 2026-02-19
> 관련: [[CMDS Guide]]
