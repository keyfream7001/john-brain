---
type: guide
aliases: ["1man_coding 앱 허브 멀티에이전트 작업 지시서", "Claude Code 멀티에이전트 작업 설계서"]
author: "[[John]]"
date created: 2026-02-14
tags: [type/guide, status/inProgress, ai/automation, ai/agents, ai/gpt, ai/claude, methodology/workflow, dev/react, dev/nextjs, priority/high]
status: inProgress
---

# 1man_coding Apps Hub (모든 앱 통합) — 멀티에이전트 작업 지시서

## 목적
- `C:\JohnCodeQ\1man_coding`(Next.js) 프로젝트를 **메인 쉘(Shell)**로 확정.
- 내가 개발한 모든 앱/웹앱을 `/apps` 허브에 **전부 노출**.
- **10고개(App Builder)로 생성된 산출물은 제외**.
- UX 목표: “한 사이트 안에서 페이지 이동처럼 쓱쓱” (Next 라우팅 기반).
- 인증/구독: **Supabase Auth + 키움/이지페이 결제 + 3단 플랜(Free/Pro/Team)**.
- 일부 앱은 **비로그인 공개(일부공개)**.

---

## 제외 규칙 (10고개 산출물)
다음은 Apps Hub 등록 대상에서 제외:
- `C:\JohnCodeQ\appbuilder\*` 전체
- `C:\JohnCodeQ\app-builder` (있을 경우)
- `C:\JohnCodeQ\app-builder\*`
- `C:\JohnCodeQ\appbuilder-d095` 등 앱빌더 요청 산출 폴더

*그 외 `prototype-promotion`, `promptshot` 등은 10고개 자동생성이 아니라 “내 개발 프로젝트”면 포함 가능.*

---

## 운영 원칙 (중요)
### 안전/권한
- Claude Code의 보호/권한 프롬프트는 **우회/비활성화하지 않는다**.
- 파일 삭제/대규모 변경/외부 배포 등 위험 작업은 **존의 명시적 승인 후** 진행.
- “Dangerous permission”이 뜨면 **거부가 기본값**, 필요한 경우만 존에게 근거와 영향 설명 후 승인 받기.

### 멀티에이전트 운용
- 작업은 “쪼개서 병렬”로 진행.
- 장시간/리서치/대량 수정은 sub-agent(또는 Claude Code 세션)로 분산.
- 토큰 소모가 커지면:
  - 단순 반복/보일러플레이트/리팩터링은 **GPT 모델**로 전환
  - 아키텍처/권한/설계 의사결정은 **Claude(혹은 고품질 모델)** 유지

---

## BKIT 지침 반영 체크
(최소 기준)
- **B**reakdown: 작업을 20~60분 단위로 쪼개고 각 단계 Done 정의
- **K**eep context: `WORKLOG.md`에 진행/결정/다음 행동 기록 (컨텍스트 초기화 대비)
- **I**ncremental: 작은 단위로 구현→빌드→커밋 반복
- **T**ests/QA: 최소 smoke test(라우팅/권한/빌드) 통과

---

## 작업 산출물(필수)
1) `/apps` 허브 페이지(전체 앱 카드 자동 생성)
2) 앱 레지스트리 단일 소스: `src/data/apps.ts`
3) 권한 레이어:
   - middleware: 로그인 필요 구간 1차 차단
   - server/API: 플랜 재검증 2차 차단
4) “공개 앱/유료 앱” 정책을 레지스트리 기준으로 일관 적용
5) 문서:
   - `MVP-SPEC-APPS-HUB.md`
   - `QA-CHECKLIST-APPS-HUB.md`
   - `WORKLOG.md` (필수)

---

## 구현 설계(권장)
### 라우팅
- `/apps` : 공개(앱 목록)
- `/apps/[slug]/*` : 앱별
  - `publicAccess=true`이면 비로그인 접근 허용
  - 단, “저장/개인화/결제/내역”은 로그인 요구

### 플랜
- Free/Pro/Team
- 각 앱은 `requiredPlan`을 가짐:
  - `free | pro | team`
- 기능 락(Feature flag)은 추후 `requiredPlan`을 기능 단위로 확장 가능

### 단일 소스 레지스트리
- `src/data/apps.ts`
  - `slug, name, description, category, requiredPlan, publicAccess, status, repoPath, liveUrl, comingSoon`

---

## 작업 순서 (병렬 가능)
### Task 1 — 프로젝트 스캔 + 레지스트리 생성
- `C:\JohnCodeQ`의 최상위 폴더 목록 수집
- 제외 규칙 적용(10고개 산출물 제거)
- 각 프로젝트에 대해:
  - 스택(Next/Vite/Flutter/etc), 실행법(README/package.json), 배포 URL 유무 추출
- `src/data/apps.ts`에 자동으로 초기 등록(comingSoon 포함)

### Task 2 — `/apps` 허브 UI
- 카드: 이름/설명/플랜 배지/상태(live/dev/coming)
- 검색/필터(카테고리/플랜)
- 클릭 동작:
  - 통합된 Next 앱이면 `/apps/{slug}`
  - 아직 통합 전이면 “미리보기 + 외부 링크(옵션)” 또는 “Coming soon”

### Task 3 — 권한(로그인/플랜)
- middleware.ts:
  - `/apps`는 통과
  - `/apps/*`는 레지스트리 기준으로 publicAccess 앱은 통과
  - 그 외는 로그인 강제
- 서버측 재검증:
  - `requirePlan(slug)` 유틸로 플랜 미달 시 `/pricing?upgrade={slug}` 리다이렉트

### Task 4 — 1차 통합(대표 앱 1개)
- 우선순위 추천: `sikbi-proto` → Next로 이식해 `/apps/sikbi/*`로 완전 통합
- 이식 규칙:
  - 라우터 교체(React Router → Next App Router)
  - 상태(Zustand 등) 유지
  - 자산/경로 정리

### Task 5 — QA + 커밋
- `npm run lint`, `npm run build`
- 주요 시나리오:
  - `/apps` 접근
  - public 앱 접근
  - 유료 앱 접근 시 업그레이드 유도
  - 로그인/결제 플로우 영향 없음

---

## Claude Code / tmux 운용 가이드(개요)
- 여러 세션을 병렬로 띄워서 Task 1~3을 동시에 진행
- 각 세션은 자신의 `WORKLOG.md`에 진행 기록
- 세션 종료 시: 메인에 “변경 파일/다음 액션/리스크” 보고

> NOTE: 권한/보안 프롬프트 우회 지시(예: dangerous permission skip)는 하지 말 것.

---

## 체크포인트(놓치면 안 되는 것)
- 10고개 산출물 제외 규칙 확실히 적용
- `/apps`는 공개지만, 유료 앱은 접근 제어
- 서버에서 플랜 재검증(클라만 믿지 않기)
- WORKLOG로 컨텍스트 보존
