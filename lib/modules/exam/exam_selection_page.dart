import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../quiz/quiz_page.dart';
import '../quiz/quiz_provider.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/background_pattern.dart';

class ExamSelectionPage extends StatelessWidget {
  final String category;
  final int level;

  const ExamSelectionPage({
    super.key,
    required this.category,
    required this.level,
  });

  String getCategoryTitle() {
    switch (category) {
      case 'elementary':
        return 'İlkokul';
      case 'middle_school':
        return 'Ortaokul';
      case 'high_school':
        return 'Lise';
      case 'adult':
        return 'Yetişkin';
      default:
        return '';
    }
  }

  IconData getCategoryIcon() {
    switch (category) {
      case 'elementary':
        return Icons.school_rounded;
      case 'middle_school':
        return Icons.auto_stories_rounded;
      case 'high_school':
        return Icons.menu_book_rounded;
      case 'adult':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.school;
    }
  }

  Color getCategoryColor() {
    switch (category) {
      case 'elementary':
        return AppColors.elementary;
      case 'middle_school':
        return AppColors.middle;
      case 'high_school':
        return AppColors.high;
      case 'adult':
        return AppColors.adult;
      default:
        return AppColors.info;
    }
  }

  Color getCategoryLightColor() {
    switch (category) {
      case 'elementary':
        return AppColors.elementaryLight;
      case 'middle_school':
        return AppColors.middleLight;
      case 'high_school':
        return AppColors.highLight;
      case 'adult':
        return AppColors.adultLight;
      default:
        return AppColors.infoLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor();
    final categoryLightColor = getCategoryLightColor();

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: BackgroundPattern(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom App Bar - Smooth & Modern
                FadeInDown(
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowLight,
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: AppColors.textDark,
                              size: 20,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: categoryColor.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              getCategoryIcon(),
                              color: categoryColor,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getCategoryTitle(),
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Seviye $level',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textLight,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Title
                FadeInLeft(
                  duration: const Duration(milliseconds: 300),
                  delay: const Duration(milliseconds: 50),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deneme Seçin',
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Her deneme 10 sorudan oluşmaktadır',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Exam Grid
                Expanded(
                  child: AnimationLimiter(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final examNumber = index + 1;
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 300),
                          columnCount: 2,
                          child: FadeInAnimation(
                            child: Consumer<QuizProvider>(
                              builder: (context, quizProvider, _) {
                                final quizId = '${category}_${level}_$examNumber';
                                final status = quizProvider.getQuizStatus(quizId);

                                return _buildExamCard(
                                  context: context,
                                  examNumber: examNumber,
                                  status: status,
                                  categoryColor: categoryColor,
                                  categoryLightColor: categoryLightColor,
                                  quizProvider: quizProvider,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExamCard({
    required BuildContext context,
    required int examNumber,
    required QuizStatus status,
    required Color categoryColor,
    required Color categoryLightColor,
    required QuizProvider quizProvider,
  }) {
    final isCompleted = status == QuizStatus.completed;
    final isInProgress = status == QuizStatus.inProgress;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: isCompleted 
            ? Border.all(color: AppColors.success, width: 2)
            : isInProgress
                ? Border.all(color: AppColors.warning, width: 2)
                : null,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            quizProvider.loadQuestions(category, level, examNumber);
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    QuizPage(
                      category: category,
                      level: level,
                      examNumber: examNumber,
                    ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Exam Number Container
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: categoryLightColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '$examNumber',
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Exam Title
                    Text(
                      '$examNumber. Deneme',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Question Count
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '10 Soru',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Status Badge
              if (isCompleted)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                )
              else if (isInProgress)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
