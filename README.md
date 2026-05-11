# Spotify 트랙 데이터 분석 프로그램

**학번:** 12233882  
**이름:** Kim Eunbi

## 프로젝트 개요

이 프로그램은 Spotify 트랙 데이터(TSV 파일)를 분석하는 bash shell 스크립트입니다. 
사용자는 메뉴 기반 인터페이스를 통해 6가지 기능을 사용할 수 있습니다.

## 기능 설명

### 1. 아티스트명/트랙명으로 검색
- **설명:** 입력한 아티스트명과 트랙명으로 곡을 검색합니다.
- **특징:** 
  - 대소문자 구분 안 함 (대소문자 자동 변환)
  - 중복 제거 (같은 곡은 1번만 표시)
  - 부분 검색 지원
- **출력:** 아티스트명, 트랙명, 에너지, 템포

### 2. 장르별 인기도 상위 5곡
- **설명:** 특정 장르의 곡 중 인기도가 높은 상위 5곡을 출력합니다.
- **특징:**
  - 대소문자 구분 안 함
  - 인기도 기준 내림차순 정렬
  - TOP 5 추출
- **출력:** 아티스트명, 트랙명, 인기도, 에너지, Valence

### 3. 재생시간 길이 상위 5곡
- **설명:** 재생시간이 가장 긴 상위 5곡을 표시합니다.
- **특징:**
  - 중복 제거 (아티스트|트랙명 조합)
  - 밀리초를 MM:SS 형식으로 자동 변환
  - 재생시간 기준 내림차순 정렬
- **출력:** 아티스트명, 트랙명, 재생시간(MM:SS)

### 4. 다중 장르 곡 분석
- **설명:** 2개 이상의 장르에 등록된 곡의 상위 5곡을 표시합니다.
- **특징:**
  - 중복 제거 (아티스트|트랙명 조합)
  - 장르 자동 병합 (파이프 기호로 연결)
  - 인기도 기준 TOP 5
- **출력:** 트랙명, 아티스트명, 병합된 장르(예: pop|dance|edm)

### 5. 트랙 통계 분석
- **설명:** 인기도 임계값을 기준으로 트랙 통계를 분석합니다.
- **특징:**
  - 사용자가 입력한 인기도 이상의 곡만 필터링
  - 중복 제거 후 통계 계산
  - 평균값 소수점 둘째자리까지 표시
- **출력:** 
  - 트랙 수
  - 평균 Danceability
  - 평균 Energy
  - 평균 Valence

### 6. 프로그램 종료
- **설명:** 프로그램을 안전하게 종료합니다.
- **출력:** "Bye!"

## 사용 방법

### 실행 방법
```bash
bash 2026-oss-project1.sh spotify_tracks.tsv
```

또는

```bash
./2026-oss-project1.sh spotify_tracks.tsv
```

### 필수 요구사항
- Bash 셸
- spotify_tracks.tsv 파일 (TSV 형식)
- AWK, sort, head 등 표준 Unix 유틸리티

## 사용 예시

### 예시 1: 아티스트/트랙명 검색
```
Enter your COMMAND (1-6) : 1
Enter an artist name to search: 5 seconds of summer
Enter a track name to search: youngblood

Search results for "5 seconds of summer" / "youngblood":
artists                        track_name                       energy    tempo
5 Seconds of Summer            Youngblood                         0.82      120.1
```

### 예시 2: 장르별 인기도 검색
```
Enter your COMMAND (1-6) : 2
Enter a genre: pop

Top 5 tracks by popularity in "pop":
The Weeknd                     Blinding Lights                   100  0.84  0.73
Taylor Swift                   Blank Space                        97  0.71  0.82
...
```

### 예시 3: 재생시간 길이
```
Enter your COMMAND (1-6) : 3

Top 5 longest tracks by duration:
Timo Maas                      Crossing Wires 002...             79:49
...
```

### 예시 4: 다중 장르 곡
```
Enter your COMMAND (1-6) : 4

Tracks appearing in multiple genres (top 5 by popularity):
Unholy (feat. Kim Petras)      Sam Smith;Kim Petras              dance|pop
...
```

### 예시 5: 통계 분석
```
Enter your COMMAND (1-6) : 5
Enter minimum popularity threshold: 90

popularity >= 90 tracks: 42
avg danceability: 0.67
avg energy: 0.67
avg valence: 0.44
```

### 예시 6: 프로그램 종료
```
Enter your COMMAND (1-6) : 6

Bye!
```

## 에러 처리

### 파일 인자 없음
```bash
$ ./2026-oss-project1.sh

usage: ./2026-oss-project1.sh file
```

### 존재하지 않는 파일
```bash
$ ./2026-oss-project1.sh nonexistent.tsv

Error: Data file not found - nonexistent.tsv
```

### 올바른 실행
```bash
$ ./2026-oss-project1.sh spotify_tracks.tsv

StudentID : 12233882
Name : Kim Eunbi

[MENU]
...
```

## 기술 특징

- **언어:** Bash Shell Script
- **도구:** AWK, sort, grep
- **인코딩:** LC_ALL=C (바이트 단위 처리)
- **정렬:** 내림차순 숫자 정렬
- **중복 제거:** 아티스트|트랙명 조합 키 사용
- **형식 변환:** 밀리초 → MM:SS (분:초)

## 데이터 컬럼 정보

| 컬럼 | 설명 |
|------|------|
| $2 | 아티스트명 (artists) |
| $4 | 트랙명 (track_name) |
| $5 | 인기도 (popularity) |
| $6 | 재생시간(ms) (duration_ms) |
| $8 | Danceability (danceability) |
| $9 | Energy (energy) |
| $17 | Valence (valence) |
| $18 | Tempo (tempo) |
| $20 | 장르 (track_genre) |

## 주요 구현 특징

### BEGIN 블록을 이용한 성능 최적화
```bash
BEGIN {
    artist_lower = tolower(a)
    track_lower = tolower(t)
}
```
- 입력값을 BEGIN에서 한 번만 처리
- 매 레코드마다 반복 처리 방지

### 중복 제거
```bash
key = $2 "|" $4
if (!(key in seen)) {
    seen[key] = 1
    // 처리
}
```
- 아티스트와 트랙명 조합으로 고유성 보장

### 시간 형식 변환
```bash
minutes = int(ms / 60000)
seconds = int((ms % 60000) / 1000)
printf "%02d:%02d", minutes, seconds
```
- 밀리초를 MM:SS 형식으로 자동 변환

### 인코딩 처리
```bash
LC_ALL=C awk -F'\t' ...
```
- 바이트 단위 처리로 인코딩 오류 방지

## 주의사항

1. **파일 경로:** spotify_tracks.tsv 파일이 있는 디렉토리에서 실행해야 합니다.
2. **파일 형식:** TSV(Tab-Separated Values) 형식이어야 합니다.
3. **라인 엔딩:** Unix 라인 엔딩(LF)을 사용해야 합니다.
4. **실행 권한:** 스크립트에 실행 권한이 필요합니다.
   ```bash
   chmod +x 2026-oss-project1.sh
   ```

## 라이선스

학교 과제용 프로젝트
