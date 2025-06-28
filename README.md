# 🎬 macOS 동영상 압축 스크립트

macOS에서 동영상 파일 크기를 쉽게 줄여주는 터미널 스크립트입니다.


## ✨ 주요 기능

- 🚀 **쉬운 사용**: 드래그&드롭으로 간단한 압축
- 🎯 **품질 선택**: 고품질/보통/저품질 3단계 압축 옵션
- 📐 **해상도 조절**: 1080p, 720p, 480p 등 다양한 해상도 지원
- 📊 **압축률 표시**: 얼마나 줄어들었는지 실시간 확인
- 🔧 **자동 설치**: FFmpeg 자동 설치 및 설정
- 💾 **안전한 압축**: 원본 파일은 그대로 보존

## 📋 시스템 요구사항

- macOS (모든 버전)
- Homebrew (자동 설치됨)
- FFmpeg (자동 설치됨)

## 🛠️ 설치 및 사용법

### 1단계: 스크립트 다운로드

```bash
# Git 저장소 클론
git clone https://github.com/your-username/video-compressor-macos.git
cd video-compressor-macos

# 또는 직접 다운로드
curl -O https://raw.githubusercontent.com/your-username/video-compressor-macos/main/video_compress.sh
```

### 2단계: 실행 권한 부여

```bash
chmod +x video_compress.sh
```

### 3단계: 스크립트 실행

```bash
# 기본 실행 (파일을 드래그&드롭)
./video_compress.sh

# 파일 직접 지정
./video_compress.sh "동영상파일.mp4"
```

## 🎯 사용 방법

### 압축 품질 선택

| 품질 | CRF 값 | 파일 크기 | 용도 |
|------|--------|-----------|------|
| 고품질 | 20 | 원본의 50-70% | 중요한 영상, 아카이브용 |
| 보통품질 | 26 | 원본의 30-50% | 일반적인 용도, 웹 업로드 |
| 저품질 | 32 | 원본의 20-30% | 용량 절약, 빠른 전송 |

### 해상도 옵션

- **원본 유지**: 해상도 변경 없이 압축만
- **1080p**: 1920x1080 (Full HD)
- **720p**: 1280x720 (HD)
- **480p**: 854x480 (SD)
- **사용자 정의**: 원하는 해상도 직접 입력

## 📱 지원 파일 형식

### 입력 형식
- MP4, MOV, AVI, MKV, WMV
- M4V, FLV, WEBM, OGV
- 아이폰/안드로이드 녹화 영상

### 출력 형식
- MP4 (H.264 + AAC)
- 웹 호환성 최적화

## 💡 사용 예시

```bash
# 예시 1: 기본 실행
./video_compress.sh

# 예시 2: 파일 직접 지정
./video_compress.sh "~/Movies/여행영상.mov"

# 예시 3: 공백이 있는 파일명
./video_compress.sh "~/Desktop/내 동영상 파일.mp4"
```

## 📊 성능 비교

| 원본 크기 | 압축 후 | 압축률 | 처리 시간* |
|-----------|---------|--------|------------|
| 1GB | 300MB | 30% | 3-5분 |
| 500MB | 150MB | 30% | 2-3분 |
| 100MB | 30MB | 30% | 30-60초 |

*MacBook Pro 16인치 기준 (보통품질 설정)

## 🔧 고급 사용법

### FFmpeg 옵션 이해하기

- **CRF (Constant Rate Factor)**: 품질 조절 (18-35, 낮을수록 고품질)
- **Preset**: 압축 속도 vs 효율성
  - `ultrafast`: 가장 빠름, 큰 파일
  - `fast`: 빠름, 중간 크기
  - `medium`: 기본값, 균형
  - `slow`: 느림, 작은 파일
  - `veryslow`: 가장 느림, 가장 작은 파일

### 배치 처리 (여러 파일 압축)

```bash
# 현재 폴더의 모든 MP4 파일 압축
for file in *.mp4; do
    ./video_compress.sh "$file"
done
```

## 🚨 주의사항

1. **시간 소요**: 파일 크기에 따라 처리 시간이 오래 걸릴 수 있습니다
2. **디스크 공간**: 압축 중에는 원본 크기만큼 추가 공간이 필요합니다
3. **원본 보존**: 원본 파일은 삭제되지 않으며, 새로운 파일이 생성됩니다
4. **품질 손실**: 압축은 비가역적 과정이므로 원본보다 품질이 떨어집니다

## 🐛 문제 해결

### FFmpeg 설치 오류
```bash
# Homebrew 재설치
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# FFmpeg 수동 설치
brew install ffmpeg
```

### 권한 오류
```bash
# 실행 권한 확인
ls -la video_compress.sh

# 권한 재설정
chmod +x video_compress.sh
```

### 파일 경로 오류
- 파일명에 특수문자나 공백이 있는 경우 따옴표로 감싸주세요
- 한글 파일명도 지원됩니다

## 🤝 기여하기

1. Fork 이 저장소
2. Feature 브랜치 생성 (`git checkout -b feature/AmazingFeature`)
3. 변경사항 커밋 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 Push (`git push origin feature/AmazingFeature`)
5. Pull Request 생성

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 👨‍💻 만든 사람

- **작성자**: 정진호
- **GitHub**: https://github.com/jvisualschool 
- **이메일**: jvisualschool@gmail.com 

## 🙏 감사인사

- [FFmpeg](https://ffmpeg.org/) - 강력한 멀티미디어 프레임워크
- [Homebrew](https://brew.sh/) - macOS 패키지 관리자

## 📈 변경 이력

### v1.0.0 (2025-06-28)
- 초기 릴리스
- 기본 압축 기능
- 품질/해상도 선택 옵션
- 자동 FFmpeg 설치
