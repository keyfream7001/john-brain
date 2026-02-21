---
tags: [type/guide, ai/claude, project/wendy, ai/automation, status/completed]
created: 2026-02-07
---

# Siri → 웬디 연동 설정

## 개요
아이폰 Siri에서 음성으로 웬디(Clawdbot)를 호출하는 설정.
Tailscale VPN을 통해 PC의 Clawdbot Gateway에 연결.

## 필수 조건
- [ ] PC에서 Clawdbot 실행 중
- [ ] Tailscale 연결 (PC & iPhone 모두)
- [ ] iPhone 단축어 앱

## 단축어 설정

### 1. 텍스트 받아쓰기
음성 입력을 텍스트로 변환

### 2. 텍스트 블록 (JSON Body)
```json
{"model":"claude-3-5-haiku-latest","messages":[{"role":"user","content":"받아쓰기한 텍스트"}],"user":"siri:john"}
```

### 3. URL
```
https://wendy.tail9938b1.ts.net/v1/chat/completions?agent=siri
```

### 4. URL 콘텐츠 가져오기
- **메소드**: POST
- **헤더**:
  - `Authorization`: `Bearer 0d71260016702a84741d7ecdfe2fdb80a8018c51311f257f`
  - `Content-Type`: `application/json`
- **본문**: 텍스트 블록 연결

### 5. 사전에서 값 가져오기
- 키: `choices`의 첫 번째 → `message` → `content`
- 또는 응답 전체를 파싱

### 6. 결과 표시/읽어주기

## Clawdbot 설정

### siri 에이전트 (config.yaml)
```yaml
agents:
  list:
    - id: siri
      name: "Siri 웬디"
      model: anthropic/claude-3-5-haiku-latest  # 빠른 응답
      tools:
        deny: [browser, canvas, nodes, cron, sessions_spawn]
```

## 모델 선택
| 모델 | 속도 | 품질 |
|------|------|------|
| Haiku | ⚡ 매우 빠름 | 일반 대화 OK |
| Sonnet | 🚀 빠름 | 복잡한 질문 OK |
| Opus | 🐢 느림 | 최고 품질 |

**Siri용 추천**: Haiku (빠른 응답이 중요)

## 트러블슈팅

### "호스트를 찾을 수 없습니다"
- iPhone Tailscale 앱 연결 확인
- Tailscale DNS (MagicDNS) 활성화 확인

### "요청 시간 초과"
- PC가 켜져 있는지 확인
- Clawdbot Gateway 실행 중인지 확인
- `tailscale serve status`로 serve 상태 확인

### Tailscale 도메인 확인
```powershell
tailscale serve status
```

## 사용법
1. "Siri야, 웬디 호출" (또는 단축어 이름)
2. 질문 말하기
3. 웬디 응답 받기

---
*2026-02-07 설정 완료*
