import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'quiz_provider.dart';
import 'quiz_page.dart';
import 'models/question_model.dart';
import '../exam/exam_selection_page.dart';
import '../home/home_page.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/background_pattern.dart';

class QuizReportPage extends StatefulWidget {
  final List<QuestionModel> questions;
  final List<int?> userAnswers;
  final int score;
  final String category;
  final int level;
  final int examNumber;
  final String completionTime;

  const QuizReportPage({
    Key? key,
    required this.questions,
    required this.userAnswers,
    required this.score,
    required this.category,
    required this.level,
    required this.examNumber,
    required this.completionTime,
  }) : super(key: key);

  @override
  State<QuizReportPage> createState() => _QuizReportPageState();
}

class _QuizReportPageState extends State<QuizReportPage> with SingleTickerProviderStateMixin {
  final Set<int> _expandedQuestions = {};
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    // Tüm soruları başlangıçta açık yap
    for (int i = 0; i < widget.questions.length; i++) {
      _expandedQuestions.add(i);
    }
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    final percentage = _calculatePercentage();
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: percentage / 100,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));
    
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  int _calculatePercentage() {
    int correctCount = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (widget.userAnswers[i] != null && 
          widget.userAnswers[i] == widget.questions[i].correctOptionIndex) {
        correctCount++;
      }
    }
    return (correctCount / widget.questions.length * 100).round();
  }

  String _getMotivationMessage(int percentage) {
    if (percentage >= 90) return '🎉 Mükemmel! Harika bir performans!';
    if (percentage >= 80) return '🌟 Çok İyi! Başarılı bir sonuç!';
    if (percentage >= 70) return '👍 İyi! Güzel bir çalışma!';
    if (percentage >= 60) return '💪 Fena Değil! Biraz daha çalış!';
    if (percentage >= 50) return '📚 Daha Fazla Çalışmalısın!';
    return '🎯 Pes Etme! Tekrar Dene!';
  }

  Color _getPerformanceColor(int percentage) {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return AppColors.warning;
    return AppColors.error;
  }

  void _toggleQuestion(int index) {
    setState(() {
      if (_expandedQuestions.contains(index)) {
        _expandedQuestions.remove(index);
      } else {
        _expandedQuestions.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    
    int correctCount = 0;
    int incorrectCount = 0;
    int emptyCount = 0;
    
    for (int i = 0; i < widget.questions.length; i++) {
      if (widget.userAnswers[i] == null) {
        emptyCount++;
      } else if (widget.userAnswers[i] == widget.questions[i].correctOptionIndex) {
        correctCount++;
      } else {
        incorrectCount++;
      }
    }
    
    final calculatedScore = (correctCount * 10).round();
    final percentage = (correctCount / widget.questions.length * 100).round();

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ExamSelectionPage(
                category: widget.category,
                level: widget.level,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: BackgroundPattern(
          child: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sınav Raporu',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Deneme ${widget.examNumber} • Seviye ${widget.level}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.close_rounded, color: AppColors.textDark, size: 24),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExamSelectionPage(
                                      category: widget.category,
                                      level: widget.level,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Motivation Message
                SliverToBoxAdapter(
                  child: FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 100),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _getPerformanceColor(percentage).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getPerformanceColor(percentage).withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getPerformanceColor(percentage),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              percentage >= 80 ? Icons.emoji_events_rounded : Icons.emoji_emotions_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              _getMotivationMessage(percentage),
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: _getPerformanceColor(percentage),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Score Overview - Clean Style
                SliverToBoxAdapter(
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 150),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Circular Progress with Score
                          AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Background Circle
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: CircularProgressIndicator(
                                      value: 1.0,
                                      strokeWidth: 10,
                                      backgroundColor: AppColors.surfaceLight,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.surfaceLight,
                                      ),
                                    ),
                                  ),
                                  // Progress Circle
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: TweenAnimationBuilder<double>(
                                      duration: const Duration(milliseconds: 1500),
                                      curve: Curves.easeOutCubic,
                                      tween: Tween<double>(
                                        begin: 0.0,
                                        end: percentage / 100,
                                      ),
                                      builder: (context, value, child) {
                                        return CustomPaint(
                                          painter: CircularProgressPainter(
                                            progress: value,
                                            color: _getPerformanceColor(percentage),
                                            strokeWidth: 10,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Score Container
                                  Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _getPerformanceColor(percentage),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _getPerformanceColor(percentage).withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$calculatedScore',
                                            style: GoogleFonts.poppins(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              height: 1,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '%$percentage',
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white.withOpacity(0.9),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Stats Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatItem(
                                  icon: Icons.check_circle_rounded,
                                  label: 'Doğru',
                                  value: '$correctCount',
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatItem(
                                  icon: Icons.cancel_rounded,
                                  label: 'Yanlış',
                                  value: '$incorrectCount',
                                  color: AppColors.error,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatItem(
                                  icon: Icons.remove_circle_rounded,
                                  label: 'Boş',
                                  value: '$emptyCount',
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Time Info
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 20,
                                  color: AppColors.textLight,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Tamamlanma Süresi: ${widget.completionTime}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.text,
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

                // Questions List Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sorular',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppTheme.accentGlow(0.3),
                          ),
                          child: Text(
                            '${widget.questions.length} Soru',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Questions List
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final question = widget.questions[index];
                        final userAnswer = widget.userAnswers[index];
                        final isExpanded = _expandedQuestions.contains(index);
                        final isCorrect = userAnswer != null && userAnswer == question.correctOptionIndex;
                        final isEmpty = userAnswer == null;

                        return FadeInUp(
                          duration: const Duration(milliseconds: 400),
                          delay: Duration(milliseconds: 50 * index),
                          child: _buildQuestionCard(
                            index: index,
                            question: question,
                            userAnswer: userAnswer,
                            isExpanded: isExpanded,
                            isCorrect: isCorrect,
                            isEmpty: isEmpty,
                          ),
                        );
                      },
                      childCount: widget.questions.length,
                    ),
                  ),
                ),

                // Bottom Buttons
                SliverToBoxAdapter(
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Retry Button
                          Container(
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                              color: const Color(0xFF000000), // Siyah
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                quizProvider.reset();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizPage(
                                      category: widget.category,
                                      level: widget.level,
                                      examNumber: widget.examNumber,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.refresh_rounded, size: 24),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Yeniden Dene',
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 14),
                          
                          // Home Button
                          Container(
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1.5,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: AppColors.text,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.home_rounded, size: 22),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Ana Sayfaya Dön',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard({
    required int index,
    required QuestionModel question,
    required int? userAnswer,
    required bool isExpanded,
    required bool isCorrect,
    required bool isEmpty,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isEmpty
              ? AppColors.border
              : isCorrect
                  ? AppColors.success.withOpacity(0.4)
                  : AppColors.error.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header - Tap to expand
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _toggleQuestion(index),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isEmpty
                            ? AppColors.surfaceLight
                            : isCorrect
                                ? AppColors.success.withOpacity(0.15)
                                : AppColors.error.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isEmpty
                              ? AppColors.border
                              : isCorrect
                                  ? AppColors.success
                                  : AppColors.error,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isEmpty
                                ? AppColors.text
                                : isCorrect
                                    ? AppColors.success
                                    : AppColors.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.question,
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                isEmpty
                                    ? Icons.help_outline_rounded
                                    : (isCorrect 
                                        ? Icons.check_circle_rounded 
                                        : Icons.cancel_rounded),
                                color: isEmpty 
                                    ? AppColors.textMuted 
                                    : isCorrect 
                                        ? AppColors.success 
                                        : AppColors.error,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isEmpty 
                                    ? 'Boş' 
                                    : isCorrect 
                                        ? 'Doğru' 
                                        : 'Yanlış',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isEmpty 
                                      ? AppColors.textMuted 
                                      : isCorrect 
                                          ? AppColors.success 
                                          : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      isExpanded 
                          ? Icons.expand_less_rounded 
                          : Icons.expand_more_rounded,
                      color: AppColors.textLight,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Options - Only shown when expanded
          if (isExpanded) 
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  ...List.generate(
                    question.options.length,
                    (optionIndex) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: _getOptionColor(optionIndex, userAnswer, question.correctOptionIndex),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _getOptionBorderColor(optionIndex, userAnswer, question.correctOptionIndex),
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            // Option letter badge
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _getOptionBorderColor(optionIndex, userAnswer, question.correctOptionIndex)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + optionIndex), // A, B, C, D
                                  style: GoogleFonts.poppins(
                                    color: _getOptionTextColor(optionIndex, userAnswer, question.correctOptionIndex),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                question.options[optionIndex],
                                style: GoogleFonts.poppins(
                                  color: _getOptionTextColor(optionIndex, userAnswer, question.correctOptionIndex),
                                  fontWeight: (optionIndex == userAnswer || optionIndex == question.correctOptionIndex)
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  fontSize: 13.5,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (optionIndex == question.correctOptionIndex)
                              Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.success,
                                size: 22,
                              )
                            else if (optionIndex == userAnswer)
                              Icon(
                                Icons.cancel_rounded,
                                color: AppColors.error,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Explanation
                  if (question.explanation?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.infoLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.info.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.info,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.lightbulb_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Açıklama',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.info,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  question.explanation!,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.text,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getOptionColor(int optionIndex, int? userAnswer, int correctIndex) {
    if (optionIndex == correctIndex) {
      return AppColors.successLight;
    }
    if (userAnswer == optionIndex) {
      return AppColors.errorLight;
    }
    return AppColors.surfaceLight;
  }

  Color _getOptionBorderColor(int optionIndex, int? userAnswer, int correctIndex) {
    if (optionIndex == correctIndex) {
      return AppColors.success.withOpacity(0.4);
    }
    if (userAnswer == optionIndex) {
      return AppColors.error.withOpacity(0.4);
    }
    return AppColors.border;
  }

  Color _getOptionTextColor(int optionIndex, int? userAnswer, int correctIndex) {
    if (optionIndex == correctIndex) {
      return AppColors.success;
    }
    if (userAnswer == optionIndex) {
      return AppColors.error;
    }
    return AppColors.text;
  }
}

// Custom Painter for Circular Progress
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Progress angle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
