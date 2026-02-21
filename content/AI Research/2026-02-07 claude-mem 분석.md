---
tags: [type/research, ai/claude, ai/agents, ai/automation, status/completed]
created: 2026-02-07
---

# Claude-mem 분석

> **영상 출처**: [(추천 1위 plugin) claude mem으로 claude code 기억상실증 100% 해결하기](https://youtu.be/G25R0-mYcvE)
> **분석일**: 2026-02-07

---

## 🎯 핵심 요약

**Claude-mem**은 Claude Code의 "기억상실증"을 해결하는 플러그인이다. 세션이 종료되면 모든 컨텍스트가 사라지는 Claude Code의 한계를 극복하여, **세션 간 지속적인 메모리를 자동으로 관리**한다.

### 한 줄 정의
> AI가 작업한 모든 것을 자동 캡처 → AI로 압축 → 미래 세션에 관련 컨텍스트 자동 주입

### 핵심 가치
- 🧠 **세션 간 기억 유지**: 어제 한 작업을 오늘 이어서
- 📊 **토큰 효율성**: 10,000 토큰 → 500 토큰으로 압축 (~10x 절감)
- 🔍 **시맨틱 검색**: 자연어로 과거 작업 내역 검색
- 🤖 **완전 자동화**: 수동 개입 불필요

---

## 📦 상세 기능

### 1. 자동 관찰 및 압축
| 단계 | 설명 |
|------|------|
| **캡처** | 모든 도구 사용 (파일 읽기/쓰기, bash 명령 등) 자동 관찰 |
| **압축** | Claude Agent SDK로 1,000~10,000 토큰 → ~500 토큰으로 시맨틱 압축 |
| **분류** | decision, bugfix, feature, refactor, discovery, change 타입 자동 태깅 |
| **저장** | SQLite + FTS5 (Full-Text Search) 로컬 데이터베이스 |

### 2. 5개 라이프사이클 훅
```
SessionStart     → 이전 세션 컨텍스트 자동 주입
UserPromptSubmit → 사용자 쿼리 패턴 기록
PostToolUse      → 모든 도구 실행 결과 관찰
Stop             → 세션 요약 생성
SessionEnd       → 세션 저장 및 정리
```

### 3. MCP 검색 도구 (3-Layer Workflow)
```javascript
// Step 1: 인덱스 검색 (~50-100 토큰/결과)
search(query="authentication bug", type="bugfix", limit=10)

// Step 2: 타임라인 확인
timeline(observationId=123)

// Step 3: 필요한 것만 상세 조회 (~500-1,000 토큰/결과)
get_observations(ids=[123, 456])
```

### 4. 추가 기능
- **Web Viewer UI**: `http://localhost:37777`에서 실시간 메모리 스트림 확인
- **Folder CLAUDE.md**: 폴더별 활동 기록 자동 생성
- **Endless Mode (Beta)**: 장기 세션용 생체모방 메모리 아키텍처
- **Citation 시스템**: `claude-mem://` URI로 과거 관찰 참조

---

## 🛠️ 설치/사용법

### 시스템 요구사항
- Node.js 18.0.0+
- Claude Code (최신 버전, 플러그인 지원)
- Bun, uv (자동 설치됨)

### 설치 (2단계)
```bash
# Claude Code 터미널에서
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem

# Claude Code 재시작
```

### 설치 확인
```bash
# 훅 설정 확인
cat plugin/hooks/hooks.json

# 워커 서비스 상태 확인
curl http://localhost:37777/api/health

# 로그 확인
npm run worker:logs
```

### 데이터 저장 위치
```
~/.claude-mem/
├── claude-mem.db        # SQLite 데이터베이스
├── settings.json        # 설정 파일
├── .worker.pid          # 워커 프로세스 ID
├── .worker.port         # 워커 포트
└── logs/                # 로그 파일
```

### 주요 설정 (settings.json)
```json
{
  "CLAUDE_MEM_CONTEXT_OBSERVATIONS": 50,  // 세션 시작 시 주입할 관찰 수
  "CLAUDE_MEM_FOLDER_INDEX_ENABLED": true // 폴더별 CLAUDE.md 생성
}
```

---

## 🔑 핵심 명령어

### 자연어 검색 (Claude에게 직접)
- "인증 관련해서 뭐 결정했었지?"
- "API 레이어에서 수정한 버그들 보여줘"
- "데이터베이스 스키마 변경 이력"

### MCP 도구 직접 사용
| 도구 | 용도 |
|------|------|
| `search(query, type, limit)` | 메모리 인덱스 검색 |
| `timeline(observationId)` | 특정 관찰 주변 타임라인 |
| `get_observations(ids)` | 상세 정보 조회 (배치) |
| `save_memory(text, title)` | 수동 메모리 저장 |

### 워커 관리
```bash
npm run worker:start   # 워커 시작
npm run worker:stop    # 워커 중지
npm run worker:logs    # 로그 확인
npm run bug-report     # 버그 리포트 생성
```

---

## 🤔 Clawdbot/웬디 활용 가능성 분석

### Claude-mem vs 웬디 현재 시스템 비교

| 항목 | Claude-mem | 웬디 (현재) |
|------|-----------|------------|
| **대상** | Claude Code (터미널) | Clawdbot (멀티채널) |
| **저장 방식** | SQLite + FTS5 | Markdown 파일 (memory/*.md) |
| **압축** | AI 자동 압축 | 수동 정리 |
| **검색** | 시맨틱 + 키워드 | `memory_search` (시맨틱) |
| **주입** | 세션 시작 시 자동 | 수동 로드 (MEMORY.md) |
| **도구 관찰** | 모든 도구 자동 기록 | 직접 기록해야 함 |

### ✅ 적용 가능한 아이디어

1. **자동 도구 관찰 시스템**
   - 웬디가 사용하는 도구 (web_search, exec, browser 등) 결과를 자동으로 요약/저장
   - 현재: 중요하다고 판단될 때만 수동 기록
   - 개선: 모든 도구 사용을 백그라운드로 기록 → 나중에 검색 가능

2. **세션 시작 시 자동 컨텍스트 주입**
   - 현재: MEMORY.md + 일일 메모리 수동 로드
   - 개선: 관련 컨텍스트 자동 선별/주입 (토큰 효율적으로)

3. **대화 압축 및 저장**
   - 컨텍스트 오버플로우 전에 대화 내용을 AI로 압축 저장
   - 현재: 수동으로 요약하여 메모리에 기록
   - 개선: 자동 압축 + 구조화된 저장

4. **3-Layer Workflow 적용**
   - 메모리 검색 시 인덱스 → 필터 → 상세 조회
   - 토큰 절약 효과 극대화

### ⚠️ 직접 적용 불가능한 부분

1. **Claude Code 플러그인 시스템 의존**
   - claude-mem은 Claude Code의 lifecycle hooks에 의존
   - Clawdbot은 다른 아키텍처 (MCP 기반)

2. **Bun 워커 서비스**
   - 별도 포트(37777)에서 HTTP 서비스 운영
   - Clawdbot은 이미 gateway 데몬 구조 사용

---

## 💡 웬디 개선 방향 제안

### 단기 개선 (현재 시스템 내)

1. **도구 사용 자동 기록 루틴**
   ```markdown
   ## AGENTS.md에 추가
   ### 도구 사용 기록 규칙
   - web_search 결과 중 유용한 것 → memory/YYYY-MM-DD.md에 요약
   - 코딩 작업 완료 시 → 해당 프로젝트 파일에 결정사항 기록
   - 버그 수정 → know-debugging.md에 패턴 추가
   ```

2. **컨텍스트 자동 저장 강화**
   - 토큰 임박 시 자동 요약 저장 (현재 규칙 있음 → 실행 강화)

3. **메모리 인덱스 구조 개선**
   ```
   MEMORY.md (인덱스)
   ├── 🔑 핵심 컨텍스트 (즉시 로드)
   ├── 📁 주제별 포인터 (필요시 로드)
   └── 🕐 최근 활동 요약 (자동 업데이트)
   ```

### 중기 개선 (Clawdbot 기능 추가)

1. **자동 관찰 MCP 도구**
   - 도구 사용 후 자동으로 요약 생성/저장하는 MCP 서버
   - `memory_observe(tool, input, output)` → AI 압축 → 저장

2. **세션 시작 시 스마트 컨텍스트 주입**
   - 채널, 시간, 최근 주제 기반으로 관련 메모리 자동 선별
   - 토큰 예산 내에서 최적 조합

3. **대화 자동 요약 기능**
   - 긴 대화 → AI 압축 → 일일 메모리에 자동 추가
   - `sessions_summarize` 같은 도구

### 장기 비전

1. **Clawdbot Memory Service**
   - SQLite + 벡터 DB 하이브리드 저장소
   - 시맨틱 검색 + 키워드 검색 통합
   - 웹 UI로 메모리 브라우징

2. **멀티에이전트 메모리 공유**
   - 메인 에이전트 ↔ 서브에이전트 간 컨텍스트 공유
   - 작업 결과 자동 병합

---

## 📝 결론

### Claude-mem 평가
- **혁신성**: ⭐⭐⭐⭐⭐ (Claude Code의 핵심 한계 해결)
- **실용성**: ⭐⭐⭐⭐ (설치 쉬움, 자동 작동)
- **웬디 적용**: ⭐⭐⭐ (직접 사용 불가, 아이디어 차용 가능)

### 핵심 인사이트
> "모든 도구 사용을 관찰하고, AI로 압축하고, 나중에 검색 가능하게 하라"

이 원칙은 Clawdbot/웬디에도 적용 가능하다. 현재 수동으로 하는 메모리 관리를 점진적으로 자동화하면 된다.

### 즉시 실행 가능한 액션
1. ✅ 도구 사용 후 요약 기록 습관화
2. ✅ 일일 메모리에 대화 핵심 저장
3. ⏳ `memory_observe` 같은 자동화 도구 개발 검토
4. ⏳ Clawdbot에 세션 요약 기능 제안

---

## 🔗 참고 자료
- [GitHub: thedotmack/claude-mem](https://github.com/thedotmack/claude-mem)
- [공식 문서](https://docs.claude-mem.ai/)
- [Reddit 토론](https://www.reddit.com/r/ClaudeAI/comments/1oegbwo/how_is_claudemem_different_from_claudes_new/)
