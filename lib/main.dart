import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_provider.dart';
import 'modules/quiz/quiz_provider.dart';
import 'core/theme/app_theme.dart';
import 'modules/home/home_page.dart';
import 'modules/quiz/quiz_report_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  // Flutter'ı başlat
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('Flutter initialized');

  // Basit bir uygulama başlat
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: InitializerWidget(),
  ));
}

class InitializerWidget extends StatefulWidget {
  const InitializerWidget({super.key});

  @override
  State<InitializerWidget> createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  late QuizProvider quizProvider;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      debugPrint('Starting initialization...');
      
      // MobileAds yalnızca mobil platformlarda başlatılır
      if (!kIsWeb) {
        try {
          await MobileAds.instance.initialize();
          debugPrint('MobileAds initialized');
        } catch (e) {
          debugPrint('Error initializing MobileAds: $e');
        }
      }

      // QuizProvider'ı başlat
      quizProvider = QuizProvider();
      try {
        await quizProvider.init();
        debugPrint('QuizProvider initialized');
      } catch (e) {
        debugPrint('Error initializing QuizProvider: $e');
        // QuizProvider hatası kritik değil, devam et
      }

      // Başlatma tamamlandı
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Critical error during initialization: $e');
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A0E1A), // Daha koyu dark blue
                Color(0xFF0F172A), // Dark slate
                Color(0xFF1E293B), // Lighter slate
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Desenli arka plan
              Positioned.fill(
                child: CustomPaint(
                  painter: _BackgroundPatternPainter(),
                ),
              ),
              // İçerik
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App icon - yuvarlatılmış
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF14B8A6).withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/icon/app_icon.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: const Color(0xFF14B8A6),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                Icons.help_outline,
                                size: 80,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF14B8A6)),
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Yükleniyor...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Uygulama başlatılırken bir hata oluştu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                      error = null;
                    });
                    _initialize();
                  },
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider.value(value: quizProvider),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          return MaterialApp(
            title: 'UFYO — Ufka Yolculuk',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
            onGenerateRoute: (settings) {
              if (settings.name == '/quiz_report') {
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) => QuizReportPage(
                    questions: args['questions'],
                    userAnswers: args['userAnswers'],
                    score: args['score'],
                    category: args['category'],
                    level: args['level'],
                    examNumber: args['examNumber'],
                    completionTime: args['completionTime'],
                  ),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}

// Arka plan deseni çizen sınıf
class _BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Diagonal çizgiler
    for (double i = -size.height; i < size.width + size.height; i += 60) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    // Noktalar deseni
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += 40) {
      for (double y = 0; y < size.height; y += 40) {
        canvas.drawCircle(
          Offset(x, y),
          2,
          dotPaint,
        );
      }
    }

    // Parıltı efekti (glow spots)
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);

    // Üst sol köşede parıltı
    glowPaint.color = const Color(0xFF14B8A6).withValues(alpha: 0.08);
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.15),
      100,
      glowPaint,
    );

    // Alt sağ köşede parıltı
    glowPaint.color = const Color(0xFF0891B2).withValues(alpha: 0.06);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.85),
      120,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 