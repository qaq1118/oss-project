#!/bin/bash

# Check if file argument is provided
if [ $# -eq 0 ]; then
    echo "usage: ./2026-oss-project1.sh file"
    exit 1
fi

DATA_FILE="$1"
STUDENT_ID="12233882"
STUDENT_NAME="Kim Eunbi"

# Check if data file exists
if [ ! -f "$DATA_FILE" ]; then
    echo "Error: Data file not found - $DATA_FILE"
    exit 1
fi

echo ""
echo "StudentID : $STUDENT_ID"
echo "Name : $STUDENT_NAME"
echo ""

while true; do
    echo "[MENU]"
    echo "1. Search tracks by artist name and track name"
    echo "2. List top 5 tracks by popularity in a specific genre"
    echo "3. Show top 5 longest tracks by duration"
    echo "4. Merge duplicate tracks and combine genres"
    echo "5. Analyze tracks - count, avg danceability, energy, valence"
    echo "6. Quit"
    echo ""

    read -p "Enter your COMMAND (1-6) : " choice
    echo ""

    case $choice in
        1)
            read -p "Enter an artist name to search: " artist
            read -p "Enter a track name to search: " track
            echo ""
            echo "Search results for \"$artist\" / \"$track\":"
            printf "%-30s %-30s %8s %8s\n" "artists" "track_name" "energy" "tempo"

            LC_ALL=C awk -F'\t' -v a="$artist" -v t="$track" '
                BEGIN {
                    artist_lower = tolower(a)
                    track_lower = tolower(t)
                }
                NR > 1 {
                    key = $2 "|" $4
                    if (!(key in seen)) {
                        seen[key] = 1
                        if (index(tolower($2), artist_lower) > 0 && index(tolower($4), track_lower) > 0) {
                            printf "%-30s %-30s %8s %8s\n", $2, $4, $9, $18
                        }
                    }
                }
            ' "$DATA_FILE"
            echo ""
            ;;

        2)
            read -p "Enter a genre: " genre
            echo ""
            echo "Top 5 tracks by popularity in \"$genre\":"

            LC_ALL=C awk -F'\t' -v g="$genre" '
                BEGIN {
                    genre_lower = tolower(g)
                }
                NR > 1 && tolower($20) == genre_lower {
                    printf "%s\t%s\t%d\t%s\t%s\n", $2, $4, $5, $9, $17
                }
            ' "$DATA_FILE" | LC_ALL=C sort -t$'\t' -r -k 3 -n | head -5 | \
            awk -F'\t' '{printf "%-30s %-30s  %3d  %s  %s\n", $1, $2, $3, $4, $5}'
            echo ""
            ;;

        3)
            echo "Top 5 longest tracks by duration:"

            awk -F'\t' '
                NR > 1 {
                    key = $2 "|" $4
                    if (!(key in seen)) {
                        seen[key] = 1
                        ms = $6
                        minutes = int(ms / 60000)
                        seconds = int((ms % 60000) / 1000)
                        printf "%s\t%s\t%02d:%02d\t%d\n", $2, $4, minutes, seconds, ms
                    }
                }
            ' "$DATA_FILE" | LC_ALL=C sort -t$'\t' -r -k 4 -n | head -5 | \
            awk -F'\t' '{printf "%-30s %-30s %s\n", $1, $2, $3}'
            echo ""
            ;;

        4)
            echo "Tracks appearing in multiple genres (top 5 by popularity):"

            awk -F'\t' '
                NR > 1 {
                    key = $2 "|" $4
                    if (!(key in trackInfo)) {
                        trackInfo[key] = 1
                        artists[key] = $2
                        tracks[key] = $4
                        popularity[key] = $5
                    }

                    if (genres[key] == "") {
                        genres[key] = $20
                    } else if (genres[key] !~ $20) {
                        genres[key] = genres[key] "|" $20
                    }
                    genreCount[key] = split(genres[key], arr, "|")
                }
                END {
                    for (key in trackInfo) {
                        if (genreCount[key] >= 2) {
                            printf "%s\t%s\t%s\t%d\n", tracks[key], artists[key], genres[key], popularity[key]
                        }
                    }
                }
            ' "$DATA_FILE" | LC_ALL=C sort -t$'\t' -r -k 4 -n | head -5 | \
            awk -F'\t' '{printf "%-30s %-30s %s\n", $1, $2, $3}'
            echo ""
            ;;

        5)
            read -p "Enter minimum popularity threshold: " threshold
            echo ""

            awk -F'\t' -v t="$threshold" '
                NR > 1 && $5 >= t {
                    key = $2 "|" $4
                    if (!(key in seen)) {
                        seen[key] = 1
                        count++
                        dance_sum += $8
                        energy_sum += $9
                        valence_sum += $17
                    }
                }
                END {
                    if (count > 0) {
                        printf "popularity >= %s tracks: %d\n", t, count
                        printf "avg danceability: %.2f\n", dance_sum / count
                        printf "avg energy: %.2f\n", energy_sum / count
                        printf "avg valence: %.2f\n", valence_sum / count
                    } else {
                        printf "No tracks found with popularity >= %s\n", t
                    }
                }
            ' "$DATA_FILE"
            echo ""
            ;;

        6)
            echo "Bye!"
            break
            ;;

        *)
            echo "Invalid choice. Please enter 1-6."
            echo ""
            ;;
    esac
done
