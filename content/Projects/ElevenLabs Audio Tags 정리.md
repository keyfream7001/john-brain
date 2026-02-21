---
tags: [type/reference, ai/tts, media/voice, project/wendy, status/completed]
created: 2026-02-04
---

# 🎤 ElevenLabs Audio Tags 정리

> v3 모델 전용 — 현재 웬디 아바타는 Multilingual v2 사용 중, v3 전환 시 활용

---

## 핵심 태그 목록

### 😊 감정
`[excited]` `[nervous]` `[frustrated]` `[sorrowful]` `[calm]` `[tired]` `[angry]`

### 🗣️ 반응/비언어
`[sigh]` `[laughs]` `[laughs harder]` `[gulps]` `[gasps]` `[whispers]` `[SHOUTING]`

### 🧠 인지적
`[pauses]` `[hesitates]` `[stammers]` `[resigned tone]`

### 🎭 톤/말투
`[cheerfully]` `[flatly]` `[deadpan]` `[playfully]` `[sarcastically]` `[dramatically]` `[matter-of-fact]` `[whiny]`

### 🌍 악센트/캐릭터
`[British accent]` `[American accent]` `[French accent]` `[pirate voice]` `[childlike tone]`

---

## 사용법

텍스트 앞에 태그를 붙여서 사용:
```
[sorrowful] I couldn't sleep that night.
[dramatic][French accent] You do not understand.
```

- 조합 가능 (여러 태그 동시 사용)
- 재생성마다 결과가 다를 수 있음

---

## ⚠️ 주의사항
- **v3 모델 전용** — Multilingual v2에서는 작동하지 않음
- PVC(Professional Voice Cloning)는 v3에 미최적화

---

## 🎭 웬디 아바타 적용 계획

### 현재 방식 (v2)
- `next_text` 파라미터로 감정 스티어링
- `stability` 값 조절 (감정별 0.15~0.30)

### 향후 계획 (v3 전환 시)
- `emotion-detector.ts`에서 감정 → Audio Tag 매핑 추가
- 예: happy → `[cheerfully]`, sad → `[sorrowful]`, angry → `[frustrated]`
- 더 풍부하고 자연스러운 감정 표현 가능

---

## 관련 노트
- [[웬디 아바타 프로젝트]]
