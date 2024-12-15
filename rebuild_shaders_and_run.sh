#!/bin/zsh

echo "🧹 Cleaning Flutter build..."
flutter clean

echo "\n📦 Getting dependencies..."
flutter pub get

echo "\n🚀 Running app with Impeller..."
flutter run -d macos --enable-impeller 