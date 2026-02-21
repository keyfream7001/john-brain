---
created: 2026-02-20
type: guide
tags:
  - type/guide
  - dev/python
  - ai/automation
  - status/unread
  - priority/medium
---

# 🖥️ 로컬 AI 서버 도구 가이드 — RTX 3060 12GB 업그레이드 시

> GTX 1060 6GB → RTX 3060 12GB로 업그레이드했을 때 새로 가능해지는 도구들

## 🆕 12GB에서 새로 가능해지는 것들

### 이미지 생성
| 도구 | VRAM | 용도 |
|------|------|------|
| FLUX.1 dev GGUF | ~8-10GB | 현재 최고 품질 이미지 생성 |
| FLUX.1-Kontext | ~10-11GB | AI 이미지 편집 (배경교체, 오브젝트 제거) |
| SDXL 1.0 + ControlNet | ~6-8GB | 고품질 이미지 + 포즈/구도 제어 |
| SD 3.5 Medium/Large | ~6-9GB | SD 최신 아키텍처, 텍스트 정확도 개선 |

### 영상 생성 (6GB에서는 불가능했음!)
| 도구 | VRAM | 용도 |
|------|------|------|
| LTX-Video 2 | ~12GB | 텍스트/이미지→비디오 (공식 최소 12GB) |
| Wan 2.1 (1.3B) | ~8-10GB | 고품질 비디오 생성 |
| CogVideoX 5B | ~12GB | 6초 720x480 비디오 |

### 로컬 LLM (6GB에서는 7B Q4만 가능했음)
| 도구 | VRAM | 용도 |
|------|------|------|
| Qwen2.5-Coder 14B Q6 | ~11-12GB | 코딩 AI (20+ TPS) |
| DeepSeek R1 Distill 14B Q4 | ~8-10GB | GPT-4급 추론 |
| Llama 3.1 8B Q8 | ~8GB | 고품질 양자화 범용 LLM |

### 음성/음악
| 도구 | VRAM | 용도 |
|------|------|------|
| F5-TTS | ~2-4GB | 3초 샘플로 음성 클론 |
| Orpheus-TTS 3B | ~6-8GB | 감정 표현 TTS |
| MusicGen Large | ~10-12GB | 고품질 BGM 생성 |

### 멀티모달
| 도구 | VRAM | 용도 |
|------|------|------|
| Qwen2.5-VL 7B | ~6-7GB | 이미지 분석, 문서 OCR |
| InternVL2.5 8B | ~8-10GB | 차트/수식 파싱 |

## 핵심 차이점
- **6GB**: 도구 1개씩만 단독 실행
- **12GB**: 복수 모델 동시 메모리 상주 가능 (TTS + STT + 경량 도구 동시)
- **영상 생성**: 6GB에서 불가 → 12GB에서 가능
- **LLM**: 7B → 14B급으로 품질 대폭 향상

---

**관련 문서**: [[로컬 AI 서버 도구 가이드 - GTX 1060 6GB]]
**작성일**: 2026-02-20
