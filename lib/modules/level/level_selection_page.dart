import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../exam/exam_selection_page.dart';
import '../quiz/quiz_provider.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/background_pattern.dart';

class LevelSelectionPage extends StatelessWidget {
  final String category;
  
  const LevelSelectionPage({
    super.key,
    required this.category,
  });

  void _showLockAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: FadeInUp(
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.surfaceElevated,
                boxShadow: AppTheme.elevatedShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warningDark,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: AppTheme.coloredGlow(AppColors.warning, 0.3),
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      size: 48,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Seviye Kilitli',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Bu seviyeyi açmak için önceki seviyeyi tamamlamalısınız.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Anladım',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
        return 'Seviyeleri';
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
    
    return Scaffold(
      body: BackgroundPattern(
        child: SafeArea(
          child: Column(
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
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Seviye Seçimi',
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
              
              // Level Grid
              Expanded(
                child: AnimationLimiter(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final level = index + 1;
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 300),
                        columnCount: 2,
                        child: FadeInAnimation(
                          child: Consumer<QuizProvider>(
                            builder: (context, quizProvider, _) {
                              final isLocked = !quizProvider.isLevelUnlocked(category, level);
                              final isCompleted = quizProvider.isLevelCompleted(category, level);
                              
                              return _buildLevelCard(
                                context: context,
                                level: level,
                                isLocked: isLocked,
                                isCompleted: isCompleted,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required int level,
    required bool isLocked,
    required bool isCompleted,
    required Color categoryColor,
    required Color categoryLightColor,
    required QuizProvider quizProvider,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isLocked ? AppColors.surfaceLight : AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: isCompleted 
            ? Border.all(color: AppColors.success, width: 2)
            : null,
        boxShadow: isLocked ? [] : AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLocked 
              ? () => _showLockAlert(context)
              : () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ExamSelectionPage(
                            category: category,
                            level: level,
                          ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end).chain(
                          CurveTween(curve: curve),
                        );
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  ).then((_) {
                    if (quizProvider.isLevelCompleted(category, level)) {
                      quizProvider.unlockNextLevel(category, level);
                    }
                  });
                },
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Level Icon/Number
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isLocked 
                            ? AppColors.borderLight
                            : categoryLightColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: isLocked
                            ? Icon(
                                Icons.lock_rounded,
                                size: 28,
                                color: AppColors.textMuted,
                              )
                            : Text(
                                level.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: categoryColor,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Level Text
                    Text(
                      'Seviye $level',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isLocked ? AppColors.textMuted : AppColors.textDark,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Status Text
                    if (isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Tamamlandı',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.successDark,
                          ),
                        ),
                      )
                    else if (!isLocked)
                      Text(
                        '10 Deneme',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                  ],
                ),
              ),
              
              // Completed Badge
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
