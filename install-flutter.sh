#!/bin/bash

# Configuration
FLUTTER_CHANNEL="stable"
FLUTTER_VERSION="3.29.0" # Example version, will fetch stable if not specified exactly correctly

echo "--- Installing Flutter SDK ---"

if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b $FLUTTER_CHANNEL
fi

./flutter/bin/flutter precache --web

echo "--- Flutter Installation Complete ---"
