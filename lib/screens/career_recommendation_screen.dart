import 'package:flutter/material.dart';
import 'skill_gap_screen.dart';

class CareerRecommendationScreen extends StatefulWidget {
  final String education;
  final List<String> interests;
  final List<String> skills;
  final String level;
  final String goal;

  const CareerRecommendationScreen({
    super.key,
    required this.education,
    required this.interests,
    required this.skills,
    required this.level,
    required this.goal,
  });

  @override
  State<CareerRecommendationScreen> createState() =>
      _CareerRecommendationScreenState();
}

class _CareerRecommendationScreenState
    extends State<CareerRecommendationScreen> {
  List<Map<String, dynamic>> recommendations = [];
  String aiInsight = "";

  @override
  void initState() {
    super.initState();
    _generateRecommendations();
  }

  // ==========================================================
  // 🧠 AI LOGIC (Dynamic Match Percentage)
  // ==========================================================
  void _generateRecommendations() {
    List<Map<String, dynamic>> allCareers = [
      {
        'title': 'Mobile App Developer',
        'icon': Icons.phone_android,
        'description':
            'Build Android and iOS applications using modern mobile development technologies.',
        'requiredSkills': ['Flutter', 'Dart', 'UI/UX', 'Java'],
        'relatedInterests': ['Mobile App Development', 'Programming'],
      },
      {
        'title': 'Software Developer',
        'icon': Icons.code,
        'description':
            'Design, develop and maintain software applications for real-world problems.',
        'requiredSkills': ['Java', 'Python', 'HTML/CSS', 'Git'],
        'relatedInterests': ['Programming', 'Web Development'],
      },
      {
        'title': 'AI / ML Engineer',
        'icon': Icons.smart_toy_outlined,
        'description':
            'Work with artificial intelligence and machine learning to create intelligent applications.',
        'requiredSkills': ['Python', 'Data Science', 'Programming'],
        'relatedInterests': ['Artificial Intelligence', 'Data Science'],
      },
      {
        'title': 'Data Scientist',
        'icon': Icons.analytics_outlined,
        'description':
            'Analyze complex data to help companies make better decisions.',
        'requiredSkills': ['Python', 'Data Science'],
        'relatedInterests': ['Data Science', 'Artificial Intelligence'],
      },
      {
        'title': 'Cyber Security Specialist',
        'icon': Icons.security,
        'description':
            'Protect systems and networks from digital attacks and security breaches.',
        'requiredSkills': ['Python', 'Programming', 'Git'],
        'relatedInterests': ['Cyber Security', 'Programming'],
      },
      {
        'title': 'Web Developer',
        'icon': Icons.web,
        'description':
            'Build responsive and dynamic websites and web applications.',
        'requiredSkills': ['HTML/CSS', 'Java', 'UI/UX'],
        'relatedInterests': ['Web Development', 'Programming'],
      },
    ];

    // 2. Har career ke liye Match Percentage Calculate karna
    for (var career in allCareers) {
      double score = 0;

      List<String> requiredSkills =
          List<String>.from(career['requiredSkills']);
      List<String> relatedInterests =
          List<String>.from(career['relatedInterests']);

      // A. Skills Match (Weight: 50%)
      int matchedSkills = 0;
      for (var skill in widget.skills) {
        if (requiredSkills.contains(skill)) matchedSkills++;
      }
      double skillScore = requiredSkills.isEmpty
          ? 0
          : (matchedSkills / requiredSkills.length) * 50;
      score += skillScore;

      // B. Interests Match (Weight: 30%)
      int matchedInterests = 0;
      for (var interest in widget.interests) {
        if (relatedInterests.contains(interest)) matchedInterests++;
      }
      double interestScore = relatedInterests.isEmpty
          ? 0
          : (matchedInterests / relatedInterests.length) * 30;
      score += interestScore;

      // C. Career Goal Match (Weight: 20%)
      double goalScore = 0;
      if (widget.goal == career['title']) {
        goalScore = 20;
      } else if (relatedInterests.contains(widget.goal) ||
          widget.goal.contains(career['title'].split(' ')[0])) {
        goalScore = 10;
      }
      score += goalScore;

      // D. Experience Level Bonus
      if (widget.level == 'Advanced') score += 5;
      else if (widget.level == 'Intermediate') score += 2;

      int finalMatch = score.round();
      if (finalMatch > 99) finalMatch = 99;
      if (finalMatch < 40) finalMatch = 40;

      career['match'] = finalMatch;
    }

    // 3. Match Percentage ke hisaab se Sort karna
    allCareers.sort((a, b) => (b['match'] as int).compareTo(a['match'] as int));

    // 4. Top 3 select karna
    recommendations = allCareers.take(3).toList();

    // 5. Dynamic AI Insight
    if (recommendations.isNotEmpty) {
      String topCareer = recommendations[0]['title'];
      aiInsight =
          "AI Insight: Based on your skills and interests, you have a strong potential for $topCareer. ";
      if (widget.skills.length < 3) {
        aiInsight +=
            "We recommend learning more skills to boost your match percentage. Start with one career path and build consistently.";
      } else {
        aiInsight +=
            "Your current skill set is a great foundation. Focus on the top career path and start building projects.";
      }
    }
  }

  // ==========================================================
  // ✅ YAHAN THEEK KIYA (userSkills aur userInterests pass kiye)
  // ==========================================================
  void _openCareerDetails(BuildContext context, String career) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillGapScreen(
          career: career,
          userSkills: widget.skills,       // <-- Ye zaroori tha
          userInterests: widget.interests, // <-- Ye zaroori tha
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Recommendations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  Icon(Icons.auto_awesome, color: Colors.white, size: 34),
                  SizedBox(height: 14),
                  Text(
                    'Your AI Career Analysis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Based on your interests, skills and experience, we found these career paths for you.',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Top Career Matches 🎯',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            Text(
              'Explore the careers that best match your profile.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 18),

            // DYNAMIC CAREER CARDS
            if (recommendations.isEmpty)
              const Center(child: Text("No recommendations found."))
            else
              ...List.generate(recommendations.length, (index) {
                final career = recommendations[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _CareerCard(
                    rank: '0${index + 1}',
                    icon: career['icon'],
                    title: career['title'],
                    match: '${career['match']}%',
                    description: career['description'],
                    skills: List<String>.from(career['requiredSkills']),
                    isTopMatch: index == 0,
                    onTap: () => _openCareerDetails(context, career['title']),
                  ),
                );
              }),

            const SizedBox(height: 12),

            // AI Insight
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.07),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.deepPurple.withOpacity(0.15)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline,
                      color: Colors.deepPurple, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      aiInsight,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Career Recommendation Card
class _CareerCard extends StatelessWidget {
  final String rank;
  final IconData icon;
  final String title;
  final String match;
  final String description;
  final List<String> skills;
  final bool isTopMatch;
  final VoidCallback onTap;

  const _CareerCard({
    required this.rank,
    required this.icon,
    required this.title,
    required this.match,
    required this.description,
    required this.skills,
    required this.onTap,
    this.isTopMatch = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isTopMatch
                ? Colors.deepPurple.withOpacity(0.35)
                : Colors.grey.shade200,
            width: isTopMatch ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.10),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: Colors.deepPurple, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isTopMatch)
                        const Text(
                          'BEST MATCH',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      const SizedBox(height: 3),
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Text(
                  rank,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Text('AI Match',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(
                  match,
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: double.parse(match.replaceAll('%', '')) / 100,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                  color: Colors.grey.shade700, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: skills.map((skill) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'View Analysis',
                  style: TextStyle(
                      color: Colors.deepPurple, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.arrow_forward,
                    color: Colors.deepPurple, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}