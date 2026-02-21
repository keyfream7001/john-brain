---
tags:
  - project/active
  - dev/nextjs
  - dev/typescript
  - ai/agents
  - ai/claude
created: 2026-02-12
status: active
github: https://github.com/keyfream7001/agent-monitor
---

# Agent Monitor Dashboard 🤖

실시간 OpenClaw 에이전트 모니터링 대시보드

## 개요

OpenClaw Gateway에서 실행 중인 AI 에이전트들(웬디 + sub-agents)을 실시간으로 모니터링하는 웹 대시보드.

## 기술 스택

| 분류 | 기술 |
|------|------|
| Framework | Next.js 16 (Turbopack) |
| Language | TypeScript |
| Styling | Tailwind CSS 4 |
| UI | React 19 |
| API | OpenClaw Gateway REST API |
| Deployment | 로컬 개발 (Tailscale 접근 가능) |

## 주요 기능

### 1. 카드 뷰
- 각 에이전트 상태를 카드 형태로 표시
- 실시간 작업 요약 (한글)
- 상태 표시: working 🔵 / idle ⚪ / done 🟢 / error 🔴

### 2. 픽셀 마을 뷰 🏘️
- 픽셀아트 월드에서 에이전트들 시각화
- 세션 = 마법사 캐릭터 🧙
- 프로세스 = 로봇 캐릭터 🤖
- 실시간 움직임 애니메이션

### 3. 로그 타임라인
- 실시간 작업 로그
- 시간순 정렬

### 4. 사용량 모니터
- Claude Max 일일/주간 사용량 표시
- 토큰 사용량 + 리셋 시간
- 색상 경고 시스템 (정상/경고/위험)

### 5. 터미널 뷰어
- tmux Claude Code 세션 로그 실시간 확인

## 만들어진 과정

### 2026-02-12

1. **초기 설정** - Next.js 16 + TypeScript + Tailwind 프로젝트 생성
2. **OpenClaw 연동** - Gateway API 호출 → 세션 데이터 파싱
3. **카드 UI** - AgentCard 컴포넌트, 한글 작업 요약 자동 생성
4. **픽셀 마을** - PixelWorld 컴포넌트, 캐릭터 SVG 스프라이트
5. **프로세스 통합** - tmux Claude Code를 로봇 캐릭터로 표시
6. **사용량 모니터** - Claude Max 토큰 사용량 + PST 기반 리셋 시간
7. **에러 처리 개선** - graceful 실패 처리 + 토스트 알림
8. **Mock 데이터 제거** - 실제 데이터만 표시

### Sub-agents 활용
- `claude-usage-monitor` - 사용량 모니터 UI 구현
- `village-process-chars` - 프로세스 마을 캐릭터 구현
- `usage-monitor-fix` - API 최적화 (12초 → 5초)
- `remove-mock-data` - Mock 데이터 제거
- `fix-error-handling` - 에러 처리 개선

## 프로젝트 구조

```
agent-monitor/
├── app/
│   ├── page.tsx              # 메인 대시보드
│   └── api/                  # API 라우트
│       ├── agents/           # 에이전트 목록
│       ├── sessions/         # OpenClaw 세션
│       ├── processes/        # tmux 프로세스
│       └── usage/            # 사용량 데이터
├── components/
│   ├── AgentCard.tsx         # 에이전트 카드
│   ├── PixelWorld.tsx        # 픽셀 마을
│   ├── UsageMonitor.tsx      # 사용량 모니터
│   └── TerminalViewer.tsx    # 터미널 뷰어
├── lib/
│   ├── openclaw.ts           # OpenClaw API 클라이언트
│   └── types.ts              # 타입 정의
└── .env.local                # 환경변수
```

## 실행 방법

```bash
cd C:\JohnCodeQ\agent-monitor
npm install
npm run dev
# http://localhost:3000
# Tailscale: http://100.124.46.21:3000
```

## GitHub

https://github.com/keyfream7001/agent-monitor

## 향후 개선

- [ ] WebSocket 실시간 연결 (polling → push)
- [ ] 세션 상세 보기 모달
- [ ] 세션 제어 (종료, 메시지 전송)
- [ ] 다크/라이트 테마 전환
- [ ] 모바일 반응형

## 관련 링크

- [[OpenClaw]] - AI 에이전트 프레임워크
- [[웬디]] - 메인 AI 비서
