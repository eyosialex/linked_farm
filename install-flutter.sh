#!/bin/bash

# Configuration
FLUTTER_CHANNEL="stable"

echo "--- Installing Flutter SDK ---"

# Use shallow clone for speed
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b $FLUTTER_CHANNEL --depth 1
fi

# Add flutter to PATH
export PATH="$PATH:$(pwd)/flutter/bin"

flutter doctor -v
flutter precache --web

echo "--- Installing Dependencies ---"
flutter pub get

echo "--- Flutter Installation Complete ---"
