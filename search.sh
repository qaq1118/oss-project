#!/bin/bash

# 🔍 2단계: 데이터 읽기와 기초 검색 (기능 1번)
# 아티스트와 곡명을 입력받아 대소문자 구분 없이 검색

DATA_FILE="/sessions/awesome-eloquent-hopper/mnt/oss_project1/spotify_tracks.tsv"

echo "=== Spotify 트랙 검색 (대소문자 무시) ==="
echo ""

# 아티스트 입력받기
read -p "검색할 아티스트 이름을 입력하세요: " artist_input

# 곡명 입력받기
read -p "검색할 곡명을 입력하세요: " track_input

echo ""
echo "🔍 검색 중... (아티스트: '$artist_input', 곡: '$track_input')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# awk로 검색 (tolower()를 사용해 대소문자 구분 없이)
awk -F'\t' -v artist="$artist_input" -v track="$track_input" '
  NR > 1 {  # 헤더 제외
    # tolower()를 사용해 대소문자 무시하고 비교
    if (tolower($2) ~ tolower(artist) && tolower($4) ~ tolower(track)) {
      printf "✓ 찾음!\n"
      printf "  아티스트: %s\n", $2
      printf "  곡명: %s\n", $4
      printf "  앨범: %s\n", $3
      printf "  인기도: %s\n", $5
      printf "  장르: %s\n", $NF
      printf "\n"
    }
  }
' "$DATA_FILE"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 검색 완료!"
