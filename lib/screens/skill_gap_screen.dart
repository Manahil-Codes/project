import 'package:flutter/material.dart';
import 'learning_roadmap_screen.dart';

class SkillGapScreen extends StatefulWidget {
  final String career;
  final List<String> userSkills;
  final List<String> userInterests;

  const SkillGapScreen({
    super.key,
    required this.career,
    this.userSkills = const ['Flutter', 'Dart', 'HTML/CSS'],
    this.userInterests = const [],
  });

  @override
  State<SkillGapScreen> createState() => _SkillGapScreenState();
}

class _SkillGapScreenState extends State<SkillGapScreen> {
  // Har career ke liye required skills ka database
  final Map<String, List<String>> careerRequiredSkills = {
    'Mobile App Developer': [
      'Flutter', 'Dart', 'REST APIs', 'Firebase', 'Git & GitHub', 'State Management'
    ],
    'Software Developer': [
      'Java', 'Python', 'Git & GitHub', 'Data Structures', 'REST APIs', 'OOP'
    ],
    'AI / ML Engineer': [
      'Python', 'Machine Learning', 'Data Science', 'TensorFlow', 'Statistics', 'Data Preprocessing'
    ],
    'Data Scientist': [
      'Python', 'Data Science', 'Statistics', 'SQL', 'Data Visualization', 'Machine Learning'
    ],
    'Cyber Security Specialist': [
      'Python', 'Networking', 'Linux', 'Cryptography', 'Ethical Hacking', 'Security Tools'
    ],
    'Web Developer': [
      'HTML/CSS', 'JavaScript', 'React', 'REST APIs', 'Git & GitHub', 'Responsive Design'
    ],
  };

  List<String> currentSkills = [];
  List<String> missingSkills = [];
  double progress = 0.0;
  String aiInsight = "";

  @override
  void initState() {
    super.initState();
    _calculateGap();
  }

  void _calculateGap() {
    // 1. Us career ki required skills nikalna (List<String> mein cast karna)
    List<String> required = (careerRequiredSkills[widget.career] ??
            ['Flutter', 'Dart', 'REST APIs', 'Firebase', 'Git & GitHub'])
        .cast<String>();

    // 2. User ki skills aur required skills ko compare karna
    currentSkills = [];
    missingSkills = [];

    for (var skill in required) {
      if (widget.userSkills.contains(skill)) {
        currentSkills.add(skill);
      } else {
        missingSkills.add(skill);
      }
    }

    // 3. Progress Percentage Calculate karna
    if (required.isNotEmpty) {
      progress = currentSkills.length / required.length;
    } else {
      progress = 0.0;
    }

    // 4. AI Insight generate karna (YAHAN THEEK KIYA - widget.career use kiya)
    if (missingSkills.isNotEmpty) {
      String topSkills = missingSkills.take(2).join(' and ');
      aiInsight =
          "Focus on $topSkills first. These skills will help you move from basic ${widget.career} development to building complete real-world applications.";
    } else {
      aiInsight =
          "Great! You already have all the core skills required for ${widget.career}. Focus on building projects to strengthen your portfolio.";
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int progressPercent = (progress * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Skill Gap Analysis',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Career Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Color(0xFF7E57C2)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.analytics_outlined,
                      color: Colors.white, size: 34),
                  const SizedBox(height: 14),
                  const Text(
                    'Skill Gap Analysis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.career,
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Current Skill Level
            const Text(
              'Your Current Skill Level',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.trending_up, color: Colors.deepPurple),
                      const SizedBox(width: 10),
                      const Text(
                        'Overall Skill Progress',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        '$progressPercent%',
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 9,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Your Skills
            Text(
              'Your Current Skills ✓ (${currentSkills.length})',
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),

            if (currentSkills.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("No matching skills found. Start learning!"),
              )
            else
              ...currentSkills.map((skill) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _SkillCard(
                      icon: Icons.check_circle,
                      title: skill,
                      subtitle: 'Good foundation',
                      color: Colors.green,
                    ),
                  )),

            const SizedBox(height: 28),

            // Missing Skills
            Text(
              'Skills You Need to Improve 🎯 (${missingSkills.length})',
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),

            if (missingSkills.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("Excellent! You have all the required skills."),
              )
            else
              ...List.generate(missingSkills.length, (index) {
                String priority =
                    index < 2 ? 'High Priority' : 'Medium Priority';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _MissingSkillCard(
                    title: missingSkills[index],
                    level: priority,
                    icon: Icons.star_border,
                  ),
                );
              }),

            const SizedBox(height: 28),

            // AI Insight
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.07),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.deepPurple.withOpacity(0.15)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome,
                      color: Colors.deepPurple, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Recommendation',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          aiInsight,
                          style:
                              const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LearningRoadmapScreen(
                        career: widget.career,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.route),
                label: const Text(
                  'Create My Learning Roadmap',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Current Skill Card
class _SkillCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _SkillCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Missing Skill Card
class _MissingSkillCard extends StatelessWidget {
  final String title;
  final String level;
  final IconData icon;

  const _MissingSkillCard({
    required this.title,
    required this.level,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool highPriority = level == 'High Priority';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.deepPurple),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: highPriority
                  ? Colors.orange.withOpacity(0.12)
                  : Colors.grey.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              level,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: highPriority
                    ? Colors.orange.shade800
                    : Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}