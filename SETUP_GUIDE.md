# 🚀 Kurulum Kılavuzu / Setup Guide

Bu kılavuz, Ufka Yolculuk Quiz projesini yerel makinenizde veya GitHub'dan klonladıktan sonra nasıl kuracağınızı adım adım açıklar.

This guide explains step by step how to set up the Ufka Yolculuk Quiz project on your local machine or after cloning from GitHub.

## 📋 Gereksinimler / Prerequisites

### 1. Flutter SDK Kurulumu / Flutter SDK Installation

```bash
# Flutter SDK'nın kurulu olup olmadığını kontrol edin
# Check if Flutter SDK is installed
flutter --version

# Beklenen çıktı / Expected output:
# Flutter 3.2.3 veya üzeri / Flutter 3.2.3 or higher
```

Flutter kurulu değilse:
If Flutter is not installed:
- [Flutter Resmi Kurulum Kılavuzu](https://docs.flutter.dev/get-started/install)

### 2. IDE Kurulumu / IDE Setup

Önerilen IDE'ler:
Recommended IDEs:
- **VS Code** + Flutter Extension
- **Android Studio** + Flutter Plugin

### 3. Platform Araçları / Platform Tools

#### Android için / For Android:
- Android Studio
- Android SDK (API 21 veya üzeri / API 21 or higher)
- JDK 11 veya üzeri / JDK 11 or higher

#### iOS için (sadece macOS) / For iOS (macOS only):
- Xcode 12 veya üzeri / Xcode 12 or higher
- CocoaPods

## 🔧 Adım Adım Kurulum / Step-by-Step Installation

### 1️⃣ Projeyi Klonlayın / Clone the Project

```bash
git clone https://github.com/YusufAlper17/ufka-yolculuk-quiz.git
cd ufka-yolculuk-quiz
```

### 2️⃣ Bağımlılıkları Yükleyin / Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Projeyi Kontrol Edin / Verify the Project

```bash
# Flutter kurulumunu kontrol edin
# Check Flutter installation
flutter doctor

# Projeyi analiz edin
# Analyze the project
flutter analyze

# Testleri çalıştırın
# Run tests
flutter test
```

### 4️⃣ Firebase Yapılandırması (Reklamlar için) / Firebase Configuration (For Ads)

#### 🔴 ÖNEMLİ UYARI / IMPORTANT WARNING

**GİZLİ DOSYALAR / SENSITIVE FILES:**
Proje, aşağıdaki hassas dosyaları içermemelidir. Bu dosyaları asla Git'e eklemeyin!
The project should not include the following sensitive files. Never commit these to Git!

- ❌ `android/app/google-services.json`
- ❌ `ios/Runner/GoogleService-Info.plist`
- ❌ `android/app/upload-keystore.jks`
- ❌ `android/key.properties`

#### Firebase Kurulumu / Firebase Setup

1. **Firebase Console'a Gidin / Go to Firebase Console:**
   - https://console.firebase.google.com/

2. **Yeni Proje Oluşturun / Create New Project:**
   - Proje adı girin / Enter project name
   - Google Analytics'i etkinleştirin (opsiyonel) / Enable Google Analytics (optional)

3. **Android Uygulaması Ekleyin / Add Android App:**
   ```
   Package Name: com.ufyo.quiz (veya kendi package name'iniz)
   ```
   - `google-services.json` dosyasını indirin
   - `android/app/` klasörüne kopyalayın

4. **iOS Uygulaması Ekleyin (macOS için) / Add iOS App (for macOS):**
   ```
   Bundle ID: com.ufyo.quiz (veya kendi bundle ID'niz)
   ```
   - `GoogleService-Info.plist` dosyasını indirin
   - `ios/Runner/` klasörüne kopyalayın

5. **AdMob Yapılandırması / AdMob Configuration:**
   
   `lib/services/ad_service.dart` dosyasını açın ve kendi AdMob ID'lerinizi ekleyin:
   Open `lib/services/ad_service.dart` and add your AdMob IDs:

   ```dart
   static const String _androidBannerAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
   static const String _iosBannerAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
   ```

   Test ID'leri:
   - Android: `ca-app-pub-3940256099942544/6300978111`
   - iOS: `ca-app-pub-3940256099942544/2934735716`

### 5️⃣ Android İmzalama Yapılandırması / Android Signing Configuration

**Sadece release build için gerekli / Only needed for release builds**

#### Keystore Oluşturun / Create Keystore

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

#### key.properties Oluşturun / Create key.properties

`android/key.properties` dosyası oluşturun ve şunları ekleyin:
Create `android/key.properties` file and add:

```properties
storePassword=<keystore şifreniz>
keyPassword=<key şifreniz>
keyAlias=upload
storeFile=<keystore dosyasının yolu>
```

**⚠️ DİKKAT / WARNING:**
- Bu dosyalar asla Git'e eklenmemelidir! / These files should never be committed to Git!
- `.gitignore` dosyası bunları zaten ignore eder / `.gitignore` already ignores these files

### 6️⃣ Uygulamayı Çalıştırın / Run the Application

#### Debug Modu / Debug Mode

```bash
# Cihaz/emülatör listesini görün
# View device/emulator list
flutter devices

# Uygulamayı çalıştırın
# Run the application
flutter run
```

#### Release Modu / Release Mode

```bash
# APK oluşturun
# Build APK
flutter build apk --release

# App Bundle oluşturun (Google Play için)
# Build App Bundle (for Google Play)
flutter build appbundle --release

# iOS build (sadece macOS)
# iOS build (macOS only)
flutter build ios --release
```

## 🎨 Uygulama İkonunu Değiştirme / Changing App Icon

1. İkon dosyanızı `assets/icon/app_icon.png` olarak kaydedin (1024x1024 önerilir)
   Save your icon file as `assets/icon/app_icon.png` (1024x1024 recommended)

2. `pubspec.yaml` dosyasında icon ayarlarını yapın:
   Configure icon settings in `pubspec.yaml`:

   ```yaml
   flutter_launcher_icons:
     android: true
     ios: true
     image_path: "assets/icon/app_icon.png"
   ```

3. İkonları oluşturun:
   Generate icons:

   ```bash
   flutter pub run flutter_launcher_icons
   ```

## 📱 Platform-Specific Ayarlar / Platform-Specific Settings

### Android

#### Minimum SDK Versiyonu / Minimum SDK Version

`android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
    }
}
```

#### Uygulama Adı / App Name

`android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Ufka Yolculuk"
    ...>
```

### iOS

#### Deployment Target

`ios/Podfile`:
```ruby
platform :ios, '12.0'
```

#### Bundle Identifier

Xcode'da proje ayarlarından değiştirin.
Change in Xcode project settings.

#### Uygulama Adı / App Name

`ios/Runner/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>Ufka Yolculuk</string>
```

## 🔊 Ses Dosyaları / Sound Files

Ses efektlerini kullanmak için:
To use sound effects:

1. Ses dosyalarını `assets/sounds/` klasörüne ekleyin
   Add sound files to `assets/sounds/` folder

2. `pubspec.yaml` dosyasında tanımlayın:
   Define in `pubspec.yaml`:

   ```yaml
   flutter:
     assets:
       - assets/sounds/
   ```

## 📊 Soru Verilerini Güncelleme / Updating Question Data

Soru verilerini güncellemek için:
To update question data:

1. `assets/data/processed_questions.json` dosyasını düzenleyin
   Edit `assets/data/processed_questions.json`

2. JSON formatına uygun olduğundan emin olun:
   Ensure it follows the JSON format:

   ```json
   {
     "elementary": {
       "easy": [
         {
           "question": "Soru metni",
           "options": ["A", "B", "C", "D"],
           "correct_answer": 0,
           "difficulty": "easy",
           "explanation": "Açıklama"
         }
       ]
     }
   }
   ```

## 🐛 Sorun Giderme / Troubleshooting

### "Package not found" Hatası

```bash
flutter clean
flutter pub get
```

### "Gradle build failed" Hatası

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### iOS Pod Hatası

```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
```

### "Cannot find symbol" Hatası

```bash
flutter clean
flutter pub get
flutter pub upgrade
```

## 📚 Ek Kaynaklar / Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Google AdMob Documentation](https://developers.google.com/admob)

## 💡 İpuçları / Tips

1. **Hot Reload Kullanın / Use Hot Reload:**
   - VS Code: `Ctrl/Cmd + S`
   - Komut: `r` (terminal'de)

2. **Hot Restart:**
   - VS Code: `Ctrl/Cmd + Shift + F5`
   - Komut: `R` (terminal'de)

3. **Debug Konsolu / Debug Console:**
   ```dart
   debugPrint('Debug mesajı');
   ```

4. **Flutter DevTools:**
   ```bash
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

## 🤝 Yardıma mı İhtiyacınız Var? / Need Help?

- 📝 [Issue Açın](https://github.com/YusufAlper17/ufka-yolculuk-quiz/issues)
- 📖 [CONTRIBUTING.md](CONTRIBUTING.md) dosyasını okuyun
- 💬 Discussions sekmesini kullanın

---

**Başarılar! / Good luck!** 🚀

Herhangi bir sorunla karşılaşırsanız, lütfen bir issue açın.
If you encounter any problems, please open an issue.

