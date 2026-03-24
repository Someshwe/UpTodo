import 'package:flutter/material.dart';
import 'dart:ui';

class GlassEffect extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color color;
  final BorderRadius borderRadius;
  final Border? border;
  final EdgeInsets padding;
  final double opacity;

  const GlassEffect({
    Key? key,
    required this.child,
    this.blur = 10.0,
    this.color = const Color(0xFF1A1F2E),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.border,
    this.padding = const EdgeInsets.all(16),
    this.opacity = 0.6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: borderRadius,
            border:
                border ??
                Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double blur;

  const GlassCard({
    Key? key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blur = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassEffect(
        blur: blur,
        borderRadius: borderRadius,
        padding: padding,
        child: child,
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;
  final Color startColor;
  final Color endColor;

  const GradientBackground({
    Key? key,
    required this.child,
    this.startColor = const Color(0xFF0F1419),
    this.endColor = const Color(0xFF1A2332),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [startColor, endColor],
        ),
      ),
      child: child,
    );
  }
}

class AnimatedGlassButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const AnimatedGlassButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  }) : super(key: key);

  @override
  State<AnimatedGlassButton> createState() => _AnimatedGlassButtonState();
}

class _AnimatedGlassButtonState extends State<AnimatedGlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GlassEffect(
          color: widget.backgroundColor ?? const Color(0xFF667EEA),
          padding: widget.padding,
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}
