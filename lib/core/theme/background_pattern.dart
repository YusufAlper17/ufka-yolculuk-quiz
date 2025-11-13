import 'package:flutter/material.dart';
import 'app_colors.dart';

class BackgroundPattern extends StatelessWidget {
  final Widget child;
  
  const BackgroundPattern({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background - Daha koyu
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                const Color(0xFFDEE2E8),
                AppColors.background,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        
        // Geometric pattern overlay
        CustomPaint(
          painter: _GeometricPatternPainter(),
          child: Container(),
        ),
        
        // Content
        child,
      ],
    );
  }
}

class _GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = AppColors.border.withOpacity(0.3);

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.accent.withOpacity(0.05);

    // Draw circles in corners
    _drawDecorativeCircle(canvas, const Offset(-50, 100), 120, paint, fillPaint);
    _drawDecorativeCircle(canvas, Offset(size.width + 50, size.height - 100), 150, paint, fillPaint);
    _drawDecorativeCircle(canvas, Offset(size.width - 100, 150), 100, paint, fillPaint);
    _drawDecorativeCircle(canvas, const Offset(80, -30), 90, paint, fillPaint);
    
    // Draw subtle grid pattern
    _drawGridPattern(canvas, size, paint);
    
    // Draw floating geometric shapes
    _drawFloatingShapes(canvas, size);
    
    // Draw additional decorative elements
    _drawAdditionalDecorations(canvas, size);
  }

  void _drawDecorativeCircle(Canvas canvas, Offset center, double radius, Paint strokePaint, Paint fillPaint) {
    canvas.drawCircle(center, radius, fillPaint);
    canvas.drawCircle(center, radius, strokePaint);
    canvas.drawCircle(center, radius * 0.7, strokePaint);
    canvas.drawCircle(center, radius * 0.4, strokePaint);
  }

  void _drawGridPattern(Canvas canvas, Size size, Paint paint) {
    const spacing = 50.0;
    
    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint..color = AppColors.border.withOpacity(0.08),
      );
    }
    
    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint..color = AppColors.border.withOpacity(0.08),
      );
    }
  }

  void _drawFloatingShapes(Canvas canvas, Size size) {
    final accentPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = AppColors.accent.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Top right triangle
    final trianglePath = Path()
      ..moveTo(size.width - 80, 80)
      ..lineTo(size.width - 30, 120)
      ..lineTo(size.width - 120, 140)
      ..close();
    canvas.drawPath(trianglePath, accentPaint);
    canvas.drawPath(trianglePath, strokePaint);

    // Middle left square
    final squareRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(40, size.height * 0.4, 60, 60),
      const Radius.circular(12),
    );
    canvas.drawRRect(squareRect, accentPaint);
    canvas.drawRRect(squareRect, strokePaint);

    // Bottom center circle
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height - 100),
      40,
      accentPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height - 100),
      40,
      strokePaint,
    );
  }

  void _drawAdditionalDecorations(Canvas canvas, Size size) {
    final accentPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = AppColors.accent.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Top right hexagon
    final hexPath = Path();
    final hexCenter = Offset(size.width - 120, 200);
    final hexRadius = 35.0;
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * 3.14159 / 180;
      final x = hexCenter.dx + hexRadius * (angle == 0 ? 1 : (angle == 3.14159 ? -1 : (angle < 3.14159 ? 0.5 : -0.5)));
      final y = hexCenter.dy + hexRadius * (angle < 1.57 ? -0.866 : (angle < 4.71 ? 0.866 : 0));
      if (i == 0) {
        hexPath.moveTo(x, y);
      } else {
        hexPath.lineTo(x, y);
      }
    }
    hexPath.close();
    canvas.drawPath(hexPath, accentPaint);
    canvas.drawPath(hexPath, strokePaint);

    // Middle wave pattern
    final wavePath = Path();
    wavePath.moveTo(0, size.height * 0.6);
    for (double x = 0; x < size.width; x += 20) {
      wavePath.lineTo(x, size.height * 0.6 + (x % 40 == 0 ? 10 : -10));
    }
    canvas.drawPath(wavePath, strokePaint..strokeWidth = 1.5);

    // Diagonal lines accent
    final diagonalPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (double i = -size.height; i < size.width; i += 80) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        diagonalPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Animated gradient background for quiz page
class QuizBackgroundPattern extends StatelessWidget {
  final Widget child;
  
  const QuizBackgroundPattern({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient base
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF5F7FA),
                const Color(0xFFFFFFFF),
                const Color(0xFFF8FAFB),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        
        // Subtle pattern overlay
        CustomPaint(
          painter: _QuizPatternPainter(),
          child: Container(),
        ),
        
        // Content
        child,
      ],
    );
  }
}

class _QuizPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.accent.withOpacity(0.06);

    // Draw subtle dots pattern
    const dotSpacing = 35.0;
    const dotRadius = 2.5;
    
    for (double x = dotSpacing; x < size.width; x += dotSpacing) {
      for (double y = dotSpacing; y < size.height; y += dotSpacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }

    // Draw accent shapes in corners
    final accentPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = AppColors.accent.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Top left corner shape
    final topLeftPath = Path()
      ..moveTo(0, 0)
      ..lineTo(200, 0)
      ..quadraticBezierTo(150, 100, 0, 200)
      ..close();
    canvas.drawPath(topLeftPath, accentPaint);
    canvas.drawPath(topLeftPath, strokePaint);

    // Bottom right corner shape
    final bottomRightPath = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width - 200, size.height)
      ..quadraticBezierTo(size.width - 150, size.height - 100, size.width, size.height - 200)
      ..close();
    canvas.drawPath(bottomRightPath, accentPaint);
    canvas.drawPath(bottomRightPath, strokePaint);

    // Add diagonal stripes
    final stripePaint = Paint()
      ..color = AppColors.accent.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (double i = -size.height; i < size.width; i += 100) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        stripePaint,
      );
    }

    // Add small circles scattered
    final circlePaint = Paint()
      ..color = AppColors.accent.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 25, circlePaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.7), 30, circlePaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.15), 20, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

