import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/constants/colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<String> _phrases = [
    'Track daily eco actions',
    'Build streaks & earn points',
    'Compete with friends',
    'Redeem real rewards',
  ];
  
  int _currentPhraseIndex = 0;
  String _displayedText = '';
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    const typingSpeed = Duration(milliseconds: 100);
    const deletingSpeed = Duration(milliseconds: 50);
    const pauseDuration = Duration(milliseconds: 2000);

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        final currentPhrase = _phrases[_currentPhraseIndex];

        if (!_isDeleting) {
          // Typing
          if (_displayedText.length < currentPhrase.length) {
            _displayedText = currentPhrase.substring(0, _displayedText.length + 1);
          } else {
            // Finished typing, pause before deleting
            timer.cancel();
            Future.delayed(pauseDuration, () {
              _isDeleting = true;
              _startTypingAnimation();
            });
          }
        } else {
          // Deleting
          if (_displayedText.isNotEmpty) {
            _displayedText = _displayedText.substring(0, _displayedText.length - 1);
          } else {
            // Finished deleting, move to next phrase
            _isDeleting = false;
            _currentPhraseIndex = (_currentPhraseIndex + 1) % _phrases.length;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Background with curves
          CustomPaint(
            size: Size(double.infinity, screenHeight),
            painter: WelcomeCurvePainter(),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20), // Reduced from 30
                    
                    // 🎯 Top Section: Logo Only (Centered)
                   Padding(
                  padding: const EdgeInsets.only(top: 80), // 👈 increase this
                  child: const Text(
                    'EcoLife',
                      style: TextStyle(
                      fontSize: 50,
                     fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                    
                    // 🦥 Big Sloth Image (peeking from right edge) - MOVED UP
                    Align(
                      alignment: Alignment.centerRight,
                      child: Transform.translate(
                        offset: Offset(screenWidth * 0.15, 0),
                        child: Image.asset(
                          'assets/images/peekingsloth.png',
                          height: screenHeight * 0.42, // Slightly bigger
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30), // Space between sloth and text
                    
                    // 📝 Text Section - MOVED UP
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Static text
                          const Text(
                            'Where Student Choices \nShape the Planet.',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                          
                          const SizedBox(height: 24), // Reduced spacing
                          
                          // Typing animation text with cursor
                          SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _displayedText,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                // Blinking cursor
                                AnimatedOpacity(
                                  opacity: _displayedText.isEmpty || _displayedText.length == _phrases[_currentPhraseIndex].length ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 500),
                                  child: Container(
                                    width: 2.5,
                                    height: 28,
                                    color: Colors.white,
                                    margin: const EdgeInsets.only(left: 2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 80), // More space before button
                          
                          // 🔘 Get Started Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/signup'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // 🔗 Already have account link
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pushNamed(context, '/login'),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 30), // Bottom padding
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the curved green background
class WelcomeCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6ABF7E)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Start from top left
    path.moveTo(0, size.height * 0.12);
    
    // Create the top curve
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.02,
      size.width,
      size.height * 0.12,
    );
    
    // Right side down
    path.lineTo(size.width, size.height);
    
    // Bottom
    path.lineTo(0, size.height);
    
    // Close the path
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Add lighter overlay circle for depth
    final overlayPaint = Paint()
      ..color = const Color(0xFF7DD18F).withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.35),
      size.width * 0.35,
      overlayPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}