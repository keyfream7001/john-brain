---
tags: [type/dashboard, type/project, project/mohim, dev/flutter, dev/supabase, status/inProgress, priority/high]
created: 2026-02-04
updated: 2026-07-17
---

# ?�� Mohim - 목표 관�?& 추적 ??
## ?�� 개요
- **?�명**: 목표�?체계?�으�??�정?�고 추적?�는 모바????- "Your Goals, Your Way"
- **기술 ?�택**: Flutter (Dart), Supabase (PostgreSQL + Auth + Edge Functions), Riverpod
- **?�치**: C:\JohnCodeQ\Mohim\ (?�정)

## ?���?주요 기능
- 목표 ?�정 (SMART 기반)
- 진행�?추적 (?�?�보??
- ?��? ?�래�?- 리마?�더/?�림
- ?�계 �?분석

## ?�� ?�로?�트 구조
```
lib/
?��??� core/         # ?�정, ?�마
?��??� features/     # 목표, ?��?, ?�계
?��??� shared/       # 공통 ?�젯
?��??� main.dart
```

## ?�� ?�재 ?�태
기획 ?�계 - ?�직 코딩 ?�작 ??
## ?�� ?�음 ?�계
- Flutter ?�로?�트 초기??- Supabase ?�키�??�계
- 목표 CRUD 구현
- ?�?�보??UI

## ?�� 관???�트

```dataview
TABLE tags AS "?�그", status AS "?�태"
FROM "800 Outputs/801 Apps/Mohim"
WHERE file.name != "Dashboard"
SORT file.ctime DESC
```
