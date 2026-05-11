# 📊 3단계 완성: 정렬과 상위 추출 (기능 2, 3번)

## ✅ 검증 완료

### 핵심 학습 내용

#### 🎯 기능 2: 필터링 + 정렬 + 상위 추출

**awk 명령**:
```awk
awk -F'\t' '$20 == genre {
  printf "%s\t%s\t%d\n", $2, $4, $5
}' "$DATA_FILE"
```

**sort 명령** (인기도 기준 내림차순):
```bash
sort -t$'\t' -k3 -rn | head -10
```

- `-t$'\t'`: 탭을 구분자로 지정
- `-k3`: 3번째 열(인기도) 기준 정렬
- `-rn`: 역순(내림차순) + 숫자 비교
- `head -10`: 상위 10개만 추출

**테스트 결과**:
```
🎯 acoustic 장르 - Top 3
#1  | Chord Overstreet          | Hold On                          | 🔥  82
#2  | Jason Mraz                | I'm Yours                        | 🔥  80
#3  | Zack Tabudlo              | Pano                             | 🔥  75

🎯 blues 장르 - Top 3
#1  | The White Stripes         | Seven Nation Army                | 🔥  84
#2  | Lynyrd Skynyrd            | Sweet Home Alabama               | 🔥  81
#3  | Cage The Elephant         | Cigarette Daydreams              | 🔥  79
```

---

#### ⏱️ 기능 3: 재생 시간 변환 (ms → mm:ss)

**핵심 산술 연산**:
```awk
ms = $6  # 밀리초 단위 재생 시간

# awk 내부 산술 연산
minutes = int(ms / 60000)           # 밀리초 → 분
seconds = int((ms % 60000) / 1000)  # 나머지 → 초

# 형식화
printf "%02d:%02d", minutes, seconds
```

**계산 과정 예시**:
- 입력: `240000` ms
- `minutes = int(240000 / 60000) = 4`
- `seconds = int((240000 % 60000) / 1000) = int(0 / 1000) = 0`
- 출력: `04:00`

**더 복잡한 예**:
- 입력: `246000` ms
- `minutes = int(246000 / 60000) = 4`
- `seconds = int((246000 % 60000) / 1000) = int(6000 / 1000) = 6`
- 출력: `04:06` ✓

**테스트 결과**:
```
⏱️ acoustic 장르 - Top 3
#1  | krissy & ericka           | 12:51                        | ⏱️  04:06 | 🔥  64
#2  | Zee Avi                   | No Christmas For Me          | ⏱️  02:40 | 🔥   0
#3  | Zee Avi                   | Dream a Little Dream of Me   | ⏱️  01:51 | 🔥  50

⏱️ pop 장르 - 가장 긴 곡 Top 3
#1  | Hariharan                 | Shree Hanuman Chalisa        | ⏱️  09:46
#2  | Madhur Sharma;Nusrat Fate | Medley: Kehna Galat Galat... | ⏱️  08:10
#3  | A.R. Rahman;Javed Ali;Mo  | Kun Faya Kun                 | ⏱️  07:50
```

---

## 📁 생성된 파일

### 1. `sort_and_extract.sh` (실행 스크립트)
- 장르 입력받기
- 기능 2: 인기도 Top 10 표시
- 기능 3: 재생 시간 변환 후 표시
- 보너스: 가장 긴 곡 Top 5

### 사용 방법
```bash
bash sort_and_extract.sh
# 프롬프트: "필터링할 장르를 입력하세요: acoustic"
```

---

## 🔧 문제 해결

**파일 형식 문제**: 원본 파일이 Windows 줄 끝(`\r\n`)을 가지고 있어서, 처음에는 장르 필터링이 작동하지 않았음.

**해결**:
```bash
sed -i 's/\r$//' spotify_tracks.tsv
```

→ 파일을 Unix 형식(`\n`)으로 변환하여 문제 해결 ✓

---

## 🎓 학습 포인트

| 기능 | 명령어 | 용도 |
|------|--------|------|
| 필터링 | `awk '$20 == genre'` | 특정 조건으로 행 선택 |
| 정렬 | `sort -k3 -rn` | 특정 열 기준으로 내림차순 정렬 |
| 상위 추출 | `head -10` | 상위 N개만 추출 |
| 산술 연산 | `int(ms / 60000)` | awk 내부에서 계산 수행 |
| 형식화 | `printf "%02d:%02d"` | 0-패딩으로 시간 형식화 |

---

## ✨ 다음 단계

다음 단계에서는:
- 여러 조건으로 필터링 (AND, OR)
- 그룹화 및 집계 (GROUP BY 같은 기능)
- 통계 계산 (평균, 중앙값, 표준편차)

**"데이터를 제대로 읽고 있다"는 확신이 생겼습니다!** 🚀
