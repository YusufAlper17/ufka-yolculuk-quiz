# Güvenlik Politikası / Security Policy

## 🔒 Desteklenen Versiyonlar / Supported Versions

Aşağıdaki tabloda hangi versiyonların güvenlik güncellemeleri aldığı gösterilmektedir:

The following table shows which versions are currently receiving security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## 🐛 Güvenlik Açığı Bildirimi / Reporting a Vulnerability

Ufka Yolculuk Quiz'de bir güvenlik açığı bulduysanız, lütfen aşağıdaki adımları izleyin:

If you discover a security vulnerability in Ufka Yolculuk Quiz, please follow these steps:

### 🚨 Güvenlik Açıklarını ASLA Herkese Açık Olarak Bildirmeyin / NEVER Report Security Vulnerabilities Publicly

**Lütfen güvenlik açıklarını public issues olarak açmayın!**

**Please do NOT open public issues for security vulnerabilities!**

### 📧 Özel Bildirim / Private Reporting

1. **GitHub Security Advisory** kullanın (tercih edilen yöntem):
   - Repository'nin "Security" sekmesine gidin
   - "Report a vulnerability" butonuna tıklayın
   - Formu doldurun

2. **Alternatif olarak**, bir private issue oluşturmak için bize ulaşın:
   - GitHub Discussions üzerinden özel mesaj gönderin
   - Veya proje sahibine direkt ulaşın

### 📝 Bildirmeniz Gereken Bilgiler / Information to Include

Güvenlik açığını bildirirken lütfen şunları ekleyin:

When reporting a vulnerability, please include:

- 🔍 **Açıklama**: Güvenlik açığının detaylı açıklaması
- 🎯 **Etki**: Güvenlik açığının potansiyel etkisi
- 🔧 **Yeniden Üretme Adımları**: Açığı nasıl yeniden üreteceğinize dair adımlar
- 🛠️ **Önerilen Çözüm**: Varsa, önerilen düzeltme yöntemi
- 📱 **Etkilenen Versiyonlar**: Hangi versiyonların etkilendiği
- 💻 **Sistem Bilgileri**: İşletim sistemi, Flutter versiyonu, vb.

Example:
```
**Vulnerability Type**: [örn: SQL Injection, XSS, Authentication Bypass]

**Description**: 
[Güvenlik açığının detaylı açıklaması]

**Steps to Reproduce**:
1. [Adım 1]
2. [Adım 2]
3. [Adım 3]

**Impact**:
[Güvenlik açığının potansiyel etkisi]

**Affected Versions**:
- Version 1.0.0
- Version 1.0.1

**System Information**:
- OS: Android 12
- Flutter: 3.2.3
- Device: Samsung Galaxy S21
```

## ⏱️ Yanıt Süreci / Response Process

Güvenlik açığı bildirildikten sonra:

After a security vulnerability is reported:

1. **Onay** (24 saat içinde): Bildirimi aldığımızı size bildireceğiz
   - **Acknowledgment** (within 24 hours): We will confirm receipt of your report

2. **Değerlendirme** (1-5 gün): Güvenlik açığını değerlendireceğiz
   - **Assessment** (1-5 days): We will assess the vulnerability

3. **Düzeltme** (Aciliyete göre): Düzeltme üzerinde çalışacağız
   - **Fix** (Based on severity): We will work on a fix

4. **Yayın** (Düzeltme hazır olduğunda): Yeni versiyon yayınlanacak
   - **Release** (When fix is ready): A new version will be released

5. **Açıklama** (Düzeltme yayınlandıktan sonra): Güvenlik danışması yayınlanacak
   - **Disclosure** (After fix is released): Security advisory will be published

## 🎖️ Teşekkür / Acknowledgments

Güvenlik açıklarını sorumlu bir şekilde bildiren araştırmacılara teşekkür ederiz. İsterseniz, sizi SECURITY.md dosyasında onur listesinde zikredebiliriz.

We thank security researchers who responsibly disclose vulnerabilities. If you wish, we can acknowledge you in this SECURITY.md file.

### Hall of Fame

_Henüz hiçbir güvenlik açığı bildirilmedi. İlk siz olun!_

_No security vulnerabilities reported yet. Be the first!_

## 🔐 Güvenlik En İyi Uygulamaları / Security Best Practices

### Geliştiriciler İçin / For Developers

Projeye katkıda bulunurken:

When contributing to the project:

- 🔑 **API Anahtarları**: API anahtarlarını ve hassas bilgileri kod içine yazmayın
  - **API Keys**: Never hardcode API keys or sensitive information

- 📝 **Bağımlılıklar**: Bağımlılıkları güncel tutun
  - **Dependencies**: Keep dependencies up to date

- 🧪 **Test**: Güvenlik testleri yazın
  - **Testing**: Write security tests

- 🔒 **Şifreleme**: Hassas verileri şifreleyin
  - **Encryption**: Encrypt sensitive data

### Kullanıcılar İçin / For Users

Uygulamayı kullanırken:

When using the application:

- 📲 **Güncel Kalın**: Her zaman en son versiyonu kullanın
  - **Stay Updated**: Always use the latest version

- 🔍 **İndir Kaynak**: Uygulamayı sadece resmi kaynaklardan indirin
  - **Download Source**: Only download from official sources

- 🛡️ **İzinler**: Uygulama izinlerini gözden geçirin
  - **Permissions**: Review app permissions

## 📚 Güvenlik Kaynakları / Security Resources

- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)
- [Dart Security](https://dart.dev/guides/libraries/secure-storage)

## 📞 İletişim / Contact

Güvenlik ile ilgili sorularınız için:

For security-related questions:

- 🔒 **Güvenlik Açıkları**: GitHub Security Advisory kullanın
  - **Security Vulnerabilities**: Use GitHub Security Advisory

- 💬 **Genel Sorular**: GitHub Discussions kullanın
  - **General Questions**: Use GitHub Discussions

---

**Not**: Bu güvenlik politikası değişebilir. En son versiyonu için GitHub'ı kontrol edin.

**Note**: This security policy may change. Check GitHub for the latest version.

**Son Güncellenme / Last Updated**: Kasım 2025

