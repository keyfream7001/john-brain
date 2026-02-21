---
tags: [type/reference, media/live2d, project/wendy, status/completed]
created: 2026-02-04
---

# 🎨 Live2D 무료 모델 소스 정리

> 웬디 아바타 프로젝트용 Live2D 모델 소싱 조사 결과

---

## ⭐ 추천 순위 TOP 5

### 1. Live2D 공식 샘플 ⭐⭐⭐⭐⭐
- **URL**: https://www.live2d.com/en/learn/sample/
- **모델 수**: 20+개 (Hiyori, Kei, Ren Foster 등)
- **Cubism**: 4/5 (최신)
- **라이센스**: 소규모 상업적 사용 가능
- **pixi-live2d-display**: ✅ 완벽 호환
- 모션/표정/물리 풀세트 포함

### 2. BOOTH (무료 필터) ⭐⭐⭐⭐⭐
- **URL**: https://booth.pm/en/search/free%20live2d
- **모델 수**: 1,300+개
- **Cubism**: 3/4
- **라이센스**: 개별 확인 필수
- **추천 모델**: ShiraLive2D Lisette, enximadesign 모델들

### 3. GitHub: Eikanya/Live2d-model ⭐⭐⭐⭐
- **URL**: https://github.com/Eikanya/Live2d-model (⭐2.9k)
- **모델 수**: 수백개 (게임 추출 중심)
- **Cubism**: 2/3 혼합
- **라이센스**: ⚠️ 비상업적 사용만

### 4. pixi-live2d-display 내장 샘플 ⭐⭐⭐⭐
- **즉시 테스트 가능 URL**:
  - Shizuku (Cubism 2): `https://cdn.jsdelivr.net/gh/guansss/pixi-live2d-display/test/assets/shizuku/shizuku.model.json`
  - Haru (Cubism 4): `https://cdn.jsdelivr.net/gh/guansss/pixi-live2d-display/test/assets/haru/haru_greeter_t03.model3.json`
- CORS 문제 없음, URL만 넣으면 바로 동작

### 5. Ko-fi 마켓 ⭐⭐⭐
- **URL**: https://ko-fi.com (검색: "free live2d model")
- **추천**: Ameji Studio AS01 (7,298개 판매), Miyu Customizable

---

## 기타 소스

| 소스 | URL | 특징 |
|------|-----|------|
| ShiraLive2D | shiralive2d.com | 풀바디 고퀄, 학습/테스트용 |
| itch.io | itch.io/misc/free/tag-live2d | 인디 크리에이터 30+개 |
| nizima | nizima.com | Live2D 공식 마켓, 소수 무료 |
| Bilibili | bilibili.com | 중국 커뮤니티, 접근성 낮음 |
| Reddit | r/Live2D | 주기적 무료 모델 공유 |

---

## 라이센스 요약

| 소스 | 개인 사용 | 상업적 사용 | 수정/재배포 |
|------|----------|-----------|-----------|
| Live2D 공식 | ✅ | ✅ (소규모) | ⚠️ 조건부 |
| BOOTH | ✅ | ⚠️ 개별확인 | ⚠️ 개별확인 |
| GitHub 컬렉션 | ✅ | ❌ 대부분 불가 | ⚠️ |
| Ko-fi | ✅ | ⚠️ 개별확인 | ⚠️ 개별확인 |

---

## 🎯 전략

### 즉시 개발/테스트용
1. pixi-live2d-display CDN 모델 (URL만 넣으면 됨)
2. Live2D 공식 샘플 (현재 Hiyori 사용 중)

### 커스텀 모델 확보
1. BOOTH에서 무료 모델 탐색
2. Ko-fi에서 고퀄리티 모델 확인
3. 최종 목표: 웬디 전용 커스텀 Live2D 모델 제작

---

## 관련 노트
- [[웬디 아바타 프로젝트]]
