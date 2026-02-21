---
tags:
  - type/guide
  - ai/claude
  - dev/pwa
  - media/live2d
  - project/wendy
  - status/completed
created: 2026-02-07
---

# 웬디 아바타 PWA 구축 가이드

## 개요
모바일/태블릿에서 웹으로 접속하는 웬디 아바타 (Progressive Web App)

## 기술 스택
| 항목 | 기술 |
|------|------|
| 프레임워크 | React + Vite |
| 캐릭터 | pixi.js + pixi-live2d-display |
| TTS | ElevenLabs v3 API |
| STT | Web Speech API |
| 채팅 | Clawdbot WebSocket |
| 네트워크 | Tailscale (HTTPS) |
| PWA | Vite PWA Plugin |

## 데스크톱 vs PWA 차이점
| 항목 | 데스크톱 (Tauri) | PWA (웹) |
|------|-----------------|---------|
| 투명 창 | ✅ | ❌ |
| 시스템 트레이 | ✅ | ❌ |
| 오프라인 | ❌ | ✅ (캐시) |
| 모바일 지원 | ❌ | ✅ |
| 설치 | .exe | 홈화면 추가 |

## PWA 서버 실행

### 개발 서버 (Tailscale 접속용)
```bash
cd C:\JohnCodeQ\wendy-avatar
npm run dev -- --host 0.0.0.0 --port 5173
```

### 접속 URL
- 로컬: `http://localhost:5173`
- Tailscale: `http://100.124.46.21:5173`

### 방화벽 설정 (필요시)
```powershell
New-NetFirewallRule -DisplayName "Wendy Avatar PWA 5173" -Direction Inbound -Protocol TCP -LocalPort 5173 -Action Allow
```

## 모바일 최적화

### iOS Safari 호환성 수정사항
- ✅ AudioContext shared + resume/unlock 분리
- ✅ BufferSource 방식 TTS 재생 (gain 1.2x)
- ✅ 모바일 캐릭터 상반신 중앙 배치 (scale 9.0x)
- ✅ 말풍선 스트리밍 중 숨김 (최종만 표시)
- ✅ 웨이크워드 자동시작 비활성화 (모바일)
- ✅ `[[tts]]` 태그 화면에서 숨김

### 반응형 레이아웃
```css
/* 모바일 */
@media (max-width: 768px) {
  .live2d-canvas {
    scale: 9.0;
    transform-origin: center top;
  }
}
```

## PWA 설정

### manifest.json
```json
{
  "name": "웬디 아바타",
  "short_name": "웬디",
  "start_url": "/",
  "display": "standalone",
  "theme_color": "#F8BBD9",
  "background_color": "#ffffff",
  "icons": [...]
}
```

### Service Worker
Vite PWA 플러그인으로 자동 생성:
```typescript
// vite.config.ts
import { VitePWA } from 'vite-plugin-pwa'

export default {
  plugins: [
    VitePWA({
      registerType: 'autoUpdate',
      workbox: {
        globPatterns: ['**/*.{js,css,html,ico,png,svg}']
      }
    })
  ]
}
```

## 홈화면 추가 방법

### iOS
1. Safari로 접속
2. 공유 버튼 → "홈 화면에 추가"
3. 이름 확인 후 추가

### Android
1. Chrome으로 접속
2. 메뉴 → "홈 화면에 추가" 또는 자동 프롬프트

## 마이크 권한
- PWA로 설치 시 마이크 권한 유지됨
- Safari: 매번 권한 요청 (제한)
- Chrome: 한 번 허용 후 유지

## 트러블슈팅
| 문제 | 해결 |
|------|------|
| 소리 안 남 | 화면 터치 후 AudioContext unlock |
| 마이크 안 됨 | HTTPS 필수, 권한 확인 |
| 캐릭터 안 보임 | WebGL 지원 확인 |
| 연결 끊김 | Tailscale 연결 상태 확인 |

---
*관련: [[웬디 아바타 데스크톱 구축 가이드]] [[Tailscale 설정]]*
