---
tags:
  - dev/python
  - ai/tts
  - type/guide
  - status/completed
created: 2026-02-19
updated: 2026-02-19
source: https://github.com/QwenLM/Qwen3-TTS
repo: https://github.com/keyfream7001/qwen3-tts-server
---

# Qwen3-TTS 완전 가이드 — Windows Voice Clone 서버

## 개요

**Qwen3-TTS**는 알리바바 Qwen 팀이 개발한 오픈소스 TTS 모델 시리즈 (2026.1 릴리스, Apache 2.0).

핵심 기능:
- **3초 Voice Clone** — 짧은 레퍼런스 오디오로 즉시 음성 복제
- **Voice Design** — 자연어로 목소리 디자인 ("밝고 에너지 넘치는 20대 여성 목소리")
- **10개 언어** — 한국어, 영어, 일본어, 중국어, 독일어, 프랑스어, 러시아어, 포르투갈어, 스페인어, 이탈리아어
- **스트리밍 지원** — 최소 97ms 지연의 실시간 생성
- **감정/톤 제어** — instruct 파라미터로 감정·속도·톤 조절

### 모델 종류

| 모델 | 용도 | VRAM |
|------|------|------|
| `Qwen3-TTS-12Hz-0.6B-Base` | Voice Clone (경량) | ~4GB |
| `Qwen3-TTS-12Hz-1.7B-Base` | Voice Clone (고품질) | ~6-8GB |
| `Qwen3-TTS-12Hz-1.7B-CustomVoice` | 프리셋 9종 + 스타일 제어 | ~6-8GB |
| `Qwen3-TTS-12Hz-1.7B-VoiceDesign` | 자연어로 새 목소리 생성 | ~6-8GB |

> [!important] GTX 1060 6GB 사용 시
> **1.7B-Base 모델 사용.** 0.6B는 CUDA assert 에러 발생 → 1.7B가 오히려 안정적. `torch.float16` 필수.

---

## 서버 구조

```
┌─────────────────────┐         ┌─────────────────────────┐
│  서버 PC (192.168.0.2)│◄─HTTP──│  웬디 PC (192.168.0.5)    │
│  GTX 1060 6GB        │        │  API 요청 + 파일 저장      │
│                      │  WAV   │                          │
│  TTS 생성만 담당      │──────►│  output/{날짜}_{프로젝트명}/ │
│  저장 안 함           │  응답  │  001_요약.wav              │
└─────────────────────┘         └─────────────────────────┘
```

- **서버 PC** (192.168.0.2): Qwen3-TTS 모델 로드, TTS 생성만 담당. 파일 저장 안 함.
- **웬디 PC** (192.168.0.5): API 요청 전송 + 응답 WAV 파일 저장
- **저장 경로**: `C:\qwen-tts-server\output\{날짜}_{프로젝트명}\001_요약.wav`
- **포트**: 7860
- **GitHub 레포**: [keyfream7001/qwen3-tts-server](https://github.com/keyfream7001/qwen3-tts-server) (private)

---

## Windows 환경 요구사항

| 항목 | 요구 |
|------|------|
| OS | Windows 10/11 |
| Python | **3.10~3.12** (3.12 권장) |
| GPU | NVIDIA CUDA 지원 (GTX 1060 6GB 이상) |
| CUDA Toolkit | 11.8 또는 12.x |
| RAM | 16GB 이상 권장 |
| 저장공간 | 모델당 ~3-8GB (Tokenizer + Base 합쳐 ~10GB) |

---

## 설치 단계

### 1. Python venv 생성

```powershell
cd C:\qwen-tts-server

# venv 생성 및 활성화
python -m venv venv
.\venv\Scripts\activate
```

### 2. PyTorch (CUDA) 설치

```powershell
# CUDA 12.x용 (본인 CUDA 버전 확인: nvidia-smi)
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# CUDA 11.8용
# pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
```

### 3. qwen-tts 패키지 설치

```powershell
pip install -U qwen-tts
```

### 4. (선택) FlashAttention 2

> [!warning] Windows에서 flash-attn
> FlashAttention 2는 **Ampere 이상 GPU** (RTX 30xx, 40xx, 50xx) 필요.
> **GTX 1060 (Pascal)은 미지원** → `--no-flash-attn` 옵션 사용.
> flash-attn 없어도 작동함, 다만 메모리 사용량이 약간 늘어남.

### 5. 추가 의존성 (서버용)

```powershell
pip install fastapi uvicorn soundfile numpy python-dotenv
```

---

## 모델 다운로드

첫 실행 시 자동 다운로드되지만, 미리 받아두려면:

```powershell
pip install -U "huggingface_hub[cli]"

# Voice Clone용 (필수 2개)
huggingface-cli download Qwen/Qwen3-TTS-Tokenizer-12Hz --local-dir ./models/Qwen3-TTS-Tokenizer-12Hz
huggingface-cli download Qwen/Qwen3-TTS-12Hz-1.7B-Base --local-dir ./models/Qwen3-TTS-12Hz-1.7B-Base
```

> [!tip] HuggingFace 로그인
> `huggingface-cli login` 으로 토큰 설정 필요할 수 있음.

---

## Voice Clone 사용법

### 기본 코드

```python
import torch
import soundfile as sf
from qwen_tts import Qwen3TTSModel

# GTX 1060: 1.7B + float16 (0.6B는 CUDA assert 에러 발생)
model = Qwen3TTSModel.from_pretrained(
    "Qwen/Qwen3-TTS-12Hz-1.7B-Base",
    device_map="cuda:0",
    dtype=torch.float16,  # GTX 1060은 bfloat16 미지원 → float16 사용
)

# 레퍼런스 오디오 (3초 이상, 깨끗한 음성)
ref_audio = "reference_voice.wav"
ref_text = "레퍼런스 오디오에서 말하는 내용의 정확한 텍스트"

# 음성 생성
wavs, sr = model.generate_voice_clone(
    text="안녕하세요, 이것은 클론된 음성입니다.",
    language="Korean",
    ref_audio=ref_audio,
    ref_text=ref_text,
    max_new_tokens=4096,
)
sf.write("output.wav", wavs[0], sr)
```

### 프롬프트 재사용 (효율적)

같은 레퍼런스로 여러 문장을 생성할 때:

```python
# 프롬프트 한 번만 생성
prompt = model.create_voice_clone_prompt(
    ref_audio="reference_voice.wav",
    ref_text="레퍼런스 텍스트",
)

# 재사용
for text in ["문장 1", "문장 2", "문장 3"]:
    wavs, sr = model.generate_voice_clone(
        text=text,
        language="Korean",
        voice_clone_prompt=prompt,
        max_new_tokens=4096,
    )
    sf.write(f"output_{text[:10]}.wav", wavs[0], sr)
```

---

## server.py 주요 기능

현재 서버(`C:\qwen-tts-server\server.py`)의 핵심 구현:

### 환경변수 관리
- **python-dotenv**로 `.env` 파일에서 API 키 등 관리
- `pip install python-dotenv` 필수

### 프롬프트 캐싱
- `create_voice_clone_prompt`를 **서버 시작 시 1회만 실행**
- 매 요청마다 ref_audio 재처리 방지 → 성능 대폭 향상

### 더미 텍스트 + 무음 감지 트리밍
- 끝 글자 잘림 방지를 위해 더미 텍스트 추가 후 생성
- 무음 감지(silence detection)로 정확한 cut point 찾아서 트리밍
- 상세 내용은 [[#끝 글자 잘림 방지 — 최종 해결법]] 참고

### 후처리
- 트리밍 후 **0.2초 무음 추가** (자연스러운 끝맺음)

### API 엔드포인트

```
POST http://192.168.0.2:7860/tts/clone
Authorization: Bearer {API_KEY}  # .env에서 관리
Content-Type: application/json
{"text": "생성할 텍스트"}
```

---

## 끝 글자 잘림 방지 — 최종 해결법

TTS 모델에서 마지막 글자가 잘리는 건 흔한 문제. 여러 방법을 시도한 끝에 **더미 텍스트 + 무음 감지**로 최종 해결.

### ❌ 시도했지만 부정확했던 방법들

1. **`"。"` 같은 특수 패딩 문자**: 토크나이저 호환 안 됨 → CUDA assert 발생
2. **비율 기반 자르기** (`estimate_trim_ratio`): 텍스트 길이 비율로 오디오를 잘랐으나 부정확

### ✅ 최종 해결: 더미 텍스트 + 무음 감지 (silence detection)

```python
# 1. 더미 텍스트 추가 후 생성
dummy_suffix = "  ...  그리고 잠시 쉬어가겠습니다."
padded_text = original_text + dummy_suffix

wavs, sr = model.generate_voice_clone(
    text=padded_text,
    language="Korean",
    voice_clone_prompt=prompt,
    max_new_tokens=4096,
)

# 2. 무음 감지로 정확한 cut point 찾기
def find_sentence_boundary(audio, sr, estimated_ratio):
    """원본 비율 근처에서 80ms 윈도우로 가장 조용한 구간 찾기"""
    estimated_end = int(len(audio) * estimated_ratio)
    window_size = int(sr * 0.08)  # 80ms 윈도우
    
    # 추정 위치 ±10% 범위에서 탐색
    search_start = max(0, estimated_end - int(len(audio) * 0.1))
    search_end = min(len(audio), estimated_end + int(len(audio) * 0.1))
    
    min_energy = float('inf')
    best_pos = estimated_end
    
    for pos in range(search_start, search_end - window_size, window_size // 4):
        window = audio[pos:pos + window_size]
        energy = np.mean(window ** 2)
        if energy < min_energy:
            min_energy = energy
            best_pos = pos
    
    return best_pos

cut_point = find_sentence_boundary(wavs[0], sr, len(original_text) / len(padded_text))
trimmed = wavs[0][:cut_point]

# 3. 후처리: 0.2초 무음 추가
silence = np.zeros(int(sr * 0.2))
final_audio = np.concatenate([trimmed, silence])
sf.write("output.wav", final_audio, sr)
```

### 핵심 포인트
- **비율 기반 자르기는 부정확** → 무음 감지가 훨씬 정확
- 더미 텍스트로 원본 끝부분이 완전히 생성되도록 보장
- `find_sentence_boundary`: 80ms 윈도우로 에너지 최소 구간 = 문장 경계

### `max_new_tokens` 충분히 설정
```python
max_new_tokens=4096  # 기본값이 작을 수 있음, 넉넉히
```

---

## 대본 TTS 작업 방법

긴 대본을 TTS로 변환하는 워크플로우.

### 1. 문장 분리
마침표(`.`), 물음표(`?`), 느낌표(`!`) 기준으로 문장별 분리.

### 2. Node.js 스크립트로 순차 생성
서버 API에 문장 하나씩 순차적으로 요청 → WAV 파일로 저장.

### 3. 프로젝트별 폴더링
```
C:\qwen-tts-server\output\
└── 2026-02-19_유튜브인트로\
    ├── 001_요약.wav
    ├── 002_인사.wav
    ├── 003_본문시작.wav
    └── ...
```

### 4. 성능 참고
- **GTX 1060 6GB** 기준: 23문장 약 **10분** 소요
- 문장이 길수록 개별 생성 시간 증가
- 배치 생성 용도에 적합 (실시간 서비스 X)

### 5. 워크플로우 요약
```
대본 작성 → 문장 분리 → Node.js 스크립트 실행 → 
서버 API 순차 호출 → 프로젝트 폴더에 WAV 저장 → 
영상 편집 프로그램에서 사용
```

---

## 트러블슈팅

### 0.6B 모델: CUDA assert 에러
```
CUDA error: device-side assert triggered
```
→ **0.6B 모델에서 발생.** 1.7B-Base 모델 사용으로 해결.

### "。" 등 특수 패딩 문자 → CUDA assert
```
RuntimeError: CUDA error: device-side assert triggered
```
→ 토크나이저가 `"。"` 같은 특수 문자를 제대로 처리 못함.
→ **한국어 더미 문장**("  ...  그리고 잠시 쉬어가겠습니다.")으로 대체.

### latin-1 인코딩 에러
```
UnicodeEncodeError: 'latin-1' codec can't encode characters
```
→ **HTTP 헤더에 한글 넣으면 안 됨.** 헤더 값은 ASCII만 사용.
→ 파일명 등 한글 정보는 JSON body로 전달.

### "Torch not compiled with CUDA enabled"
```
AssertionError: Torch not compiled with CUDA enabled
```
→ **venv 밖에서 실행했을 때 발생.** 시스템 Python에는 CPU-only torch가 설치되어 있음.
→ 반드시 `.\venv\Scripts\activate` 후 실행.

### python-dotenv 없음
```
ModuleNotFoundError: No module named 'dotenv'
```
→ `pip install python-dotenv`

### FlashAttention 경고
```
UserWarning: Flash attention is not available, using default attention.
```
→ **무시해도 됨.** GTX 1060은 FlashAttention 미지원. 성능만 약간 차이.

### CUDA Out of Memory
```
torch.cuda.OutOfMemoryError: CUDA out of memory.
```
해결:
1. **float16 사용** (`dtype=torch.float16`)
2. **다른 GPU 프로세스 종료** (`nvidia-smi`로 확인)
3. **배치 크기 1로 제한**
4. **max_new_tokens 줄이기** (2048 등)
5. 환경변수: `set PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True`

### 모델 다운로드 실패
```powershell
# HuggingFace 미러 사용
set HF_ENDPOINT=https://hf-mirror.com
huggingface-cli download Qwen/Qwen3-TTS-12Hz-1.7B-Base --local-dir ./models/...
```

### bfloat16 관련 에러
GTX 1060 (Pascal)은 bfloat16 미지원:
```python
# ❌ dtype=torch.bfloat16  → 에러
# ✅ dtype=torch.float16   → OK
```

### 한국어 발음 이상
- `language="Korean"` 명시적 지정 (Auto 대신)
- ref_text가 실제 오디오와 정확히 일치하는지 확인
- 레퍼런스 오디오 품질 체크 (노이즈 없는 깨끗한 음성)

### CUDA 에러 발생 후 복구
- CUDA assert 에러 한 번 발생하면 해당 프로세스는 복구 불가
- **프로세스 완전 재시작 필요** (서버 kill 후 다시 실행)

---

## GPU별 성능 참고

| GPU | VRAM | 권장 모델 | 예상 속도 (RTF) |
|-----|------|-----------|-----------------|
| **GTX 1060 6GB** | 6GB | 1.7B-Base (float16) | ~0.3-0.5x (실시간보다 느림) |
| RTX 3060 12GB | 12GB | 1.7B-Base (float16) | ~1-2x |
| RTX 3090 24GB | 24GB | 1.7B + flash-attn | ~3-5x |
| RTX 4090 24GB | 24GB | 1.7B + flash-attn | ~5-8x |

> [!note] GTX 1060 6GB 현실적 기대치
> - **1.7B 모델**: float16으로 동작 확인. 23문장 약 10분.
> - **0.6B 모델**: CUDA assert 에러 발생 → 사용 불가
> - **스트리밍**: 실시간 서비스보다는 **배치 생성** 용도에 적합
> - 긴 텍스트는 문장 분할 후 개별 생성 권장

---

## 로컬 Web UI 데모

공식 Gradio 데모도 제공:

```powershell
pip install qwen-tts
qwen-tts-demo Qwen/Qwen3-TTS-12Hz-1.7B-Base --no-flash-attn --ip 127.0.0.1 --port 8000
```

브라우저에서 `http://127.0.0.1:8000` 접속.

---

## 참고 링크

- GitHub (공식): https://github.com/QwenLM/Qwen3-TTS
- GitHub (우리 서버): https://github.com/keyfream7001/qwen3-tts-server (private)
- HuggingFace Collection: https://huggingface.co/collections/Qwen/qwen3-tts
- 논문: https://arxiv.org/abs/2601.15621
- 블로그: https://qwen.ai/blog?id=qwen3tts-0115
- HF Demo: https://huggingface.co/spaces/Qwen/Qwen3-TTS

---

## 실전 세팅 완료 기록 (2026-02-19)

- **서버 PC**: 192.168.0.2, Windows, GTX 1060 6GB — TTS 생성 전용
- **웬디 PC**: 192.168.0.5 — API 요청 + 파일 저장
- **경로**: `C:\qwen-tts-server\`
- **모델**: Qwen3-TTS-12Hz-1.7B-Base (float16)
- **포트**: 7860
- **venv**: `C:\qwen-tts-server\venv\`

### 주의사항

- 반드시 venv 안에서 실행 (시스템 Python은 CUDA 없는 torch)
- flash-attn 없어도 동작 (GTX 1060은 미지원)
- 프롬프트 캐싱으로 매 요청마다 ref_audio 재처리 방지
- CUDA 에러 발생 시 프로세스 완전 재시작 필요
- 0.6B 모델은 CUDA assert → 1.7B 사용
