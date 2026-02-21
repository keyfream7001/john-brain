---
created: 2026-02-21
tags:
  - type/research
  - dev/openclaw
  - ai/agents
  - status/completed
---

# OpenClaw Cerebras 모델 호환성 분석

## 요약

OpenClaw에서 Cerebras 모델 사용 시 일부 모델이 400 에러를 반환하는 원인 분석 및 해결방법 정리.

---

## 🔍 문제 현상

- `cerebras/gpt-oss-120b` (alias: `cerebras70b`) → ✅ 정상 작동
- `cerebras/llama3.1-8b` (alias: `cerebras8b`) → ❌ 400 에러 발생

**에러 메시지 (OpenClaw 로그):**
```
embedded run start: provider=cerebras model=llama3.1-8b thinking=low → isError=true
run error: 400 status code (no body)
```

---

## 🧪 직접 API 테스트 결과

Cerebras API 직접 호출 시:
- `llama3.1-8b` 일반 요청 → ✅ 200 OK
- `llama3.1-8b` 스트리밍 요청 → ✅ 200 OK
- `llama3.1-8b` + tools 파라미터 → ✅ 200 OK

→ **Cerebras API 자체는 정상**. OpenClaw 내부 문제.

---

## 💡 원인 분석

OpenClaw가 세션 레벨의 `thinking=low` 설정을 **모든 모델에 전달**함.  
`cerebras/llama3.1-8b`는 이 파라미터를 처리하지 못해 400 에러 반환.  
`gpt-oss-120b`는 같은 파라미터를 무시하거나 다르게 처리함.

---

## 🔧 OpenClaw 설정 조사 결과

`ModelCompatSchema`에서 지원하는 thinking 관련 설정:
```json
"compat": {
  "thinkingFormat": "openai" | "zai" | "qwen",
  "requiresThinkingAsText": true
}
```

→ 이건 thinking **형식 변환**용. thinking을 끄는 플래그 **없음**.

`noThinking` 파라미터 → **OpenClaw에서 미지원** (소스코드 확인)

---

## ✅ 현재 해결 방법

### 즉시 사용 가능
1. `/thinking off` 입력 후 `cerebras/llama3.1-8b` 전환
2. **그냥 `cerebras70b` (120b)만 사용** ← 가장 현실적

### 근본 해결 (미지원)
- OpenClaw에 per-model thinking 비활성화 기능 없음
- GitHub 이슈 제출 완료 (웬디가 올림)

---

## 📊 Cerebras 모델 현황 (2026-02-21)

| 모델 ID | OpenClaw alias | API 작동 | OpenClaw 작동 | 비고 |
|---------|----------------|----------|---------------|------|
| `gpt-oss-120b` | `cerebras70b` | ✅ | ✅ | 정상 |
| `llama3.1-8b` | `cerebras8b` | ✅ | ❌ | thinking 파라미터 충돌 |
| `qwen-3-235b-a22b-instruct-2507` | 없음 | ✅ | 미등록 | 추가 가능 |
| `zai-glm-4.7` | 없음 | ✅ | 미등록 | 추가 가능 |

---

## 🆕 Cerebras 신규 모델 추가 방법

`~/.openclaw/openclaw.json` → `models.providers.cerebras.models` 배열에 추가:

```json
{
  "id": "qwen-3-235b-a22b-instruct-2507",
  "name": "Qwen3 235B (Cerebras)",
  "input": ["text"],
  "cost": { "input": 0, "output": 0 },
  "contextWindow": 131072,
  "maxTokens": 16384
}
```

---

## 🔗 관련

- [[OpenClaw 설정]]
- GitHub Issue: openclaw/openclaw (웬디 제출, 2026-02-21)
