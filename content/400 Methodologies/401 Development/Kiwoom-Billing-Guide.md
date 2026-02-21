---
tags: [type/guide, type/reference, dev/payment, methodology/workflow, status/completed]
created: 2026-02-07
updated: 2026-02-07
---

# 키움페이 결제 시스템 구축 가이드
# 키움페이 결제 시스템 (Kiwoom Billing)

키움페이(KiwoomPay)를 활용한 통합 결제 백엔드 시스템입니다.
**카드 정기결제 + 간편결제(카카오페이, 네이버페이)** 를 지원합니다.

## 🚀 주요 기능

### 💳 카드 정기결제
- **빌링키 등록**: 카드 정보로 빌링키 발급
- **정기결제 등록**: 구독 플랜 생성 및 관리
- **결제 실행**: 즉시 결제 및 정기 결제
- **구독 취소/환불**: 구독 해지 및 결제 환불

### 📱 간편결제 (통합결제창)
- **카카오페이**: ✅ 준비됨 (승인 대기중)
- **네이버페이**: ✅ 준비됨 (승인 대기중)
- **삼성페이**: 🔧 구현됨 (비활성화)
- **페이코**: 🔧 구현됨 (비활성화)

### 🔔 웹훅
- 결제 결과 실시간 수신
- 통지전문(Noti) 처리

## 📋 API 엔드포인트

### 빌링 API (카드 정기결제)

| Method | Endpoint                    | 설명       |
| ------ | --------------------------- | -------- |
| POST   | `/billing/register`         | 빌링키 등록   |
| POST   | `/billing/subscribe` No     | 정기결제 등록  |
| POST   | `/billing/pay`              | 결제 실행    |
| POST   | `/billing/cancel`           | 구독 취소    |
| POST   | `/billing/refund`           | 결제 환불    |
| GET    | `/billing/subscription/:id` | 구독 정보 조회 |
| GET    | `/billing/subscriptions`    | 구독 목록 조회 |

### 간편결제 API

| Method | Endpoint | 설명 |
|--------|----------|------|
| GET | `/easypay/methods` | 활성화된 결제수단 조회 |
| POST | `/easypay/prepare` | 간편결제 준비 (SDK 데이터) |
| POST | `/easypay/cancel` | 결제 취소 |
| GET | `/easypay/sdk-example` | SDK 연동 예제 (HTML) |
| GET | `/easypay/status/:orderId` | 결제 상태 조회 |

### 웹훅 API

| Method | Endpoint | 설명 |
|--------|----------|------|
| POST | `/webhook/kiwoom` | 키움페이 웹훅 수신 |
| POST | `/webhook/noti` | 통지전문 수신 |
| GET | `/webhook/health` | 웹훅 상태 확인 |

## 🛠️ 설치 및 실행

### 1. 의존성 설치

```bash
cd kiwoom-billing
npm install
```

### 2. 환경 변수 설정

```bash
cp .env.example .env
```

`.env` 파일 편집:
```env
# 환경 설정
NODE_ENV=development  # development | production

# 키움페이 설정
KIWOOM_CPID=your_merchant_id
KIWOOM_TEST_AUTH_KEY=your_test_auth_key
KIWOOM_PROD_AUTH_KEY=your_production_auth_key

# 간편결제 활성화
KAKAOPAY_ENABLED=true
NAVERPAY_ENABLED=true
```

### 3. 개발 서버 실행

```bash
npm run dev
```

### 4. 프로덕션 빌드

```bash
npm run build
npm start
```

## 🔑 환경 변수

### 필수

| 변수 | 설명 |
|------|------|
| `KIWOOM_CPID` | 키움페이 가맹점 ID |
| `KIWOOM_TEST_AUTH_KEY` | 테스트 환경 인증키 |
| `KIWOOM_PROD_AUTH_KEY` | 운영 환경 인증키 |

### 간편결제 (기본값: false)

| 변수 | 설명 |
|------|------|
| `KAKAOPAY_ENABLED` | 카카오페이 활성화 |
| `NAVERPAY_ENABLED` | 네이버페이 활성화 |
| `SAMSUNGPAY_ENABLED` | 삼성페이 활성화 |
| `PAYCO_ENABLED` | 페이코 활성화 |

## 📝 사용 예시

### 간편결제 (SDK 방식)

1. 서버에서 결제 데이터 준비:
```bash
curl -X POST http://localhost:3000/easypay/prepare \
  -H "Content-Type: application/json" \
  -d '{
    "orderId": "ORDER-20260205-001",
    "amount": 9900,
    "productName": "프리미엄 구독",
    "customerName": "홍길동"
  }'
```

2. 응답 데이터로 SDK 결제창 호출:
```javascript
// SDK 초기화
KiwoomPaySDK.f_setInit('DEV', 'FRAME');

// 결제창 호출
KiwoomPaySDK.f_payTotalLink(response.data.sdkData);
```

3. SDK 연동 예제 확인:
```
http://localhost:3000/easypay/sdk-example
```

### 카드 정기결제

```bash
# 1. 빌링키 등록
curl -X POST http://localhost:3000/billing/register \
  -H "Content-Type: application/json" \
  -d '{
    "cardNumber": "4111111111111111",
    "expireDate": "2512",
    "cardPassword": "12",
    "birthDate": "901231",
    "customerName": "홍길동",
    "customerId": "user123"
  }'

# 2. 정기결제 등록
curl -X POST http://localhost:3000/billing/subscribe \
  -H "Content-Type: application/json" \
  -d '{
    "billingKey": "BILL_KEY",
    "customerId": "user123",
    "planId": "monthly",
    "amount": 9900,
    "productName": "월간 구독",
    "cycleDay": 15
  }'
```

## 🗂️ 프로젝트 구조

```
kiwoom-billing/
├── src/
│   ├── index.ts              # 메인 서버
│   ├── config/
│   │   └── index.ts          # 환경변수 설정 (테스트/운영 분리)
│   ├── routes/
│   │   ├── billing.ts        # 카드 정기결제 API
│   │   ├── easyPay.ts        # 간편결제 API
│   │   └── webhook.ts        # 웹훅 처리
│   ├── services/
│   │   ├── kiwoomPay.ts      # 키움페이 정기결제 서비스
│   │   └── easyPay.ts        # 간편결제 서비스
│   └── types/
│       └── index.ts          # TypeScript 타입
├── .env.example
├── .gitignore
├── package.json
├── tsconfig.json
└── README.md
```

## 🔄 환경 전환

```bash
# 개발 환경 (테스트 API 사용)
NODE_ENV=development npm run dev

# 운영 환경 (실제 API 사용)
NODE_ENV=production npm start
```

## 📚 참고 문서

- [키움페이 개발자센터](https://developer.kiwoompay.co.kr/)
- [통합 API 가이드](https://developer.kiwoompay.co.kr/developer/guide_api)
- [통합결제창 SDK](https://developer.kiwoompay.co.kr/developer/guide_totallink_sdk)

## ⚠️ 주의사항

1. **간편결제 승인 필요**: 카카오페이, 네이버페이는 키움페이 승인 후 사용 가능
2. **환경 분리**: 테스트/운영 환경 API URL과 인증키가 다름
3. **카드정보 보안**: 카드번호는 서버에 저장하지 않고 빌링키만 사용
4. **웹훅 보안**: 운영 환경에서는 IP 화이트리스트 설정 권장

## 📄 라이선스

MIT License
