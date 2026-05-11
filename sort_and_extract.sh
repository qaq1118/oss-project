#!/bin/bash

# 📊 3단계: 정렬과 상위 추출 (기능 2, 3번)
# 특정 장르로 필터링 → 정렬 → 상위 추출

DATA_FILE="/sessions/awesome-eloquent-hopper/mnt/oss_project1/spotify_tracks.tsv"

echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║         🎵 Spotify 트랙 필터링, 정렬 및 시간 변환 도구          ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""

# 사용 가능한 장르 목록 표시
echo "📚 사용 가능한 장르 샘플:"
cut -f20 "$DATA_FILE" | sort | uniq | head -20 | sed 's/^/   /'
echo ""

# 사용자로부터 장르 입력받기
read -p "필터링할 장르를 입력하세요: " genre_input

echo ""
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║  🎯 기능 2: 장르별 인기도 Top 10 (인기도 기준 내림차순 정렬)    ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""

awk -F'\t' -v genre="$genre_input" '
  $20 == genre {
    printf "%s\t%s\t%d\n", $2, $4, $5
  }
' "$DATA_FILE" | sort -t$'\t' -k3 -rn | head -10 | \
awk -F'\t' '{printf "#%-2d | %-32s | %-40s | 🔥 %3s\n", NR, substr($1,1,32), substr($2,1,40), $3}'

echo ""
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║  ⏱️  기능 3: 곡 재생 시간 변환 (mm:ss) - 인기도 Top 10         ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""

awk -F'\t' -v genre="$genre_input" '
  $20 == genre {
    ms = $6
    
    # awk 산술 연산으로 ms를 mm:ss 형식으로 변환
    minutes = int(ms / 60000)
    seconds = int((ms % 60000) / 1000)
    
    printf "%s\t%s\t%02d:%02d\t%d\n", $2, $4, minutes, seconds, $5
  }
' "$DATA_FILE" | sort -t$'\t' -k5 -rn | head -10 | \
awk -F'\t' '{printf "#%-2d | %-32s | %-40s | ⏱️  %s | 🔥 %3s\n", NR, substr($1,1,32), substr($2,1,40), $3, $4}'

echo ""
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║  ⏱️  보너스: 가장 긴 곡 Top 5 (재생 시간 기준)                  ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""

awk -F'\t' -v genre="$genre_input" '
  $20 == genre {
    ms = $6
    minutes = int(ms / 60000)
    seconds = int((ms % 60000) / 1000)
    printf "%s\t%s\t%02d:%02d\t%d\n", $2, $4, minutes, seconds, $6
  }
' "$DATA_FILE" | sort -t$'\t' -k4 -rn | head -5 | \
awk -F'\t' '{printf "#%-2d | %-32s | %-40s | ⏱️  %s\n", NR, substr($1,1,32), substr($2,1,40), $3}'

echo ""
echo "✅ 완료!"
