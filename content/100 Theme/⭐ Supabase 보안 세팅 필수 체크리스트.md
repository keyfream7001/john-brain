---
tags:
  - type/guide
  - status/completed
  - dev/supabase
  - dev/security
date: 2026-02-19
source: "Threads @cowboy76 (사이드프로젝트)"
summary: "Supabase anon key 노출 위험과 RLS 보안 세팅 필수 체크리스트"
---

# ⭐ Supabase 보안 세팅 필수 체크리스트

> Supabase는 사이드 프로젝트에서 가성비 최고지만, **기본 세팅 그대로 쓰면 DB가 뚫린다.**
> 5분이면 끝나는 보안 세팅. 안 하면 DB 오염은 시간 문제.

---

## 🚨 왜 위험한가? — 실제 공격 시나리오

### 브라우저에서 키가 다 보인다

누구든 브라우저 **DevTools → Network 탭**을 열고 `supabase`로 필터링하면:

- Request URL (API 엔드포인트)
- `apikey` 헤더 (anon key)
- `Authorization` 헤더

이 **전부 그대로 노출**된다.

### 🔥 curl 한 줄이면 끝

```bash
# 1. 브라우저 네트워크 탭에서 anon key 복사
# 2. 아래 명령 실행

curl -X POST 'your-project.supabase.co/rest/v1/my_table' \
  -H 'apikey: 복사한_anon_key' \
  -H 'Content-Type: application/json' \
  -d '{"id":"test","value":99.9}'

# 3. 끝. DB에 가짜 데이터가 들어감
```

RLS에 `WITH CHECK (true)`를 걸어뒀다면 **아무 제한 없이 데이터가 들어간다.**

> 특히 캐시, 로그, 공개 데이터 테이블처럼 "인증 필요 없으니까"라고 열어둔 테이블이 **가장 먼저 뚫린다.**

---

## 🔑 Supabase 키 2개 이해하기

| 키 | 노출 | 용도 | 권한 |
|---|---|---|---|
| 🔓 **anon key** | 브라우저에 노출됨 (`NEXT_PUBLIC_`) | 클라이언트 읽기 | RLS 정책을 따름 |
| 🔐 **service_role key** | 서버에서만 사용 | 서버 쓰기 | RLS를 **완전히 우회** |

### 핵심 원칙

- **읽기 (SELECT)** → anon key (클라이언트 OK) ✅
- **쓰기 (INSERT/UPDATE)** → service_role key (서버에서만!) 🔐

---

## ✅ 3가지만 하면 된다

### 1️⃣ 서버 환경변수에 `SUPABASE_SERVICE_ROLE_KEY` 추가

Railway, Vercel, GitHub Secrets 등 서버 환경에 등록한다.

> ⚠️ 절대 `NEXT_PUBLIC_` 접두사를 붙이지 마세요! 브라우저에 노출됩니다.

### 2️⃣ 코드에서 읽기/쓰기 클라이언트 분리

```typescript
// ✅ 읽기 전용 (브라우저 노출 OK)
const supabaseRead = createClient(
  url,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

// 🔐 쓰기 전용 (서버에서만 — NEXT_PUBLIC_ 절대 붙이지 마세요)
const supabaseWrite = createClient(
  url,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);
```

`supabaseWrite`는 **API Route, GitHub Actions, cron job** 등 서버 환경에서만 사용!

### 3️⃣ RLS 정책을 `service_role` 전용으로 변경

```sql
-- ❌ 기존 (누구나 쓰기 가능 — 위험!)
CREATE POLICY "insert" ON my_table
  FOR INSERT WITH CHECK (true);

-- ✅ 변경 (서버만 쓰기 가능)
DROP POLICY "insert" ON my_table;
CREATE POLICY "insert" ON my_table
  FOR INSERT
  WITH CHECK (auth.role() = 'service_role');
```

- **UPDATE**도 동일하게 변경
- **SELECT**는 기존 `(true)` 유지해도 OK → anon key가 유출되어도 읽기밖에 못 함

---

## 📋 체크리스트 요약

- [ ] 서버 환경변수에 `SUPABASE_SERVICE_ROLE_KEY` 등록
- [ ] 코드에서 읽기(`anon`) / 쓰기(`service_role`) 클라이언트 분리
- [ ] INSERT/UPDATE RLS 정책을 `auth.role() = 'service_role'`로 변경
- [ ] SELECT RLS는 `(true)` 유지 (공개 읽기 OK)
- [ ] `NEXT_PUBLIC_`에 service_role key 넣지 않았는지 확인

---

## 🔗 관련 메모

- [[⭐ 크몽 코드 보안 분석 - 초보자가 알아야 할 진실]] — CodeTrust 보안 분석
