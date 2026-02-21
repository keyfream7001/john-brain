---
created: 2026-02-20
type: guide
tags:
  - type/guide
  - dev/python
  - ai/automation
  - status/inProgress
  - priority/high
---

# 🖥️ 로컬 AI 서버 도구 가이드 — GTX 1060 6GB

> 놀고 있는 PC를 AI 서버로 활용! Qwen TTS처럼 FastAPI 서버로 띄워서 메인 PC에서 API로 호출하는 방식.

## 서버 PC 사양

| 항목 | 스펙 |
|------|------|
| PC 이름 | DESKTOP-7NMI73N |
| CPU | Intel i9-9900K (16스레드, 3.6GHz) |
| RAM | 32GB |
| GPU | NVIDIA GTX 1060 6GB (VRAM 6029MB) |
| OS | Windows 11 Pro |
| IP | 192.168.0.2 (로컬 네트워크) |

## 현재 구동 중

- **Qwen3-TTS 1.7B** (포트 7860, VRAM ~3.4GB)
  - 용도: 텍스트를 존의 목소리로 변환 (음성 클론)
  - 가이드: [[Qwen3-TTS 완전 가이드]]

---

## 🔥 최우선 추천 도구 TOP 5

### 1. faster-whisper (음성→텍스트 변환) ★★★★★
- **깃허브**: https://github.com/SYSTRAN/faster-whisper
- **VRAM**: large-v3 int8 ~2.5GB / medium ~1.5GB
- **Qwen TTS 동시 구동**: ✅ (합산 ~5.9GB)
- **뭘 할 때 쓰나?**
  - 유튜브 영상에 자동 자막 생성 (SRT/VTT)
  - 회의/강의 녹음을 텍스트로 변환
  - 음성 메모를 텍스트로 기록
  - 실시간 STT (음성 입력 인터페이스)
  - WhisperX 연동하면 화자 분리(누가 말했는지)도 가능
- **활용 예시**: 유튜브 영상 제작 시 TTS로 음성 생성 → Whisper로 타임스탬프 자막 자동 생성 → Remotion에서 자막 오버레이

### 2. Real-ESRGAN (이미지/영상 업스케일링) ★★★★★
- **깃허브**: https://github.com/xinntao/Real-ESRGAN
- **VRAM**: ~1.5GB (tile 처리로 VRAM 절약)
- **Qwen TTS 동시 구동**: ✅ (합산 ~4.9GB)
- **뭘 할 때 쓰나?**
  - AI 생성 이미지를 4배 고해상도로 업스케일
  - 오래된 사진/스크린샷 화질 개선
  - 유튜브 영상용 이미지 퀄리티 업
  - 저화질 영상 프레임별 업스케일 (느리지만 가능)
- **활용 예시**: SD로 생성한 512x512 이미지 → Real-ESRGAN으로 2048x2048 고화질로

### 3. Stable Diffusion 1.5 + WebUI Forge (이미지 생성) ★★★★★
- **깃허브**: https://github.com/lllyasviel/stable-diffusion-webui-forge
- **VRAM**: ~4.5GB (fp16)
- **Qwen TTS 동시 구동**: ❌ (단독 사용, TTS 내리고)
- **뭘 할 때 쓰나?**
  - 텍스트 프롬프트로 이미지 생성 (txt2img)
  - 기존 이미지를 AI로 변환 (img2img)
  - 이미지 일부분만 AI로 수정 (inpainting)
  - ControlNet으로 포즈/구도 제어
  - 유튜브 썸네일, SNS 이미지, 블로그 삽화 제작
- **활용 예시**: Project YAS에서 스토리보드 이미지 자동 생성
- **참고**: `--api` 플래그로 REST API 서버 활성화 → 메인 PC에서 호출

### 4. rembg (배경 제거) ★★★★★
- **깃허브**: https://github.com/danielgatis/rembg
- **VRAM**: ~0.5~1GB
- **Qwen TTS 동시 구동**: ✅ (합산 ~4.4GB)
- **뭘 할 때 쓰나?**
  - 사진에서 배경 자동 제거 → 투명 PNG
  - 제품 사진 배경 깔끔하게 날리기
  - 썸네일 제작 시 인물 따기
  - 합성 이미지 제작
- **활용 예시**: 유튜브 썸네일에서 인물만 따서 배경 교체

### 5. PaddleOCR (이미지에서 텍스트 추출) ★★★★★
- **깃허브**: https://github.com/PaddlePaddle/PaddleOCR
- **VRAM**: ~2GB (GPU) / CPU로도 가동 가능
- **Qwen TTS 동시 구동**: ✅ (합산 ~5.4GB)
- **뭘 할 때 쓰나?**
  - 스크린샷/사진에서 텍스트 자동 추출
  - PDF 스캔본을 검색 가능한 텍스트로 변환
  - 명함, 영수증, 문서 자동 인식
  - 한국어/영어/일본어/중국어 지원
- **활용 예시**: 카카오톡 스크린샷에서 대화 내용 텍스트 추출

---

## 추천 도구 (상황에 따라)

### 6. sentence-transformers (텍스트 임베딩/검색) ★★★★★
- **깃허브**: https://github.com/huggingface/sentence-transformers
- **VRAM**: ~0.5~2GB
- **Qwen TTS 동시 구동**: ✅
- **뭘 할 때 쓰나?**
  - 텍스트를 벡터로 변환 → 유사도 검색 (RAG)
  - 문서 검색 시스템 구축
  - 추천 시스템 (비슷한 콘텐츠 찾기)
- **추천 모델**: `intfloat/multilingual-e5-large` (한국어), `BAAI/bge-m3`

### 7. GFPGAN (얼굴 복원/향상) ★★★★☆
- **깃허브**: https://github.com/TencentARC/GFPGAN
- **VRAM**: ~2.5GB
- **Qwen TTS 동시 구동**: ✅ (합산 ~5.9GB)
- **뭘 할 때 쓰나?**
  - 흐릿한 사진의 얼굴 선명하게 복원
  - AI 생성 이미지의 얼굴 디테일 개선
  - 오래된 가족사진 복원
- **활용 예시**: Real-ESRGAN + GFPGAN 조합으로 이미지 전체 업스케일 + 얼굴 집중 복원

### 8. YOLOv11 (객체 탐지) ★★★★★
- **깃허브**: https://github.com/ultralytics/ultralytics
- **VRAM**: nano/small ~0.5~1GB
- **Qwen TTS 동시 구동**: ✅
- **뭘 할 때 쓰나?**
  - 이미지/영상에서 사물 자동 인식 (사람, 차, 동물 등)
  - 실시간 CCTV 모니터링
  - 이미지 자동 태깅/분류

### 9. InsightFace (얼굴 인식/교체) ★★★★☆
- **깃허브**: https://github.com/deepinsight/insightface
- **VRAM**: ~2~3GB
- **Qwen TTS 동시 구동**: ✅ (합산 ~5.5GB)
- **뭘 할 때 쓰나?**
  - 사진에서 얼굴 탐지/인식
  - 얼굴 교체 (FaceSwap)
  - 나이/성별 추정

### 10. Kokoro-82M TTS (영어 음성) ★★★★☆
- **깃허브**: https://github.com/remsky/Kokoro-FastAPI
- **VRAM**: ~0.5GB 미만 (또는 CPU)
- **Qwen TTS 동시 구동**: ✅
- **뭘 할 때 쓰나?**
  - 영어 내레이션 생성 (자연스러운 품질)
  - 영어 유튜브 콘텐츠용 TTS
  - Qwen TTS는 한국어, Kokoro는 영어로 분담

### 11. Opus-MT / NLLB-200 (번역) ★★★★☆
- **깃허브**: https://github.com/Helsinki-NLP/Opus-MT
- **VRAM**: ~0.5~2GB
- **Qwen TTS 동시 구동**: ✅
- **뭘 할 때 쓰나?**
  - 완전 로컬 번역 (개인정보 걱정 없음)
  - 대량 번역 작업 (API 비용 0원)
  - 200개 언어 지원 (NLLB)

### 12. MusicGen-small (음악 생성) ★★★☆☆
- **깃허브**: https://github.com/facebookresearch/audiocraft
- **VRAM**: small(300M) ~3.5GB
- **Qwen TTS 동시 구동**: ⚠️ 아슬아슬
- **뭘 할 때 쓰나?**
  - 텍스트 프롬프트로 배경음악 생성
  - 유튜브 영상 BGM 제작
  - 30초 단위 생성 (제한적)

### 13. RVC (음성 변환) ★★★★☆
- **깃허브**: https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI
- **VRAM**: ~3.5GB
- **Qwen TTS 동시 구동**: ⚠️ (TTS 내리고 사용 권장)
- **뭘 할 때 쓰나?**
  - 내 목소리를 다른 사람 목소리로 변환
  - AI 캐릭터 보이스 제작
  - TTS 출력물 → RVC로 음색 변환 파이프라인

---

## 🎬 전용 모드 도구 (Qwen TTS 중지 후 사용)

### FLUX.1-schnell GGUF (고품질 이미지 생성) ★★★★☆
- **VRAM**: ~5.5~6.4GB (Q4_0)
- SD보다 자연스럽고 텍스트 렌더링 강점
- ComfyUI에서 API 서버로 호출 가능
- GTX 1060은 Pascal이라 느림 (20~60초/장)

### AnimateDiff (이미지→영상) ★★★☆☆
- **VRAM**: ~5~6GB
- SD 1.5 기반 짧은 루프 영상 생성
- 16~24프레임, 512x512

### LTX-Video int8 (텍스트→영상) ★★★☆☆
- **VRAM**: ~6GB
- 최신 비디오 생성 모델
- 생성 시간 수십 분 (매우 느림)

---

## 📊 VRAM 요약표

| 도구 | VRAM | TTS 동시 | 용도 한줄 |
|------|------|----------|----------|
| faster-whisper (large-v3) | ~2.5GB | ✅ | 음성→텍스트 |
| Real-ESRGAN | ~1.5GB | ✅ | 이미지 업스케일 |
| rembg | ~1GB | ✅ | 배경 제거 |
| PaddleOCR | ~2GB | ✅ | 이미지→텍스트 |
| sentence-transformers | ~1GB | ✅ | 텍스트 임베딩 |
| Kokoro TTS | ~0.5GB | ✅ | 영어 음성 |
| YOLOv11 | ~0.5GB | ✅ | 객체 탐지 |
| GFPGAN | ~2.5GB | ✅ | 얼굴 복원 |
| InsightFace | ~2GB | ✅ | 얼굴 인식 |
| Opus-MT | ~1GB | ✅ | 번역 |
| SD 1.5 Forge | ~4.5GB | ❌ | 이미지 생성 |
| FLUX.1 GGUF | ~6GB | ❌ | 고품질 이미지 |
| MusicGen-small | ~3.5GB | ⚠️ | 음악 생성 |
| RVC | ~3.5GB | ⚠️ | 음성 변환 |

---

## 💡 운영 전략

### 상시 구동 추천 조합
Qwen TTS (3.4GB) + faster-whisper medium (1.5GB) = **4.9GB**
→ 나머지 도구는 on-demand로 로드/언로드

### 이미지 작업 모드
Qwen TTS 중지 → SD 1.5 Forge (4.5GB) + Real-ESRGAN (1.5GB) = **6GB**

### 서버 구성 방식
모든 도구를 FastAPI 서버로 감싸서 포트별로 관리:
- 7860: Qwen TTS
- 7861: faster-whisper
- 7862: Real-ESRGAN
- 7863: rembg
- 7864: PaddleOCR
- ...

메인 PC(웬디)에서 HTTP API로 호출 → 결과 수신

---

**관련 문서**: [[Qwen3-TTS 완전 가이드]] [[Project YAS - 유튜브 자동화 시스템 기획서]]
**작성일**: 2026-02-20
