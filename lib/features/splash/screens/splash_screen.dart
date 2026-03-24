import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/onboarding/providers/onboarding_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _navigateAfterSplash();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  void _navigateAfterSplash() {
    // Reduced delay to 1 second for faster startup
    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (!mounted) return;

      // Check if onboarding is completed
      final onboardingProvider = context.read<OnboardingProvider>();

      if (onboardingProvider.isOnboardingCompleted) {
        // Skip onboarding and go directly to home
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // First time user - show onboarding
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF0F0F1E),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Purple checkmark icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBE5FF),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Color(0xFF6C4AB6),
                            size: 80,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // UpTodo text
                        const Text(
                          'UpTodo',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom line
            Container(
              height: 3,
              color: const Color(0xFF6C4AB6),
              margin: const EdgeInsets.only(bottom: 40),
            ),
          ],
        ),
      ),
    );
  }
}
