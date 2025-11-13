# Katkıda Bulunma Rehberi

> [English version](CONTRIBUTING_EN.md)

🎉 Ufka Yolculuk Quiz projesine katkıda bulunmak istediğiniz için teşekkürler!

## 🤝 Nasıl Katkıda Bulunabilirsiniz?

### 🐛 Hata Bildirimi

Bir hata bulduysanız:

1. Önce [mevcut issues](https://github.com/YusufAlper17/ufka-yolculuk-quiz/issues) listesini kontrol edin
2. Aynı hata daha önce bildirilmediyse, yeni bir issue açın
3. Issue'da şunları belirtin:
   - Hatanın detaylı açıklaması
   - Hatayı tekrar oluşturma adımları
   - Beklenen davranış
   - Gerçekleşen davranış
   - Ekran görüntüleri (varsa)
   - Cihaz bilgileri (Flutter versiyon, işletim sistemi, vb.)

### 💡 Özellik Önerisi

Yeni bir özellik önermek için:

1. [Issues](https://github.com/YusufAlper17/ufka-yolculuk-quiz/issues) sekmesinde yeni bir issue açın
2. Özellik önerinizi detaylı bir şekilde açıklayın
3. Özelliğin neden faydalı olacağını belirtin
4. Varsa mockup veya örnek görseller ekleyin

### 🔧 Kod Katkısı

Kod katkısında bulunmak için:

1. **Projeyi Fork Edin**
   ```bash
   # GitHub'da fork butonuna tıklayın
   ```

2. **Kendi Bilgisayarınıza Klonlayın**
   ```bash
   git clone https://github.com/YOUR-USERNAME/ufka-yolculuk-quiz.git
   cd ufka-yolculuk-quiz
   ```

3. **Yeni Bir Branch Oluşturun**
   ```bash
   git checkout -b feature/yeni-ozellik
   # veya
   git checkout -b fix/hata-duzeltmesi
   ```

4. **Bağımlılıkları Yükleyin**
   ```bash
   flutter pub get
   ```

5. **Değişikliklerinizi Yapın**
   - Kod stiline uyun (aşağıdaki kod standartlarına bakın)
   - Yorum satırlarını Türkçe yazın
   - Anlaşılır ve temiz kod yazın

6. **Test Edin**
   ```bash
   flutter analyze
   flutter test
   ```

7. **Commit Edin**
   ```bash
   git add .
   git commit -m "feat: yeni özellik eklendi"
   ```
   
   Commit mesajları için format:
   - `feat:` - Yeni özellik
   - `fix:` - Hata düzeltmesi
   - `docs:` - Dokümantasyon değişikliği
   - `style:` - Kod formatı düzeltmesi
   - `refactor:` - Kod yeniden yapılandırması
   - `test:` - Test ekleme/düzeltme
   - `chore:` - Bakım işleri

8. **Push Edin**
   ```bash
   git push origin feature/yeni-ozellik
   ```

9. **Pull Request Oluşturun**
   - GitHub'da kendi fork'unuza gidin
   - "New Pull Request" butonuna tıklayın
   - Değişikliklerinizi açıklayın
   - Pull Request'inizi gönderin

## 📝 Kod Standartları

### Dart/Flutter Standartları

- [Effective Dart](https://dart.dev/guides/language/effective-dart) kurallarına uyun
- `flutter analyze` komutunu çalıştırıp uyarıları düzeltin
- 80 karakter satır limiti (mümkün olduğunca)
- Anlamlı değişken ve fonksiyon isimleri kullanın

### Kod Örneği

```dart
// ✅ İYİ
/// Kullanıcının sınav skorunu hesaplar
int calculateScore(List<bool> answers) {
  return answers.where((answer) => answer).length;
}

// ❌ KÖTÜ
// skor hesaplama
int calc(List<bool> a) {
  return a.where((x) => x).length;
}
```

### Yorum Satırları

- Yorum satırlarını Türkçe yazın
- Karmaşık mantığı açıklayın
- Public metodlar için dokümantasyon yorumları (`///`) kullanın

```dart
/// Quiz sorusunu temsil eden model sınıfı
/// 
/// [question] - Soru metni
/// [options] - Cevap seçenekleri listesi
/// [correctAnswer] - Doğru cevabın index'i
class Question {
  final String question;
  final List<String> options;
  final int correctAnswer;
  
  // Constructor
  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}
```

### Dosya Organizasyonu

```
lib/
├── core/           # Temel özellikler (tema, sabitler, vb.)
├── modules/        # Özellik modülleri (home, quiz, vb.)
├── services/       # Servisler (API, veri yönetimi, vb.)
└── main.dart      # Uygulama giriş noktası
```

## 🎨 UI/UX Kuralları

- **Responsive Tasarım**: Farklı ekran boyutlarında test edin
- **Animasyonlar**: Smooth ve anlamlı animasyonlar kullanın
- **Erişilebilirlik**: Tüm kullanıcılar için erişilebilir olmalı
- **Tema Desteği**: Hem dark hem light temada çalışmalı

## 🧪 Test Yazma

Yeni özellikler için test yazın:

```dart
void main() {
  group('Question Model Tests', () {
    test('Question model should be created correctly', () {
      final question = Question(
        question: 'Test sorusu',
        options: ['A', 'B', 'C', 'D'],
        correctAnswer: 0,
      );
      
      expect(question.question, 'Test sorusu');
      expect(question.options.length, 4);
      expect(question.correctAnswer, 0);
    });
  });
}
```

## 📚 Dokümantasyon

- README'yi güncel tutun
- Yeni özellikler için dokümantasyon ekleyin
- Kod örnekleri ekleyin

## 🔍 Review Süreci

Pull Request'iniz:

1. Otomatik testlerden geçmelidir
2. Kod kalitesi kontrol edilecektir
3. Maintainer'lar tarafından review edilecektir
4. Gerekirse değişiklik isteyebiliriz
5. Onaylandıktan sonra merge edilecektir

## 💬 İletişim

- 🐛 Hata bildirimleri için: [Issues](https://github.com/YusufAlper17/ufka-yolculuk-quiz/issues)
- 💡 Özellik önerileri için: [Issues](https://github.com/YusufAlper17/ufka-yolculuk-quiz/issues)
- 📧 Diğer sorular için: GitHub discussions veya issue açabilirsiniz

## 📜 Davranış Kuralları

Bu projede [Davranış Kurallarımıza](CODE_OF_CONDUCT.md) uymanız beklenir.

## 📄 Lisans

Katkıda bulunarak, katkılarınızın [GPL-3.0 License](LICENSE) altında lisanslanmasını kabul etmiş olursunuz.

---

**Teşekkürler!** 🙏

Katkılarınız projeyi daha iyi hale getirir ve topluluk için değer yaratır.

