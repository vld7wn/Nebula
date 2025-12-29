@echo off
echo 🚀 Starting Secure Build (Obfuscated)
flutter build apk --release --obfuscate --split-debug-info=./build/app/outputs/symbols
echo ✅ Secure Build Completed
pause
