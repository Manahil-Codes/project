import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.explore_outlined,
      'title': 'Discover Your Career',
      'description':
          'Explore career paths based on your interests, skills, and goals.',
      'color': Colors.deepPurple,
    },
    {
      'icon': Icons.analytics_outlined,
      'title': 'Identify Your Skill Gap',
      'description':
          'Find out which skills you need to develop for your dream career.',
      'color': Colors.blueAccent,
    },
    {
      'icon': Icons.route_outlined,
      'title': 'Build Your Learning Roadmap',
      'description':
          'Get an AI-powered roadmap designed around your career goals.',
      'color': Colors.green,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // =========================================
  // SHARED PREFERENCES MEIN SAVE KARNA
  // =========================================
  Future<void> _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true); // Save flag

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding(); // Last page par Get Started
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // SKIP BUTTON (Upar Right Corner)
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding, // Direct Login
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  Color pageColor = page['color'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: pageColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: pageColor.withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                          child: Icon(
                            page['icon'],
                            size: 100,
                            color: pageColor,
                          ),
                        ),

                        const SizedBox(height: 55),

                        Text(
                          page['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          page['description'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 25 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.deepPurple
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}