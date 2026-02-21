---
tags: [type/dashboard, type/project, project/app, dev/flutter, dev/supabase, ai/automation, status/inProgress]
created: 2026-02-03
updated: 2026-07-17
---

# ?�� LottoMate - AI 로또 번호 추천

## ?�� 개요
- **?�명**: AI 기반 로또 번호 추천 ??- **기술 ?�택**: Flutter 3.6+, Riverpod, GoRouter, Supabase, fl_chart, flutter_animate
- **?�치**: C:\JohnCodeQ\LottoMate\

## ?���?주요 기능
- ?�덤 번호 ?�성 (1-45 �?6�?
- AI 번호 추천 (균형/?�넘�?콜드?�버/?�합 ?�략)
- ??? ?�첨번호 조회 (1?�차~최신)
- 번호 ?�??�?관�?- ?�계 차트 (출현빈도, ?�짝분?? 구간분포)
- Google ?�셜 로그??
## ?�� ?�로?�트 구조
```
lib/
?��??� core/         # ?�수, ?�마, ?�우???��??� data/         # 모델, ?�포지?�리, ?�비???��??� features/     # auth, home, generate, history, statistics, profile
?��??� shared/       # 공통 ?�젯
```
DB ?�이�? users, lotto_results, saved_numbers, ai_history, number_statistics

## ?�� ?�재 ?�태
MVP ?�성 - ?�크모드, 로또�??�니메이?? Material 3 ?�자??
## ?�� ?�음 ?�계
- QR ?�첨?�인 기능
- ?�시 ?�림 (?�첨결과, 구매 리마?�더)
- ?�리미엄 결제 ?�스??- Apple, Kakao 로그??추�?
