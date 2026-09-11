import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressTrackingScreen extends StatefulWidget {
  const ProgressTrackingScreen({super.key});

  @override
  State<ProgressTrackingScreen> createState() => _ProgressTrackingScreenState();
}

class _ProgressTrackingScreenState extends State<ProgressTrackingScreen> {
  // Dynamic Data
  String careerGoal = 'Not selected yet';
  List<String> userSkills = [];
  List<String> completedTopics = [];
  int totalTopics = 12; // Default, roadmap ke hisaab se change hoga
  bool isLoading = true;

  // Statistics
  int completedCount = 0;
  int inProgressCount = 0;
  double overallProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  // ==============================
  // FIRESTORE SE DATA LOAD KARNA
  // ==============================
  Future<void> _loadProgressData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          careerGoal = data['careerGoal'] ?? 'Not selected yet';
          if (data['skills'] != null) {
            userSkills = List<String>.from(data['skills']);
          }
          if (data['completedTopics'] != null) {
            completedTopics = List<String>.from(data['completedTopics']);
          }
          // Calculate Statistics
          completedCount = completedTopics.length;
          inProgressCount = (userSkills.length - completedCount).clamp(0, 100);
          
          // Overall Progress = (completed topics / total required topics)
          if (totalTopics > 0) {
            overallProgress = (completedCount / totalTopics).clamp(0.0, 1.0);
          }
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error loading progress: $e");
      setState(() => isLoading = false);
    }
  }

  // ==============================
  // SKILL KA PROGRESS CALCULATE KARNA
  // ==============================
  double _getSkillProgress(String skill) {
    // Agar user ke paas skill hai toh 100%, warna 0%
    // (Isko aur behtar banane ke liye aap skill level bhi rakh sakte hain)
    return userSkills.contains(skill) ? 1.0 : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    int overallPercent = (overallProgress * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Progress',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProgressData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.deepPurple, Color(0xFF7E57C2)],
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.trending_up, color: Colors.white, size: 38),
                          SizedBox(height: 14),
                          Text(
                            'Keep Growing! 🚀',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Track your learning journey and achieve your career goals.',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Overall Progress (Dynamic)
                    const Text(
                      'Overall Progress',
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 90,
                            height: 90,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: CircularProgressIndicator(
                                    value: overallProgress,
                                    strokeWidth: 9,
                                    backgroundColor: Colors.grey.shade200,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                Text(
                                  '$overallPercent%',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  overallPercent > 70
                                      ? 'Excellent Progress!'
                                      : overallPercent > 40
                                          ? 'Great Progress!'
                                          : 'Keep Going!',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  'You are making progress toward your $careerGoal goal.',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Statistics (Dynamic)
                    const Text(
                      'Learning Statistics',
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.check_circle,
                            value: '$completedCount',
                            label: 'Completed',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.menu_book,
                            value: '$inProgressCount',
                            label: 'In Progress',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.access_time,
                            value: '${(completedCount * 2)}h',
                            label: 'Study Time',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.local_fire_department,
                            value: '${userSkills.length}',
                            label: 'Skills',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Skill Progress (Dynamic)
                    const Text(
                      'Skill Progress',
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    if (userSkills.isEmpty)
                      const Text('No skills added yet. Complete your assessment.')
                    else
                      ...userSkills.map((skill) {
                        double progress = _getSkillProgress(skill);
                        int percent = (progress * 100).round();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: _SkillProgress(
                            skill: skill,
                            progress: progress,
                            percentage: '$percent%',
                          ),
                        );
                      }),

                    const SizedBox(height: 28),

                    // Current Goal (Dynamic)
                    const Text(
                      'Current Career Goal',
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.work_outline,
                                  color: Colors.deepPurple, size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  careerGoal,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Career Readiness',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 9),
                          LinearProgressIndicator(
                            value: overallProgress,
                            minHeight: 9,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$overallPercent% ready for your target career',
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Motivation
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.emoji_events_outlined,
                              color: Colors.orange, size: 30),
                          SizedBox(width: 13),
                          Expanded(
                            child: Text(
                              'You are on the right track! Keep learning consistently and complete your roadmap to improve your career readiness.',
                              style: TextStyle(fontSize: 14, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// Statistics Card
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

// Skill Progress
class _SkillProgress extends StatelessWidget {
  final String skill;
  final double progress;
  final String percentage;

  const _SkillProgress({
    required this.skill,
    required this.progress,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(skill,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                percentage,
                style: const TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: progress, minHeight: 8),
          ),
        ],
      ),
    );
  }
}