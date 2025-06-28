#!/bin/bash

# 동영상 압축 스크립트 for macOS
# 작성자: Claude AI
# 설명: 동영상 파일의 크기를 줄여주는 스크립트입니다.

echo "🎬 동영상 압축 도구에 오신 것을 환영합니다!"
echo "======================================"

# FFmpeg 설치 확인
check_ffmpeg() {
    if ! command -v ffmpeg &> /dev/null; then
        echo "❌ FFmpeg가 설치되지 않았습니다."
        echo "📦 Homebrew를 통해 FFmpeg를 설치하시겠습니까? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo "🔄 FFmpeg 설치 중..."
            if ! command -v brew &> /dev/null; then
                echo "❌ Homebrew가 설치되지 않았습니다."
                echo "🌐 다음 링크에서 Homebrew를 먼저 설치해주세요: https://brew.sh"
                exit 1
            fi
            brew install ffmpeg
            echo "✅ FFmpeg 설치 완료!"
        else
            echo "❌ FFmpeg가 없으면 스크립트를 실행할 수 없습니다."
            exit 1
        fi
    else
        echo "✅ FFmpeg가 설치되어 있습니다."
    fi
}

# 입력 파일 확인
get_input_file() {
    if [ $# -eq 0 ]; then
        echo "📁 압축할 동영상 파일을 드래그&드롭하거나 경로를 입력하세요:"
        read -r INPUT_FILE
    else
        INPUT_FILE="$1"
    fi
    
    # 파일 경로에서 따옴표 제거
    INPUT_FILE=$(echo "$INPUT_FILE" | tr -d '"'"'"'')
    
    if [ ! -f "$INPUT_FILE" ]; then
        echo "❌ 파일을 찾을 수 없습니다: $INPUT_FILE"
        exit 1
    fi
    
    echo "📂 입력 파일: $INPUT_FILE"
}

# 파일 정보 표시
show_file_info() {
    echo "📊 원본 파일 정보:"
    echo "   크기: $(du -h "$INPUT_FILE" | cut -f1)"
    echo "   해상도: $(ffprobe -v quiet -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$INPUT_FILE" | tr ',' 'x')"
    echo "   코덱: $(ffprobe -v quiet -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$INPUT_FILE")"
}

# 압축 품질 선택
choose_quality() {
    echo ""
    echo "🎯 압축 품질을 선택하세요:"
    echo "1) 고품질 (파일 크기: 원본의 50-70%)"
    echo "2) 보통품질 (파일 크기: 원본의 30-50%)"
    echo "3) 저품질 (파일 크기: 원본의 20-30%)"
    echo "4) 사용자 정의"
    
    read -p "선택 (1-4): " quality_choice
    
    case $quality_choice in
        1)
            CRF=20
            PRESET="slow"
            echo "✨ 고품질 압축 선택"
            ;;
        2)
            CRF=26
            PRESET="medium"
            echo "⚖️ 보통품질 압축 선택"
            ;;
        3)
            CRF=32
            PRESET="fast"
            echo "📦 저품질 압축 선택"
            ;;
        4)
            echo "CRF 값을 입력하세요 (18-35, 낮을수록 고품질): "
            read -r CRF
            echo "프리셋을 선택하세요 (ultrafast/fast/medium/slow/veryslow): "
            read -r PRESET
            ;;
        *)
            echo "❌ 잘못된 선택입니다. 보통품질로 설정합니다."
            CRF=26
            PRESET="medium"
            ;;
    esac
}

# 해상도 선택
choose_resolution() {
    echo ""
    echo "📐 해상도를 선택하세요:"
    echo "1) 원본 해상도 유지"
    echo "2) 1080p (1920x1080)"
    echo "3) 720p (1280x720)"
    echo "4) 480p (854x480)"
    echo "5) 사용자 정의"
    
    read -p "선택 (1-5): " resolution_choice
    
    case $resolution_choice in
        1)
            SCALE=""
            echo "📏 원본 해상도 유지"
            ;;
        2)
            SCALE="-vf scale=1920:1080"
            echo "📺 1080p로 변경"
            ;;
        3)
            SCALE="-vf scale=1280:720"
            echo "📱 720p로 변경"
            ;;
        4)
            SCALE="-vf scale=854:480"
            echo "📞 480p로 변경"
            ;;
        5)
            echo "가로 해상도를 입력하세요: "
            read -r width
            echo "세로 해상도를 입력하세요: "
            read -r height
            SCALE="-vf scale=$width:$height"
            echo "🎯 ${width}x${height}로 변경"
            ;;
        *)
            SCALE=""
            echo "❌ 잘못된 선택입니다. 원본 해상도를 유지합니다."
            ;;
    esac
}

# 출력 파일명 생성
generate_output_filename() {
    # 파일명과 확장자 분리
    FILENAME=$(basename "$INPUT_FILE")
    NAME="${FILENAME%.*}"
    EXT="${FILENAME##*.}"
    
    # 출력 파일명 생성
    OUTPUT_FILE="$(dirname "$INPUT_FILE")/${NAME}_compressed.${EXT}"
    
    # 파일이 이미 존재하는 경우 번호 추가
    counter=1
    while [ -f "$OUTPUT_FILE" ]; do
        OUTPUT_FILE="$(dirname "$INPUT_FILE")/${NAME}_compressed_${counter}.${EXT}"
        ((counter++))
    done
    
    echo "💾 출력 파일: $OUTPUT_FILE"
}

# 동영상 압축 실행
compress_video() {
    echo ""
    echo "🚀 압축을 시작합니다..."
    echo "⏰ 파일 크기에 따라 시간이 걸릴 수 있습니다."
    
    # FFmpeg 명령어 구성
    FFMPEG_CMD="ffmpeg -i \"$INPUT_FILE\" -c:v libx264 -crf $CRF -preset $PRESET $SCALE -c:a aac -b:a 128k \"$OUTPUT_FILE\""
    
    echo "🔧 실행 명령어: $FFMPEG_CMD"
    echo ""
    
    # 압축 실행
    eval $FFMPEG_CMD
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ 압축이 완료되었습니다!"
        echo "📊 결과 비교:"
        echo "   원본: $(du -h "$INPUT_FILE" | cut -f1)"
        echo "   압축: $(du -h "$OUTPUT_FILE" | cut -f1)"
        
        # 압축률 계산
        original_size=$(stat -f%z "$INPUT_FILE")
        compressed_size=$(stat -f%z "$OUTPUT_FILE")
        compression_ratio=$(echo "scale=1; $compressed_size * 100 / $original_size" | bc)
        echo "   압축률: ${compression_ratio}% (원본 대비)"
        
        echo ""
        echo "🎉 압축된 파일: $OUTPUT_FILE"
    else
        echo "❌ 압축 중 오류가 발생했습니다."
        exit 1
    fi
}

# 메인 실행
main() {
    check_ffmpeg
    get_input_file "$@"
    show_file_info
    choose_quality
    choose_resolution
    generate_output_filename
    compress_video
}

# 스크립트 실행
main "$@"