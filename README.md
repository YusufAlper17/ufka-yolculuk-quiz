# Ufka Yolculuk - Bilgi ve Kültür Yarışması

> [English version available here](README_EN.md)

12. Ufka Yolculuk Bilgi ve Kültür Yarışması'ndan ilham alınarak geliştirilmiş kişisel bir mobil uygulama projesidir. Çeşitli yaş grupları için tasarlanmış bu uygulama, "Maske Düştü", "Zamansızlar Mektebi - Hak Muhafızları", "Yolların Kanunu" ve "İncinsen de İncitme" eserlerinden hazırlanmış sorularla kullanıcılara interaktif bir öğrenme deneyimi sunmayı amaçlamaktadır.

## Ekran Görüntüleri

<p align="center">
  <img src="screenshots/1-home.png" alt="Ana Sayfa" width="200"/>
  <img src="screenshots/2-level-selection.png" alt="Seviye Seçimi" width="200"/>
  <img src="screenshots/3-exam-selection.png" alt="Sınav Seçimi" width="200"/>
</p>

<p align="center">
  <img src="screenshots/4-quiz-question.png" alt="Soru Ekranı" width="200"/>
  <img src="screenshots/5-quiz-answer.png" alt="Cevaplı Soru" width="200"/>
  <img src="screenshots/6-quiz-result.png" alt="Sınav Sonucu" width="200"/>
</p>

## Proje Hakkında

Bu uygulama, 12. Ufka Yolculuk Bilgi ve Kültür Yarışması'nı mobil platformda deneyimlemek için geliştirilmiş kişisel bir projedir. Farklı yaş gruplarına hitap eden eğitici içeriklerle, bilgi ve kültür seviyesini ölçmeyi hedeflemektedir. Yarışma formatında tasarlanmış interaktif sorularla kullanıcılara eğlenceli bir öğrenme deneyimi sunmaya çalışmaktadır.

## Kaynak Eserler

Uygulama içeriği aşağıdaki eserlerden hazırlanmıştır:

| Kategori | Eser | Hedef Kitle |
|----------|------|-------------|
| İlkokul | Maske Düştü | 6-10 yaş |
| Ortaokul | Zamansızlar Mektebi - Hak Muhafızları | 11-14 yaş |
| Lise | Yolların Kanunu | 15-18 yaş |
| Yetişkin | İncinsen de İncitme | 18+ yaş |

### İçerik Üretimi

Uygulamadaki sorular, cevaplar ve açıklamalar yapay zeka teknolojisi kullanılarak yukarıdaki eserlerden hazırlanmıştır. Her soru seti, ilgili kitabın içeriğine sadık kalınarak ve hedef yaş grubuna uygun zorluk seviyesinde oluşturulmuştur.

## Özellikler

**Kategori ve Zorluk Seviyeleri**
- 4 farklı kategori: İlkokul, Ortaokul, Lise ve Yetişkin
- Her kategoride 3 zorluk seviyesi: Kolay, Orta ve Zor
- Kategori bazında ilerleme takibi
- Seviye kilit sistemi ile aşamalı ilerleme

**Quiz Özellikleri**
- Her sınavda 10 çoktan seçmeli soru
- Zamanlı sınav modu
- Anlık geri bildirim ve açıklamalar
- Detaylı sonuç raporu
- Doğru/yanlış cevap istatistikleri

**Kullanıcı Deneyimi**
- Modern ve kullanıcı dostu arayüz
- Koyu ve açık tema desteği
- Ses efektleri ile interaktif deneyim
- Smooth animasyonlar
- Offline çalışma desteği

**İlerleme Sistemi**
- Tamamlanan sınavlara göre kilitlenen/açılan seviyeler
- Skor ve performans takibi
- Sınav geçmişi
- Her seviyede 10 farklı deneme

## Teknik Bilgiler

**Geliştirme Ortamı**
- Framework: Flutter 3.2.3+
- Dil: Dart 3.0+
- Minimum SDK: Android API 21, iOS 12.0

**Kullanılan Kütüphaneler**
- State Management: Provider
- Yerel Depolama: SharedPreferences
- Font: Google Fonts (Poppins, Inter)
- Animasyonlar: AnimateDo, Shimmer, Flutter Staggered Animations
- Ses: AudioPlayers
- Reklamlar: Google Mobile Ads

```yaml
dependencies:
  provider: ^6.1.2
  shared_preferences: ^2.2.3
  google_mobile_ads: ^5.1.0
  google_fonts: ^6.2.1
  audioplayers: ^6.0.0
  animate_do: ^3.3.4
  shimmer: ^3.0.0
  flutter_staggered_animations: ^1.1.1
```

## Kurulum

### Gereksinimler

- Flutter SDK 3.2.3 veya üzeri
- Dart SDK 3.0.0 veya üzeri
- Android Studio veya Xcode (platform bazlı)

### Kurulum Adımları

1. Repository'yi klonlayın:
```bash
git clone https://github.com/YusufAlper17/ufka-yolculuk-quiz.git
cd ufka-yolculuk-quiz
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Uygulamayı çalıştırın:
```bash
flutter run
```

Detaylı kurulum bilgileri için [SETUP_GUIDE.md](SETUP_GUIDE.md) dosyasına bakabilirsiniz.

### Firebase Yapılandırması (Opsiyonel)

Reklam özelliğini kullanmak için Firebase yapılandırması gereklidir:
- `google-services.json` dosyasını `android/app/` dizinine ekleyin
- `GoogleService-Info.plist` dosyasını `ios/Runner/` dizinine ekleyin

## Proje Yapısı

```
lib/
├── core/
│   ├── constants/       # Uygulama sabitleri
│   ├── providers/       # Global state yönetimi
│   └── theme/          # Tema ve renk tanımları
├── modules/
│   ├── home/           # Ana sayfa - Kategori seçimi
│   ├── level/          # Seviye seçimi
│   ├── exam/           # Sınav seçimi
│   └── quiz/           # Quiz ve sonuç ekranları
│       ├── models/     # Veri modelleri
│       └── widgets/    # Özel widget'lar
├── services/           # Servis katmanı
└── main.dart          # Uygulama başlangıç noktası

assets/
├── data/              # Soru veritabanı (JSON)
├── icon/              # Uygulama ikonu
├── images/            # Görseller
└── sounds/            # Ses dosyaları
```

## Veri Yapısı

Sorular JSON formatında `assets/data/processed_questions.json` dosyasında saklanır:

```json
{
  "elementary": {
    "easy": [
      {
        "question": "Soru metni",
        "options": ["Seçenek A", "Seçenek B", "Seçenek C", "Seçenek D"],
        "correct_answer": 0,
        "difficulty": "easy",
        "explanation": "Cevap açıklaması"
      }
    ],
    "medium": [...],
    "hard": [...]
  },
  "middle_school": {...},
  "high_school": {...},
  "adult": {...}
}
```

## Build

### Android

APK oluşturma:
```bash
flutter build apk --release
```

App Bundle oluşturma (Google Play için):
```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Katkıda Bulunma

Projeye katkıda bulunmak isterseniz lütfen [CONTRIBUTING.md](CONTRIBUTING.md) dosyasını inceleyin.

### Katkı Süreci

1. Projeyi fork edin
2. Özellik dalı oluşturun (`git checkout -b feature/yeni-ozellik`)
3. Değişikliklerinizi commit edin (`git commit -m 'feat: yeni özellik eklendi'`)
4. Dalınızı push edin (`git push origin feature/yeni-ozellik`)
5. Pull Request oluşturun

### Geliştirme Kuralları

- Flutter/Dart kod standartlarına uyun
- Yorum satırlarını Türkçe yazın
- Yeni özellikler için dokümantasyon ekleyin
- Büyük değişiklikler için önce issue açın

## Hata Bildirimi

Bir hata bulduysanız lütfen [issue açın](https://github.com/YusufAlper17/ufka-yolculuk-quiz/issues) ve şu bilgileri ekleyin:
- Hatanın detaylı açıklaması
- Hatayı yeniden oluşturma adımları
- Beklenen ve gerçekleşen davranış
- Ekran görüntüleri (varsa)
- Cihaz ve platform bilgileri

## Lisans

Bu proje [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](LICENSE) (CC BY-NC-SA 4.0) lisansı altında lisanslanmıştır.

**Lisans Özeti:**
- Kaynak kodu serbestçe kullanılabilir, değiştirilebilir ve paylaşılabilir
- **Ticari amaçla kullanılamaz** (geliştirici iznine tabidir)
- Değiştirilmiş versiyonlar aynı lisansla paylaşılmalıdır
- Atıf yapılmalıdır (geliştirici belirtilmelidir)
- Eğitim, araştırma ve kişisel kullanım serbesttir

**Ticari Kullanım:** Ticari kullanım için geliştirici ile iletişime geçilmesi gerekmektedir.

Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## Geliştirici

**Yusuf Alper İlhan**

GitHub: [@YusufAlper17](https://github.com/YusufAlper17)

## Teşekkürler

- Flutter ekibine framework için
- Açık kaynak kütüphane geliştiricilerine
- İçerik üretimi için kullanılan yapay zeka teknolojilerine
- İlham kaynağı olan eserlere
- 12. Ufka Yolculuk Bilgi ve Kültür Yarışması'na ilham verdiği için

## Gelecek Planları

- Daha fazla kitap eklenmesi
- Çoklu dil desteği
- Liderlik tablosu
- Çok oyunculu mod
- Başarı rozetleri sistemi
- Günlük çalışma takibi

---

<p align="center">Made with Flutter</p>
