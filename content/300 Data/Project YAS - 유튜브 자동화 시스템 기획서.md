---
created: 2026-02-19
type: project-plan
tags:
  - type/project
  - status/inProgress
  - dev/automation
  - project/youtube-automation
  - ai/agents
  - priority/high
---

# 🎬 Project Y.A.S - 유튜브 자동화 시스템 기획서

> 1개 콘텐츠 → 유튜브 롱폼, 쇼츠, 인스타 릴스, 쓰레드, 블로그 자동 배포

## 1. 시스템 아키텍처

### 전체 흐름

```
사용자 (토픽/키워드 입력)
    │
    ▼
[중앙 컨트롤러 - Node.js/TypeScript]
    │
    ├─── Phase 1: 기획 & 대본 ───────────────────┐
    │    트렌드 분석 (pytrends + YouTube API)      │
    │    → 대본 생성 (Gemini Pro)                  │
    │    → 교차 검증 (Claude)                      │
    │    → 팩트체크 (Perplexity)                   │
    │    → 스토리보드 생성                          │
    │                                              │
    ├─── Phase 2: 에셋 생성 ─────────────────────┐
    │    이미지 (Nano Banana Pro)                  │
    │    영상변환 (Runway/Kling - 선택적)           │
    │    TTS (Qwen TTS - 로컬 GPU)                │
    │    BGM (Suno AI)                             │
    │                                              │
    ├─── Phase 3: 조립 & 렌더링 ─────────────────┐
    │    Remotion (React 기반 영상 생성)            │
    │    + Whisper (자막 생성)                      │
    │    → 롱폼(16:9) + 쇼츠(9:16) 동시 렌더링     │
    │                                              │
    └─── Phase 4: 배포 ─────────────────────────┐
         SEO 최적화 (AI 생성)                      │
         → YouTube (롱폼 + 쇼츠)                   │
         → Instagram Reels                         │
         → Threads                                 │
         → 블로그 (티스토리/네이버)                  │
```

### 핵심 설계 원칙
- **모듈식 구조**: 각 모듈 독립적 입출력 → AI 모델 교체 시 전체 시스템 영향 없음
- **Controller**: 파이프라인 상태 관리, 에러 재시도, 사용자 알림
- **Asset Manager**: 프로젝트별 폴더에 체계적 파일 관리

## 2. 모듈별 상세 설계

### 2.1 기획 & 대본 모듈
- **입력**: 주제 키워드
- **프로세스**: pytrends/YouTube API 분석 → Gemini Pro 대본 초안 → Claude 교정 → Perplexity 팩트체크
- **출력**: `script.json` (섹션별 대사, 러닝타임, 시각적 묘사)
- **에러 핸들링**: 지수 백오프 재시도 (3회 실패 시 일시정지)

### 2.2 에셋 생성 모듈
- **입력**: `storyboard.json`
- **이미지**: Nano Banana Pro API → `assets/images/scene_{n}.png`
- **영상**: `is_video: true` 플래그 장면만 Runway/Kling API → `assets/videos/scene_{n}.mp4`
- **TTS**: 로컬 Qwen TTS (192.168.0.2:7860) → `assets/audio/voice_{n}.wav`
- **BGM**: Suno AI 프롬프트 → 음악 다운로드
- **출력**: `storyboard_with_assets.json`

### 2.3 렌더링 모듈 (Remotion)
- `<MainVideo />`: 16:9 롱폼
- `<ShortsVideo />`: 9:16 쇼츠 (중앙 크롭 + 자막 재배치)
- 이미지/영상 트랜지션, TTS 길이 기반 장면 자동 조절, Whisper 자막 오버레이

### 2.4 배포 모듈
- **YouTube**: googleapis 라이브러리, 썸네일 업로드, 재생목록 추가
- **Instagram/Threads**: Graph API, 비디오 컨테이너 → 업로드 → 게시
- **Blog**: 대본 → 블로그 포맷 변환 후 API 전송
- **SEO**: Gemini Vision으로 영상 분석 → 해시태그/제목 생성

## 3. 데이터 모델

### 프로젝트 상태 (`project_state.json`)
```json
{
  "projectId": "20240520-ai-trends",
  "status": "generating_assets",
  "currentStep": 3,
  "config": {
    "targetDuration": 600,
    "platform": ["youtube", "instagram"],
    "voiceId": "qwen_female_calm"
  }
}
```

### 스토리보드 (`storyboard.json`)
```json
{
  "title": "AI Revolution 2024",
  "scenes": [
    {
      "id": 1,
      "type": "video",
      "duration": 5.2,
      "script": "2024년, AI는 우리의 상상을 뛰어넘었습니다.",
      "visual_prompt": "Futuristic city, cyberpunk style",
      "assets": {
        "image": "assets/images/scene_001.png",
        "video": "assets/videos/scene_001.mp4",
        "audio": "assets/audio/scene_001.wav"
      },
      "transition": "fade"
    }
  ],
  "bgm": {
    "file": "assets/audio/bgm.mp3",
    "volume": 0.3
  }
}
```

## 4. 기술 스택 & 비용 추정

| 구분 | 도구 | 연동 | 비용 |
|------|------|------|------|
| Orchestration | Node.js + TypeScript | Local | 무료 |
| Image Gen | Nano Banana Pro | REST API | 구독형/크레딧 |
| Video Gen | Runway / Kling | REST API | $0.05~0.1/sec (선택적) |
| Text Gen | Gemini Pro / Claude | SDK | 토큰 과금 (저렴) |
| TTS | Qwen TTS | Local Server | 무료 |
| Rendering | Remotion | Local | 무료 (개인) |
| BGM | Suno AI | API | 구독형 |

## 5. 개발 로드맵

### Phase 1: MVP
- 텍스트 주제 → 유튜브 쇼츠 1개 자동 생성
- 대본 생성 + 이미지 생성 + TTS + Remotion 슬라이드쇼
- 로컬 저장 (자동 업로드 X)

### Phase 2: 퀄리티 업 & 롱폼
- 장면 전환 효과, 줌인/줌아웃
- Img2Vid 도입, BGM 자동 생성
- 유튜브 자동 업로드 연동

### Phase 3: 멀티플랫폼
- 원소스 멀티유즈 자동화
- 릴스, 블로그, 쓰레드 자동 배포
- 썸네일 자동 생성

### Phase 4: 완전 자동화
- 실시간 트렌드 감지 → 자동 제작
- 댓글 반응 분석 → 후속 콘텐츠 기획

## 6. 폴더 구조

```
C:\JohnCodeQ\YouTubeAutomation\
├── config/           # API 키, 프롬프트 템플릿, 설정
├── src/
│   ├── controller/   # 메인 로직, 스케줄러
│   ├── generators/   # AI 모델 래퍼 (Image, Text, Audio)
│   ├── remotion/     # Remotion React 프로젝트
│   ├── uploader/     # 플랫폼별 업로드
│   └── utils/        # 헬퍼 함수
├── workspace/        # 프로젝트별 작업 공간
├── tools/            # Qwen TTS 등 실행 스크립트
├── package.json
└── PLAN.md
```

## 7. MVP 실행 예시

```bash
node index.js --topic "고양이의 비밀"
```
1. Gemini가 3문장 쇼츠 대본 작성
2. 대본에 맞춰 이미지 3장 생성
3. 로컬 TTS로 음성 3개 생성
4. Remotion이 합쳐서 `.mp4` 렌더링
5. `workspace/output/result.mp4` 완성

---

## 8. 멀티플랫폼 배포 상세 설계

### 전체 배포 흐름
```
원본 콘텐츠 (대본 + 롱폼 + 쇼츠)
  ├→ YouTube 롱폼 (16:9) — YouTube Data API v3
  ├→ YouTube 쇼츠 (9:16, ≤60초) — #Shorts 태그
  ├→ Instagram Reels (9:16, ≤90초) — Graph API
  ├→ Threads (텍스트+이미지) — Threads API
  └→ Blog (티스토리/네이버) — Open API
```

### 플랫폼별 API 상세

| 플랫폼 | API | 인증 | 핵심 제한 |
|--------|-----|------|----------|
| YouTube | Data API v3 | OAuth 2.0 | ~6 업로드/일 |
| Instagram Reels | Graph API | Facebook 앱 연동 | ≤90초, 25개/일 |
| Threads | Threads API | Instagram OAuth | 500자, 이미지 10장 |
| 티스토리 | Open API v1 | OAuth 2.0 | - |
| 네이버 블로그 | Blog API | OAuth 2.0 | 이미지 직접 업로드 필요 |

### 콘텐츠 변환 전략

| 원본 → | 쇼츠/릴스 | Threads | Blog |
|--------|-----------|---------|------|
| 대본 | 핵심 60초 추출 | 3~5문장 요약 | 블로그 글로 재구성 |
| 이미지 | 9:16 리프레임 | 캐러셀 | 본문 삽입 |
| 영상 | 세로 크롭+자막 확대 | 미첨부 | 유튜브 임베드 |

### 배포 스케줄링
```
T+0분:  YouTube 롱폼/쇼츠 예약 업로드
T+5분:  Blog 자동 발행 (유튜브 URL 임베드)
T+10분: Instagram Reels 업로드
T+15분: Threads 포스팅 (유튜브 링크 포함)
```
→ 유튜브 먼저 → 블로그에 임베드 URL 확보 → SNS에서 유입 유도

### 배포 모듈 구조
```
src/uploader/
├── index.ts              # 배포 오케스트레이터
├── youtube.ts            # YouTube 롱폼 + 쇼츠
├── instagram.ts          # Instagram Reels
├── threads.ts            # Threads 포스팅
├── tistory.ts            # 티스토리 블로그
├── naver-blog.ts         # 네이버 블로그
├── content-transformer.ts # 플랫폼별 콘텐츠 변환
├── seo-optimizer.ts      # SEO 최적화
└── auth/                 # 플랫폼별 OAuth 관리
```

---

**관련 문서**: [[YouTubeAutomation]] [[Remotion]] [[Qwen TTS]]
**작성일**: 2026-02-19
