#!/bin/bash

echo "🧹 Cleaning Flutter project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🗑️  Removing old Android build..."
rm -rf android/.gradle
rm -rf android/app/build
rm -rf build/

echo "🔨 Building and running app..."
flutter run

echo "✅ Done!"
