import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'career_assessment_screen.dart';
import 'profile_screen.dart';
import 'skill_gap_screen.dart';
import 'learning_roadmap_screen.dart';
import 'resume_builder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Student";
  String careerGoal = "Not selected yet";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String name = "Student";
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      name = user.displayName!;
    }

    String goal = "Not selected yet";
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        goal = data['careerGoal'] ?? "Not selected yet";
        if (data['fullName'] != null &&
            data['fullName'].toString().isNotEmpty) {
          name = data['fullName'];
        }
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
    }

    if (mounted) {
      setState(() {
        userName = name;
        careerGoal = goal;
      });
    }
  }

  // ==========================================
  // ✅ 4 BOXES KE CLICK KA FUNCTION
  // ==========================================
  void _handleFeatureTap(String featureName) {
    if (featureName == 'Career') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CareerAssessmentScreen(),
        ),
      ).then((_) => _loadUserData());
    } else if (featureName == 'Skill Gap') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SkillGapScreen(
            career: careerGoal == "Not selected yet"
                ? "Mobile App Developer"
                : careerGoal,
            userSkills: const ['Flutter', 'Dart', 'HTML/CSS'],
          ),
        ),
      );
    } else if (featureName == 'Learning') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LearningRoadmapScreen(
            career: careerGoal == "Not selected yet"
                ? "Mobile App Developer"
                : careerGoal,
          ),
        ),
      );
    } else if (featureName == 'Resume') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ResumeBuilderScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'SkillSync AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName! 👋',
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "Let's build your future together.",
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 25),

            // Career Goal Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Color(0xFF7E57C2)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.flag_outlined,
                      color: Colors.white, size: 30),
                  const SizedBox(height: 15),
                  const Text('Your Career Goal',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 5),
                  Text(
                    careerGoal,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  OutlinedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CareerAssessmentScreen(),
                        ),
                      );
                      _loadUserData();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                    child: const Text('Set Career Goal'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text('AI Career Assistant 🤖',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // Row 1
            Row(
              children: [
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.explore_outlined,
                    title: 'Career',
                    subtitle: 'Recommendation',
                    onTap: () => _handleFeatureTap('Career'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.analytics_outlined,
                    title: 'Skill Gap',
                    subtitle: 'Analysis',
                    onTap: () => _handleFeatureTap('Skill Gap'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Row 2
            Row(
              children: [
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.route_outlined,
                    title: 'Learning',
                    subtitle: 'Roadmap',
                    onTap: () => _handleFeatureTap('Learning'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.description_outlined,
                    title: 'Resume',
                    subtitle: 'AI Builder',
                    onTap: () => _handleFeatureTap('Resume'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text('Your Progress 📊',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Overall Progress',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('0%',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(value: 0, minHeight: 9),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Start your journey today!',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Reusable Feature Card
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Colors.deepPurple),
            const SizedBox(height: 15),
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 3),
            Text(subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}