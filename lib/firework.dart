import 'package:flutter/material.dart';
import 'dart:math';

class FireworksAnimation extends StatefulWidget {
  const FireworksAnimation({super.key});

  @override
  _FireworksAnimationState createState() => _FireworksAnimationState();
}

class _FireworksAnimationState extends State<FireworksAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  late Animation<double> _fireworksProgress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _fireworksProgress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _startAnimation();
  }

  void _startAnimation() {
    _controller.forward().then((_) async {
      await Future.delayed(const Duration(seconds: 1)); // انتظار 3 ثوانٍ
      _controller.reset();
      _startAnimation(); // إعادة تشغيل الرسوم المتحركة
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(right: 100),
          child: CustomPaint(
            size: const Size(300, 400),
            painter:
                FireworksPainter(_progress.value, _fireworksProgress.value),
          ),
        );
      },
    );
  }
}

class FireworksPainter extends CustomPainter {
  final double progress;
  final double fireworksProgress;

  FireworksPainter(this.progress, this.fireworksProgress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.white;

    // Draw numbers progressively
    _drawNumbers(canvas, size, paint);

    // Draw fireworks after all numbers are drawn
    if (progress >= 0.95) {
      _drawFireworks(canvas, size,
          Offset(size.width * 0.3, size.height * 0.1)); // Fireworks above
      _drawFireworks(canvas, size,
          Offset(size.width * 0.95, size.height * 0.1)); // Fireworks above
      _drawFireworks(canvas, size,
          Offset(size.width * 0.3, size.height * 1.1)); // Fireworks down
      _drawFireworks(canvas, size,
          Offset(size.width * 0.95, size.height * 1.1)); // Fireworks down
    }
  }

  void _drawNumbers(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    double spacing = size.width * 0.08;

    if (progress > 0.1) {
      path.moveTo(size.width * 0.2, size.height * 0.4); // Start at top-left
      path.quadraticBezierTo(
        size.width * 0.35, size.height * 0.35, // Curve right and up
        size.width * 0.35, size.height * 0.45, // Down to the middle
      );
      path.quadraticBezierTo(
        size.width * 0.35 - 5, size.height * 0.55, // Curve to the right
        size.width * 0.25 + 1, size.height * 0.6, // Curve left and down
      );
      path.lineTo(size.width * 0.5 - spacing,
          size.height * 0.6); // Straight line to the bottom-right
    }
    // Draw number "0" (after 2)
    if (progress > 0.7) {
      path.moveTo(size.width * 0.6 + spacing, size.height * 0.4);
      path.addOval(Rect.fromCircle(
        center: Offset(size.width * 0.55 + spacing, size.height * 0.5),
        radius: 30,
      ));
    }

    // Draw number "3" (after 2 and 0)
    // رسم الرقم "3"
    if (progress > 0.85) {
      path.moveTo(size.width * 0.68 + 2 * spacing,
          size.height * 0.4); // تم تقليل القيمة
      path.quadraticBezierTo(
        size.width * 0.83 + 2 * spacing,
        size.height * 0.4,
        size.width * 0.83 + 2 * spacing,
        size.height * 0.45,
      );
      path.quadraticBezierTo(
        size.width * 0.83 + 2 * spacing,
        size.height * 0.5,
        size.width * 0.73 + 2 * spacing,
        size.height * 0.5,
      );
      path.moveTo(size.width * 0.73 + 2 * spacing, size.height * 0.5);
      path.quadraticBezierTo(
        size.width * 0.83 + 2 * spacing,
        size.height * 0.5,
        size.width * 0.83 + 2 * spacing,
        size.height * 0.55,
      );
      path.quadraticBezierTo(
        size.width * 0.83 + 2 * spacing,
        size.height * 0.6,
        size.width * 0.73 + 2 * spacing,
        size.height * 0.6,
      );
    }

// رسم الرقم "4"

    if (progress > 0.95) {
      path.moveTo(size.width * 0.99 + 3.1 * spacing,
          size.height * 0.35); // Start at the top-left of "4"
      path.lineTo(size.width * 0.99 + 3 * spacing,
          size.height * 0.6); // Vertical line down
//-----------------------------------------------------------
      path.moveTo(size.width * 0.868 + 3 * spacing + 1,
          size.height * 0.45); // بداية الخط الأفقي (تم إنزاله للأسفل)
      path.lineTo(size.width * 0.94 + 3.5 * spacing + 18,
          size.height * 0.45); // نهاية الخط الأفقي (تم إنزاله للأسفل)

//-------------------------------------------------------
      path.moveTo(
          size.width * 0.80 + 2.80 * spacing + 25,
          size.width * 0.589 -
              10 +
              18.42); // Start diagonal line from bottom-left
      path.lineTo(
          size.width * 0.99 + 3.1 * spacing - 0.98,
          size.height *
              0.3522); // Diagonal line to the top-right, forming the triangle
    }
    final metrics = path.computeMetrics().toList();
    final animatedPath = Path();

    for (var i = 0; i < metrics.length; i++) {
      final metric = metrics[i];
      animatedPath.addPath(
        metric.extractPath(0, metric.length * progress),
        Offset.zero,
      );
    }

    canvas.drawPath(animatedPath, paint);
  }

  void _drawFireworks(Canvas canvas, Size size, Offset center) {
    final random = Random();
    for (int i = 0; i < 10; i++) {
      final angle = i * (2 * pi / 10);
      final length = 40 + random.nextDouble() * 30;
      final x = center.dx + cos(angle) * length;
      final y = center.dy + sin(angle) * length;

      final paint = Paint()
        ..color = Color.fromARGB(
            255, random.nextInt(256), random.nextInt(256), random.nextInt(256))
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      if (fireworksProgress > 0.5) {
        canvas.drawLine(center, Offset(x, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
