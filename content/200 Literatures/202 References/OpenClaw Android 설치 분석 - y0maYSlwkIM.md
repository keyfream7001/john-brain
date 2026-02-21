---
type: research
aliases: ["OpenClaw Android 설치", "OpenClaw Termux 설치"]
author: "[[John]]"
date created: 2026-02-20
tags: [type/research, status/inProgress, ai/agents, ai/automation, dev/android, media/youtube, project/wendy, priority/high]
status: inProgress
source: "https://www.youtube.com/watch?v=y0maYSlwkIM"
summary: "Termux(Bionic) 직접 설치는 koffi/spawn.h/renameat2 문제로 실패 가능성이 높고, proot Ubuntu 우회가 핵심"
---

# OpenClaw Android 설치 분석 - y0maYSlwkIM

## 한줄 결론
Termux 기본 환경에서 `npm i -g openclaw`는 네이티브 빌드 호환성 문제로 자주 실패하며, 영상에서 제시한 핵심은 **proot Ubuntu 환경에서 OpenClaw를 설치/실행**하는 우회 방식이다.

## 핵심 요약
- Android Termux는 glibc가 아닌 Bionic 기반이라 네이티브 모듈(`koffi`) 빌드 실패가 잦다.
- 실제 실패 시그널: `spawn.h not found`, `renameat2 undeclared`, `koffi build failed`.
- 해결 전략은 `proot-distro install ubuntu` 후 Ubuntu 내부에서 설치.
- Node.js 22 + OpenClaw 설치 후 네트워크 인터페이스 우회용 `hijack.js`를 적용.
- 마지막은 `openclaw onboard` → `openclaw gateway --verbose`.
- 루트 없이 가능하지만, 배터리 최적화/백그라운드 제한은 별도 관리 필요.
- 공식 스토어 앱 경로보다, 현재는 Termux+proot 우회 또는 소스 빌드가 현실적.
- 본 분석은 영상 직접 자막 추출이 아닌 관련 스크립트/문서 교차검증 기반(신뢰도: 중상).

## 참고 스크립트(검토 완료)
- `https://raw.githubusercontent.com/androidmalware/OpenClaw_Termux/main/install_openclaw_termux.sh`
- 주요 동작:
  1. Termux 업데이트
  2. `proot-distro` 설치
  3. Ubuntu 설치 및 로그인
  4. Node.js 22 설치
  5. `npm install -g openclaw@latest`
  6. `/root/hijack.js` 생성 + `NODE_OPTIONS` 등록
  7. `openclaw onboard`, `openclaw gateway --verbose`

## 수동 설치 명령(안전 버전)
```bash
pkg update -y && pkg upgrade -y
pkg install -y proot-distro wget openssl

proot-distro install ubuntu
proot-distro login ubuntu

apt update && apt upgrade -y
apt install -y curl git build-essential ca-certificates
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt install -y nodejs
npm install -g openclaw@latest

cat > /root/hijack.js << "EOF"
const os = require("os");
os.networkInterfaces = () => ({});
EOF

echo 'export NODE_OPTIONS="-r /root/hijack.js"' >> ~/.bashrc
source ~/.bashrc

openclaw onboard
openclaw gateway --verbose
```

## 이번 세션 실제 상태
- 웬디 PC에 ADB 설치 완료 (`Google.PlatformTools 36.0.2`).
- `adb devices -l` 결과: 단말 연결됨, 현재 `unauthorized` (폰에서 RSA 허용 필요).
- 다음 액션:
  1. 폰에서 "USB 디버깅 허용" 체크(항상 허용)
  2. `adb devices -l` 재확인
  3. 필요 시 ADB로 Termux 자동화 보조

## 판단
우리의 기존 실패(`koffi/spawn.h/renameat2`)는 정상적인 호환성 이슈이며, **환경 전환(proot Ubuntu)**이 정답.

## Links
- [[OpenClaw]]
- [[Termux]]
- [[Android Automation]]
- [[Project YAS]]
