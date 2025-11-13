import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'quiz_provider.dart';
import 'quiz_report_page.dart';
import '../../services/ad_service.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/background_pattern.dart';

class QuizPage extends StatefulWidget {
  final String category;
  final int level;
  final int examNumber;

  const QuizPage({
    super.key,
    required this.category,
    required this.level,
    required this.examNumber,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  late AnimationController _explanationController;
  late Animation<double> _explanationAnimation;
  late Animation<double> _explanationSlideAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _explanationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _explanationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _explanationController,
      curve: Curves.easeOutBack,
    ));
    _explanationSlideAnimation = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _explanationController,
      curve: Curves.easeOutBack,
    ));
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final quizProvider = context.read<QuizProvider>();
      quizProvider.resumeTimer();
      
      await quizProvider.loadQuestions(
        widget.category,
        widget.level,
        widget.examNumber,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (quizProvider.isCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuizReportPage(
                questions: quizProvider.questions,
                userAnswers: quizProvider.userAnswers,
                score: quizProvider.calculateScore(),
                category: widget.category,
                level: widget.level,
                examNumber: widget.examNumber,
                completionTime: quizProvider.getCompletionTime(),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
    
    if (mounted) {
      AdService.loadInterstitialAd();
    }
  }

  @override
  void dispose() {
    _explanationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(String soundPath) async {
    try {
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void _showExplanation() {
    _explanationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        if (_isLoading) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sorular yükleniyor...',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (_error != null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 64, color: AppColors.error),
                    const SizedBox(height: 24),
                    Text(
                      'Bir hata oluştu',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _loadQuestions,
                          child: const Text('Tekrar Dene'),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () async {
                            await context.read<QuizProvider>().clearAllProgress();
                            if (mounted) {
                              _loadQuestions();
                            }
                          },
                          child: const Text('Sıfırla'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (quizProvider.questions.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text(
                'Henüz soru bulunmuyor.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
              ),
            ),
          );
        }

        final currentQuestion = quizProvider.currentQuestion;
        if (currentQuestion == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text(
                'Soru yüklenirken bir hata oluştu.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
              ),
            ),
          );
        }

        if (quizProvider.isCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AdService.showInterstitialAd();
            Future.delayed(const Duration(milliseconds: 500), () async {
              if (mounted) {
                final quizId = '${widget.category}_${widget.level}_${widget.examNumber}';
                await quizProvider.saveQuizProgress(quizId);
                
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizReportPage(
                      questions: quizProvider.questions,
                      userAnswers: quizProvider.userAnswers,
                      score: quizProvider.calculateScore(),
                      category: widget.category,
                      level: widget.level,
                      examNumber: widget.examNumber,
                      completionTime: quizProvider.getCompletionTime(),
                    ),
                  ),
                );
              }
            });
          });
        }

        return Scaffold(
          body: QuizBackgroundPattern(
            child: PopScope(
            canPop: true,
            onPopInvoked: (bool didPop) async {
              if (didPop) {
                final quizId = '${widget.category}_${widget.level}_${widget.examNumber}';
                if (quizProvider.getQuizStatus(quizId) != QuizStatus.completed) {
                  quizProvider.setQuizStatus(quizId, QuizStatus.inProgress);
                  quizProvider.pauseTimer();
                  await quizProvider.saveInProgressQuiz(quizId);
                }
              }
            },
            child: SafeArea(
              child: Column(
                children: [
                  // Header with progress - Banking Style
                  FadeInDown(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.close_rounded, color: AppColors.textDark, size: 22),
                                  onPressed: () async {
                                    final quizId = '${widget.category}_${widget.level}_${widget.examNumber}';
                                    if (quizProvider.getQuizStatus(quizId) != QuizStatus.completed) {
                                      quizProvider.setQuizStatus(quizId, QuizStatus.inProgress);
                                      quizProvider.pauseTimer();
                                      await quizProvider.saveUserAnswers(quizId);
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Text(
                                'Soru ${quizProvider.progress}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accent.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${quizProvider.currentQuestionIndex + 1}/${quizProvider.questions.length}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Progress Bar with Clear Border
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOut,
                                tween: Tween<double>(
                                  begin: (quizProvider.currentQuestionIndex) / quizProvider.questions.length,
                                  end: (quizProvider.currentQuestionIndex + 1) / quizProvider.questions.length,
                                ),
                                builder: (context, value, _) => LinearProgressIndicator(
                                  value: value,
                                  backgroundColor: Colors.transparent,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                                  minHeight: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Question and Options
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Question Card - Clean Banking Style
                          FadeInUp(
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: AppTheme.cardShadow,
                              ),
                              child: Text(
                                currentQuestion.question,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                  height: 1.6,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Options
                          ...List.generate(
                            currentQuestion.options.length,
                            (index) => FadeInUp(
                              duration: const Duration(milliseconds: 300),
                              delay: Duration(milliseconds: 50 * (index + 1)),
                              child: _OptionButton(
                                text: currentQuestion.options[index],
                                isSelected: quizProvider.userAnswers[quizProvider.currentQuestionIndex] == index,
                                isPreSelected: quizProvider.selectedAnswer == index,
                                isCorrect: index == currentQuestion.correctOptionIndex,
                                showCorrectAnswer: quizProvider.userAnswers[quizProvider.currentQuestionIndex] != null,
                                onTap: () {
                                  quizProvider.selectAnswer(index);
                                  if (quizProvider.userAnswers[quizProvider.currentQuestionIndex] != null) {
                                    _showExplanation();
                                    
                                    final isCorrect = index == currentQuestion.correctOptionIndex;
                                    
                                    if (isCorrect) {
                                      _playSound('sounds/mixkit-correct-answer-tone-2870.wav');
                                    } else {
                                      _playSound('sounds/error-8-206492.mp3');
                                    }

                                    Future.delayed(
                                      Duration(milliseconds: isCorrect ? 1500 : 3000),
                                      () {
                                        if (quizProvider.currentQuestionIndex < quizProvider.questions.length - 1) {
                                          quizProvider.nextQuestion();
                                        }
                                      },
                                    );
                                  } else {
                                    _playSound('sounds/mixkit-cool-interface-click-tone-2568.wav');
                                  }
                                },
                              ),
                            ),
                          ),
                          
                          // Explanation (if answered)
                          if (quizProvider.userAnswers[quizProvider.currentQuestionIndex] != null && 
                              currentQuestion.explanation != null)
                            AnimatedBuilder(
                              animation: _explanationController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _explanationSlideAnimation.value),
                                  child: Opacity(
                                    opacity: _explanationAnimation.value.clamp(0.0, 1.0),
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: AppColors.info,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.info.withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.lightbulb_rounded,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                'Açıklama',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 14),
                                          Text(
                                            currentQuestion.explanation!,
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              color: Colors.white,
                                              height: 1.6,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Navigation Footer
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Previous Button
                        Container(
                          decoration: BoxDecoration(
                            color: quizProvider.currentQuestionIndex > 0 
                                ? AppColors.surfaceLight 
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: quizProvider.currentQuestionIndex > 0 
                                  ? AppColors.textDark 
                                  : AppColors.textMuted,
                              size: 22,
                            ),
                            onPressed: quizProvider.currentQuestionIndex > 0
                                ? () => quizProvider.previousQuestion()
                                : null,
                          ),
                        ),
                        
                        // Finish Button (last question) or Spacer
                        Expanded(
                          child: quizProvider.currentQuestionIndex == quizProvider.questions.length - 1
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      quizProvider.completeQuiz();
                                      
                                      final adShown = await AdService.showInterstitialAd();
                                      
                                      if (adShown) {
                                        await Future.delayed(const Duration(seconds: 2));
                                      }
                                      
                                      if (mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => QuizReportPage(
                                              questions: quizProvider.questions,
                                              userAnswers: quizProvider.userAnswers,
                                              score: quizProvider.calculateScore(),
                                              category: widget.category,
                                              level: widget.level,
                                              examNumber: widget.examNumber,
                                              completionTime: quizProvider.getCompletionTime(),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.buttonPrimary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.check_circle_rounded, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Testi Bitir',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        
                        // Next Button
                        Container(
                          decoration: BoxDecoration(
                            color: quizProvider.currentQuestionIndex < quizProvider.questions.length - 1 
                                ? AppColors.accent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: quizProvider.currentQuestionIndex < quizProvider.questions.length - 1
                                ? AppTheme.accentGlow(0.3)
                                : [],
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_rounded,
                              color: quizProvider.currentQuestionIndex < quizProvider.questions.length - 1 
                                  ? AppColors.textDark 
                                  : AppColors.textMuted,
                              size: 22,
                            ),
                            onPressed: quizProvider.currentQuestionIndex < quizProvider.questions.length - 1
                                ? () => quizProvider.nextQuestion()
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
        );
      },
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isPreSelected;
  final bool isCorrect;
  final bool showCorrectAnswer;
  final VoidCallback onTap;

  const _OptionButton({
    required this.text,
    required this.isSelected,
    required this.isPreSelected,
    required this.isCorrect,
    required this.showCorrectAnswer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    List<BoxShadow> shadows;

    if (showCorrectAnswer) {
      if (isSelected && !isCorrect) {
        backgroundColor = AppColors.errorLight;
        borderColor = AppColors.error;
        textColor = AppColors.error;
        shadows = [];
      } else if (isCorrect) {
        backgroundColor = AppColors.successLight;
        borderColor = AppColors.success;
        textColor = AppColors.success;
        shadows = [];
      } else {
        backgroundColor = AppColors.surface;
        borderColor = AppColors.border;
        textColor = AppColors.text;
        shadows = [];
      }
    } else if (isPreSelected) {
      backgroundColor = AppColors.accent;
      borderColor = AppColors.accent;
      textColor = AppColors.textDark;
      shadows = AppTheme.accentGlow(0.3);
    } else {
      backgroundColor = AppColors.surface;
      borderColor = AppColors.border;
      textColor = AppColors.text;
      shadows = [];
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: shadows,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: showCorrectAnswer ? null : onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: (isSelected || isPreSelected) ? FontWeight.w700 : FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ),
                  if (showCorrectAnswer && (isSelected || isCorrect))
                    Icon(
                      isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: isCorrect ? AppColors.success : AppColors.error,
                      size: 22,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 