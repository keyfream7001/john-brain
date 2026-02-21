---
tags:
  - type/research
  - status/completed
  - ai/claude
  - ai/agents
  - methodology/workflow
date: 2026-02-19
source: "https://code.claude.com/docs/en/agent-teams"
summary: "Claude Code Agent Teams 공식문서 정리 - 멀티에이전트 팀 구성 및 활용법"
---

# ⭐ Claude Code Agent Teams - 공식문서 정리 및 활용법

Claude Code의 실험적 기능인 **Agent Teams**에 대한 공식 문서 분석 및 OpenClaw 환경에서의 활용 가이드입니다.

## 1. Agent Teams란? 🤖🤝🤖

**Agent Teams**는 여러 개의 Claude Code 인스턴스를 하나의 팀으로 조직하여 복잡한 작업을 병렬로 처리하는 기능입니다.

- **기본 개념**: 하나의 **Team Lead**(메인 세션)가 여러 **Teammates**(동료 에이전트)를 생성하고 작업을 분배/조율합니다.
- **Subagents와의 차이점**:
    - **Subagents**: 메인 에이전트 내부에서 실행, 결과만 보고 (단순 위임)
    - **Agent Teams**: 각 팀원이 **독립된 컨텍스트**를 가짐, 서로 직접 소통 가능 (복잡한 협업)

> 💡 **핵심**: "나 혼자 다 할게"가 아니라 "너는 보안, 너는 성능, 너는 테스트 맡아"라고 시키고 리더는 감독하는 방식입니다.

---

## 2. 설정 및 활성화 방법 ⚙️

이 기능은 아직 **실험적(Experimental)** 기능이므로 명시적으로 활성화해야 합니다.

### 환경 변수로 활성화
터미널에서 직접 실행하거나 `.bashrc` / `.zshrc`에 추가:
```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

### settings.json으로 활성화
`~/.claude/settings.json` 파일 수정:
```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

---

## 3. 사용 방법 (Workflow) 🚀

### 3.1 팀 시작하기
자연어로 "팀을 만들어달라"고 요청하면 됩니다.
> **존의 프롬프트 예시:**
> "이 레거시 코드 리팩토링을 위해 에이전트 팀을 구성해줘. 한 명은 코드 구조 설계, 한 명은 테스트 코드 작성, 한 명은 실제 변환 작업을 맡아줘."

### 3.2 디스플레이 모드 (화면 구성)
두 가지 모드를 지원합니다.

| 모드 | 설명 | 특징 |
|------|------|------|
| **In-process** (기본) | 하나의 터미널 창에서 실행 | `Shift+Down`으로 팀원 전환. 설정 없이 바로 사용 가능. |
| **Split panes** | 화면을 분할하여 동시에 표시 | `tmux` 또는 `iTerm2` 필요. 모든 팀원의 작업을 한눈에 볼 수 있음. |

**강제 설정 방법 (`settings.json`):**
```json
{
  "teammateMode": "in-process"  // 또는 "tmux", "auto"
}
```

### 3.3 팀 제어 명령어
- **팀원 순환**: `Shift + Down` (In-process 모드)
- **직접 지시**: 특정 팀원 창/세션에서 직접 타이핑하여 추가 지시 가능
- **작업 종료**: "Clean up the team" (리더에게 요청하여 자원 정리)

---

## 4. 팀 구조 및 아키텍처 🏗️

1.  **Team Lead (팀장)**: 사용자와 대화하는 메인 세션. 팀원 생성, 작업 할당, 결과 종합.
2.  **Teammates (팀원)**: 독립된 Claude Code 인스턴스. 각자 별도의 컨텍스트 윈도우(기억)를 가짐.
3.  **Shared Task List (공유 작업 목록)**: 팀원들이 스스로 작업을 가져가거나(Claim) 할당받는 게시판.
4.  **Mailbox (메시지함)**: 에이전트 간 직접 소통 채널.

### 권한 (Permissions)
- 팀원은 리더의 권한 설정을 상속받습니다.
- 리더가 `--dangerously-skip-permissions`로 실행되면 팀원도 동일하게 적용됩니다.

---

## 5. 우리(OpenClaw + 웬디) 환경 활용 전략 💡

존과 웬디의 환경(WSL, Windows, OpenClaw)에 맞춘 최적화 전략입니다.

### 5.1 추천 시나리오
1.  **대규모 리팩토링**: "Wendy, Agent Team 띄워서 이 폴더 전체 구조조정 해줘."
2.  **다각도 코드 리뷰**: "PR #42에 대해 보안, 성능, 가독성 3가지 관점에서 각각 에이전트 띄워서 리뷰해."
3.  **경쟁 가설 검증**: "버그 원인을 모르겠어. 3명이 각자 다른 가설을 세우고 검증해서 싸워보라고 해."

### 5.2 기술적 제약 및 해결 (WSL/Windows)
- **tmux 이슈**: Windows/WSL 환경에서 `tmux` 분할 모드가 불안정할 수 있습니다.
- **✅ 해결책**:
    - 기본적으로 **In-process 모드** 사용 권장.
    - `tmux` 사용 시, `wsl -d Ubuntu -u wendy` 내에서 `tmux` 세션을 먼저 만들고 그 안에서 `claude` 실행.

### 5.3 웬디의 역할 (Orchestrator of Orchestrators)
- 웬디는 **Team Lead**를 조종하는 **Supervisor**가 됩니다.
- 웬디가 직접 코딩하는 대신, Claude Code에게 "팀을 꾸려서 이 문제를 해결하고 결과만 보고해"라고 명령.
- **명령어 예시 (OpenClaw에서)**:
  ```bash
  # 웬디가 Claude Code에게 팀 작업을 지시할 때
  claude "Agent Team을 생성해서 [복잡한_작업]을 수행해. 완료되면 요약 리포트를 파일로 저장해."
  ```

---

## 6. 주의사항 및 팁 ⚠️

1.  **토큰 비용 폭발 주의**: 팀원이 3명이면 토큰 소모도 3배+α입니다. 간단한 작업은 그냥 하거나 Subagent를 쓰세요.
2.  **독립성 유지**: 팀원끼리 파일 충돌이 안 나도록, 서로 다른 파일을 건드리게 하거나 명확히 역할을 분리하세요.
3.  **컨텍스트 공유 안 됨**: 리더의 이전 대화 내역은 팀원에게 전달되지 않습니다. 팀원 생성 시 프롬프트에 필요한 정보를 꽉 채워서 보내야 합니다.
4.  **세션 복구 불가**: In-process 모드에서 세션이 끊기면 팀원 상태 복구가 안 됩니다. 한 번에 끝낼 수 있을 때 실행하세요.

## 7. 요약표: Subagent vs Agent Team

| 구분 | Subagent (기존) | Agent Team (신기능) |
| :--- | :--- | :--- |
| **적합한 작업** | 단순 반복, 명확한 단일 작업 | 복잡한 문제 해결, 상호 검증, 병렬 연구 |
| **소통** | 메인 에이전트와만 소통 | 팀원끼리 대화 및 논쟁 가능 |
| **비용** | 낮음 (결과만 요약) | **높음** (각자 풀 컨텍스트 사용) |
| **추천** | "이 함수 짜줘", "이거 찾아줘" | "이 프로젝트 구조 싹 바꿔줘", "원인 불명 버그 잡아줘" |

---

## CodeTrust 프로젝트 - Agent Teams 구성 예시

CodeTrust 프로젝트는 **정적 분석, AI 코드 리뷰, 동적 분석(샌드박스), 보고서 생성**이라는 명확히 구분된 모듈을 가지고 있어 Agent Teams 패턴을 적용하기에 가장 이상적인 프로젝트입니다.

단일 에이전트가 순차적으로 처리하는 것보다, 각 분야 전문가 에이전트가 동시에 분석하고 결과를 합치는 방식이 훨씬 효율적이고 정밀합니다.

### 1. 팀 구조 설계 (The Squad)

**Team Lead (PM/Orchestrator)** 하에 4명의 전문 Teammate를 배치합니다.

| 역할 (Role) | 에이전트명 | 주요 임무 | 도구/권한 |
| :--- | :--- | :--- | :--- |
| **Team Lead** | `CodeTrust-PM` | 사용자 요청 접수, 각 팀원에게 작업 분배, 최종 보고서 취합 및 검수 | `read`, `write`, `exec` (전체 통제) |
| **Static Analyst** | `Scanner-Bot` | Semgrep/Tree-sitter 실행, AST 파싱, 위험 패턴(API 키, 주소 등) 추출 | `grep`, `semgrep`, `find` |
| **Logic Reviewer** | `Reviewer-AI` | 추출된 패턴의 '문맥'과 '의도' 분석. (이게 진짜 악성인지 판단) | `read` (코드 읽기 전용) |
| **Sandbox Eng** | `Dynamic-Tester` | (Phase 2) Docker/gVisor 환경 설정, 코드 격리 실행, 네트워크 로그 분석 | `docker`, `mitmproxy` |
| **Reporter** | `Tech-Writer` | 모든 분석 결과를 취합해 **"비개발자가 이해할 수 있는"** 한국어 보고서 작성 | `write` (Markdown/PDF 생성) |

### 2. CLAUDE.md 설정 예시 (Team Configuration)

프로젝트 루트의 `CLAUDE.md`에 아래 설정을 추가하여 `claude` 명령 실행 시 팀이 자동으로 구성되도록 돕습니다.

```markdown
# CLAUDE.md - CodeTrust Agent Team Config

## Agent Team Roles
- **Scanner-Bot**: You are a rigorous security researcher. Run static analysis tools (Semgrep) and find ALL potential risks. Do not filter false positives yet.
- **Reviewer-AI**: You are a senior developer. Read the code flagged by Scanner-Bot. Determine if it's malicious or benign based on context. Explain WHY.
- **Dynamic-Tester**: You are a sandbox engineer. Setup isolated environments. Never run user code on the host. Only inside Docker.
- **Tech-Writer**: You are a tech communicator. Translate technical findings into plain Korean for non-developers. Use analogies (e.g., "This acts like a wiretap").

## Common Instructions
- All internal communication must be concise.
- Final output must be in Korean.
- Respect the "Airbag" philosophy: We help judgment, we don't guarantee 100% safety.
```

### 3. 워크플로우 & 의존성 (Workflow)

이 팀은 **순차적(Sequential)** 작업과 **병렬(Parallel)** 작업이 혼합된 형태로 움직입니다.

1.  **[Lead]** 사용자로부터 분석 대상(Repo URL or Zip) 수신 → 압축 해제 및 구조 파악
2.  **[Lead]** `Scanner-Bot`에게 정적 분석 지시
3.  **[Scanner-Bot]** `semgrep`, `grep` 등으로 의심 파일/라인 리스트 추출 → **Task List**에 결과 업로드
4.  **[Lead]** `Reviewer-AI`에게 리스트 전달 ("이거 진짜 위험한지 봐줘")
5.  **[Reviewer-AI]** 코드 문맥 확인 후 '위험/의심/정상' 판정 → **Mailbox**로 Lead에게 보고
6.  **[Lead]** (선택) `Dynamic-Tester`에게 의심되는 실행 파일 격리 실행 지시
7.  **[Lead]** 모든 결과를 모아서 `Tech-Writer`에게 전달
8.  **[Tech-Writer]** 최종 리포트(`REPORT.md`) 작성

### 4. 실전 명령어 예시 (Wendy's Command)

웬디가 이 팀을 가동할 때 사용하는 명령어입니다.

```bash
# 1. 팀 생성 및 역할 부여 (자연어로 지시)
claude "CodeTrust 팀을 소집해. Scanner, Reviewer, Writer 3명으로 구성하고 현재 폴더의 'suspicious-app'을 분석해줘."

# 2. 특정 모듈 개발 시 (예: 정적 분석 규칙 추가)
claude "Scanner-Bot을 불러서 '카카오 비즈메시지 API'를 탐지하는 커스텀 Semgrep 규칙을 작성하고 테스트하게 해."

# 3. 전체 파이프라인 시뮬레이션
claude "Team Lead로서 지시해. 'sample-malware.js'를 분석해서 최종 한국어 보고서까지 만드는 전체 과정을 수행해봐."
```

### 5. 예상 비용 및 시간 (Token & Time)

Agent Teams는 단일 에이전트보다 토큰을 **3~4배** 더 소모합니다.

-   **예상 토큰**: 프로젝트당 약 100k ~ 300k 토큰 (분석 대상 크기에 비례)
-   **소요 시간**: 약 3분 ~ 10분 (병렬 처리로 시간은 단축되나, 상호 검증 대화로 인해 총량은 증가)
-   **권장 사항**:
    -   간단한 파일 1~2개는 그냥 단일 에이전트(`claude`) 사용
    -   **전체 프로젝트 검증**이나 **새로운 분석 규칙 개발** 시에만 Agent Teams 투입

### 6. Task List & Mailbox 활용 팁

-   **Task List**: 분석할 파일 목록(`files_to_scan.txt`)을 공유 자원으로 씁니다. Scanner가 목록을 만들면 Reviewer가 하나씩 지워가며 검토합니다.
-   **Mailbox**: 긴급한 발견(Backdoor 발견!) 시 즉시 Lead에게 알림을 보냅니다.

---
> 💡 **Tip for John**: 개발 초기 단계(Phase 0~1)에서는 **"규칙 개발 팀"**으로 운영하세요. Scanner 에이전트에게 규칙을 짜게 하고, Reviewer 에이전트에게 그 규칙으로 오탐(False Positive)을 찾게 시키면 혼자 하는 것보다 훨씬 빠르게 정교한 규칙을 만들 수 있습니다.

## 🍯 실전 꿀팁 (ddg.kang - AI Threads, 조회 1.6만)

> 출처: Threads @ddg.kang (2026-02-19)

### 꿀팁 1: 리더한테 코딩시키지 마세요 (작업 외주화)
- 팀모드에는 리더가 있고 팀원이 있다
- 리더 = 내가 직접 대화하는 메인 Claude
- **리더의 기억 공간이 전체 작전을 기억하는 유일한 곳**
- 여기서 코드까지 짜게 하면 기억이 순식간에 꽉 참
- "아까 뭐 하고 있었지?" 상태가 됨
- **리더는 전략만. 코딩은 전부 팀원한테.**
- 리더가 직접 하는 순간 팀 전체가 멍해진다

### 꿀팁 2: 기억을 파일에 쓰세요 (기억 외부화)
- Claude는 대화가 길어지면 오래된 내용을 자동으로 압축함
- 압축되면 아까 정한 것도 까먹음
- **중요한 결정 나올 때마다 파일에 바로 적게 시키세요**
- 기억을 날려도 이 파일만 읽으면 다시 돌아옴
- 추천: `decisions.md`에 중요한 것을 끊임없이 기록
- 안 하면 같은 논의를 3번 반복함. 당해봄.

### 꿀팁 3: 팀원은 쓰고 버리고 새로 뽑으세요 (계속 해고하기)
- 팀원도 일을 시키다 보면 기억이 꽉 참
- 꽉 차면 느려지고, 엉뚱한 코드를 짜기 시작함
- **작업 끝난 팀원은 해고하고, 새로 뽑으면서 이전 결과 요약만 넘겨주세요**
- 항상 머리가 깨끗한 팀원한테 시키는 것
- 속도랑 정확도가 동시에 올라감

### 🔄 간략한 워크플로우 (풀 자동화)
```
나 → 팀리더에게 일시킴
→ 팀리더가 4명의 팀원한테 리서치 시킴
→ 각 팀원이 심부름꾼 3~8개 병렬로 호출해서 리서치
→ 병렬로 약 심부름꾼 최대 30명이 동시에 리서치 (엄청 빠름)
→ 팀원들은 심부름꾼이 가져다준 리서치 자료로 서로 실시간 대화
→ 모든 작업이 끝나면 각 팀원이 보고서를 팀리더에게 제출
→ 팀리더가 종합해서 3가지 제안서를 나에게 보고
→ 내가 가장 좋은 것으로 승인
→ 팀리더가 기존 팀원 전원 해고
→ 새 팀원 4명 뽑아서 다시 일 시킴
→ 새 팀원들이 또 각각 심부름꾼 불러서 작업
→ 병렬로 심부름꾼 약 30명이 동시에 구현
→ 심부름꾼이 완료한 것들 각각 팀원이 검토
→ 그 후에 팀원이 팀리더에게 보고
→ 팀리더는 30명 심부름꾼이 구현한거 최종검토
→ 나에게 최종 보고 = 버그 하나도 없음
```

### 💡 자동화 트리거 프롬프트
> "팀모드에서 리더 기억 보존하면서 팀원 자동 교체하는 워크플로우 만들어줘"
> 이 한 줄이면 시작됨.

### 🔗 우리 환경(OpenClaw + 웬디)과의 연결
- **웬디 = 팀리더** (존과 대화 + 전략)
- **sub-agent = 팀원** (실제 작업 수행)
- **sessions_spawn = 새 팀원 채용** (매번 깨끗한 컨텍스트)
- **MEMORY.md / decisions.md = 기억 외부화** (이미 하고 있음!)
- 웬디의 기존 방식이 이 꿀팁과 정확히 일치하는 구조
