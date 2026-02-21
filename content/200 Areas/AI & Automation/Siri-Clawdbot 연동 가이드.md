---
tags:
  - type/guide
  - ai/claude
  - ai/automation
  - dev/api
  - project/wendy
  - status/completed
created: 2026-02-07
---

# Siri-Clawdbot 연동 가이드

## 개요
iPhone/Apple Watch의 Siri에서 웬디(Clawdbot)를 호출하는 방법

## 기술 스택
| 항목 | 기술 |
|------|------|
| AI 백엔드 | Clawdbot Gateway |
| 모델 | Claude 3.5 Haiku (빠른 응답) |
| 네트워크 | Tailscale (VPN) |
| 인터페이스 | iOS 단축어 앱 |
| 프로토콜 | OpenAI-compatible REST API |

## 아키텍처
```
Siri → iOS 단축어 → HTTPS POST → Tailscale → Clawdbot Gateway → Claude API → 응답
```

## 설정 방법

### 1. Tailscale 설정
- iPhone에 Tailscale 앱 설치 및 로그인
- 같은 Tailnet에 Clawdbot PC 연결 확인
- Tailscale Serve 활성화 (Gateway HTTPS 노출)

### 2. Clawdbot siri 에이전트 설정
`clawdbot.json`에 siri 에이전트 추가:
```json
{
  "id": "siri",
  "name": "Siri 웬디",
  "workspace": "C:\\Users\\phase\\clawd",
  "model": "anthropic/claude-3-5-haiku-latest",
  "identity": {
    "name": "웬디",
    "emoji": "🌸"
  },
  "tools": {
    "deny": ["browser", "canvas", "nodes", "cron", "sessions_spawn"]
  }
}
```

### 3. iOS 단축어 설정

#### 단축어 구성
1. **텍스트 받아쓰기** - Siri 음성 입력
2. **텍스트** (Body JSON):
```json
{"model":"claude-3-5-haiku-latest","messages":[{"role":"user","content":"받아쓰기한 텍스트"}],"user":"siri:john"}
```
3. **URL**: `https://wendy.tail9938b1.ts.net/v1/chat/completions?agent=siri`
4. **Method**: POST
5. **Headers**:
   - `Authorization`: `Bearer {gateway_token}`
   - `Content-Type`: `application/json`
6. **URL 콘텐츠 가져오기**
7. **JSON 파싱**: `choices` → 첫 번째 항목 → `message.content`
8. **결과 말하기**

### 4. 인증 토큰
Gateway 설정에서 토큰 확인:
```json
"gateway": {
  "auth": {
    "mode": "token",
    "token": "your-token-here",
    "allowTailscale": true
  }
}
```

## 주의사항
- ⚠️ `?agent=siri` 라우팅이 현재 버그로 작동 안 함
- ✅ Body에 `model` 직접 지정하면 해당 모델 사용
- iPhone Tailscale 연결 필수

## 트러블슈팅
| 문제 | 해결 |
|------|------|
| 연결 안 됨 | iPhone Tailscale 연결 확인 |
| Opus로 응답 | Body에 model 필드 명시 |
| 느린 응답 | Haiku 모델 사용 확인 |

---
*관련: [[웬디 아바타 프로젝트]] [[Clawdbot 설정]]*
