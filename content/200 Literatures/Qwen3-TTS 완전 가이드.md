---
type: guide
aliases:
  - Qwen TTS
  - 큰3 TTS
  - 알리바바 TTS
author: "[[John]]"
date created: 2026-02-08
tags:
  - type/guide
  - status/inProgress
  - ai/tts
  - ai/voice
  - dev/python
  - media/youtube
  - priority/high
status: inProgress
source: https://youtu.be/DJDgCk8v2JI
---

# Qwen3-TTS 완전 가이드

> 📺 **출처**: [녹음 없이 유튜브 하는 법 - Qwen3 TTS + 클로드 코드 스킬 완전 정복](https://youtu.be/DJDgCk8v2JI)

## 📌 개요

**Qwen3-TTS**는 알리바바 Qwen 팀이 개발한 최신 오픈소스 AI 음성 생성 모델이다.

### 핵심 특징
- **10개 언어 지원**: 한국어, 영어, 일본어, 중국어, 독일어, 프랑스어, 러시아어, 포르투갈어, 스페인어, 이탈리아어
- **97ms 초저지연**: 실시간 스트리밍 생성 가능
- **3가지 핵심 기능**:
  1. **Custom Voice**: 9개 프리셋 음성 사용
  2. **Voice Design**: 자연어 설명으로 음성 디자인
  3. **Voice Clone**: 3초 오디오로 음성 복제

---

## 🎭 모델 종류

| 모델 | 기능 | 스트리밍 | 명령어 제어 |
|------|------|:--------:|:-----------:|
| **1.7B-VoiceDesign** | 자연어 기반 음성 디자인 | ✅ | ✅ |
| **1.7B-CustomVoice** | 9개 프리셋 + 스타일 제어 | ✅ | ✅ |
| **1.7B-Base** | 3초 음성 복제 | ✅ | ❌ |
| **0.6B-CustomVoice** | 9개 프리셋 (경량) | ✅ | ❌ |
| **0.6B-Base** | 음성 복제 (경량) | ✅ | ❌ |

### 프리셋 음성 목록
| 스피커 | 설명 | 네이티브 언어 |
|--------|------|---------------|
| Sohee | 따뜻하고 감정 풍부한 여성 | 🇰🇷 한국어 |
| Vivian | 밝고 날카로운 젊은 여성 | 🇨🇳 중국어 |
| Serena | 따뜻하고 부드러운 여성 | 🇨🇳 중국어 |
| Ryan | 역동적인 남성 | 🇺🇸 영어 |
| Aiden | 맑은 미국 남성 | 🇺🇸 영어 |
| Ono_Anna | 장난기 있는 여성 | 🇯🇵 일본어 |

---

## 🛠️ 설치 방법

### 1. 환경 설정 (Conda)
```bash
# Python 3.12 환경 생성
conda create -n qwen3-tts python=3.12 -y
conda activate qwen3-tts

# qwen-tts 패키지 설치
pip install typing_extensions && pip install -U qwen-tts
```

### 2. FlashAttention 2 (권장 - GPU 메모리 절약)
```bash
pip install wheel && pip install -U flash-attn --no-build-isolation
```

### 3. 소스에서 설치 (개발용)
```bash
git clone https://github.com/QwenLM/Qwen3-TTS.git
cd Qwen3-TTS
pip install -e .
```

---

## 💻 사용 예제

### Custom Voice (프리셋 음성)
```python
import torch
import soundfile as sf
from qwen_tts import Qwen3TTSModel

model = Qwen3TTSModel.from_pretrained(
    "Qwen/Qwen3-TTS-12Hz-1.7B-CustomVoice",
    device_map="cuda:0",
    dtype=torch.bfloat16,
    attn_implementation="flash_attention_2",
)

wavs, sr = model.generate_custom_voice(
    text="안녕하세요! Qwen3-TTS로 생성한 한국어 음성입니다.",
    language="Korean",
    speaker="Sohee",
    instruct="기분 좋은 목소리로",
)
sf.write("output.wav", wavs[0], sr)
```

### Voice Design (자연어 음성 디자인)
```python
model = Qwen3TTSModel.from_pretrained(
    "Qwen/Qwen3-TTS-12Hz-1.7B-VoiceDesign",
    device_map="cuda:0",
    dtype=torch.bfloat16,
)

wavs, sr = model.generate_voice_design(
    text="오빠! 오늘 진짜 고생 많았어요!",
    language="Korean",
    instruct="귀여운 여동생 목소리, 애교 있는 말투",
)
sf.write("voice_design.wav", wavs[0], sr)
```

### Voice Clone (음성 복제)
```python
model = Qwen3TTSModel.from_pretrained(
    "Qwen/Qwen3-TTS-12Hz-1.7B-Base",
    device_map="cuda:0",
    dtype=torch.bfloat16,
)

wavs, sr = model.generate_voice_clone(
    text="This is cloned voice speaking.",
    language="English",
    ref_audio="reference.wav",  # 3초 참조 오디오
    ref_text="참조 오디오의 전사 텍스트",
)
sf.write("cloned.wav", wavs[0], sr)
```

---

## 🎬 유튜브 활용법

영상에서 소개하는 핵심 워크플로우:
1. **Qwen3-TTS**로 나레이션 음성 생성
2. **Claude Code Skill**로 자동화 파이프라인 구축
3. 녹음 없이 유튜브 콘텐츠 제작 가능

### Claude Code Skill 연동
- TTS 생성 → 영상 편집 자동화
- 프롬프트 기반 음성 스타일 제어
- 배치 처리로 대량 생성

---

## 📎 참고 자료

- **GitHub**: https://github.com/QwenLM/Qwen3-TTS
- **Hugging Face Demo**: https://huggingface.co/spaces/Qwen/Qwen3-TTS
- **Paper**: https://arxiv.org/abs/2601.15621
- **블로그**: https://qwen.ai/blog?id=qwen3tts-0115

---

## ⚠️ 요구사항

- **GPU**: CUDA 지원 NVIDIA GPU 권장
- **VRAM**: 1.7B 모델 기준 약 8GB 이상
- **Python**: 3.12+
- **OS**: Linux, Windows (WSL 권장)

---

## 📝 메모

> [!tip] 한국어 음성
> 한국어는 **Sohee** 스피커가 가장 자연스러움. 다른 스피커도 한국어 가능하지만 품질 차이 있음.

> [!warning] Windows 주의
> Windows 네이티브보다 WSL2에서 실행 권장. FlashAttention 설치가 더 수월함.
