import 'package:flutter/material.dart';
import 'progress_tracking_screen.dart';

class LearningRoadmapScreen extends StatefulWidget {
  final String career;

  const LearningRoadmapScreen({
    super.key,
    this.career = 'Mobile App Developer',
  });

  @override
  State<LearningRoadmapScreen> createState() => _LearningRoadmapScreenState();
}

class _LearningRoadmapScreenState extends State<LearningRoadmapScreen> {
  // ==========================================================
  // 🗺️ HAR CAREER KA APNA ROADMAP (Dynamic Data)
  // ==========================================================
  final Map<String, List<Map<String, dynamic>>> careerRoadmaps = {
    'Mobile App Developer': [
      {
        'month': 'MONTH 1',
        'title': 'Flutter & Dart Fundamentals',
        'description': 'Build a strong foundation in Flutter and Dart programming.',
        'icon': Icons.code,
        'topics': ['Dart Basics', 'OOP Concepts', 'Flutter Widgets', 'Layouts & UI', 'Navigation'],
      },
      {
        'month': 'MONTH 2',
        'title': 'APIs & Firebase',
        'description': 'Learn how real-world mobile applications communicate with servers and databases.',
        'icon': Icons.cloud_outlined,
        'topics': ['REST APIs', 'JSON', 'Firebase Authentication', 'Cloud Firestore', 'Firebase Storage'],
      },
      {
        'month': 'MONTH 3',
        'title': 'Advanced Flutter & Projects',
        'description': 'Build complete applications and improve your development skills.',
        'icon': Icons.rocket_launch_outlined,
        'topics': ['State Management', 'Local Storage', 'Notifications', 'Animations', 'Real-world Projects'],
      },
    ],
    'Software Developer': [
      {
        'month': 'MONTH 1',
        'title': 'Programming Foundations',
        'description': 'Master core programming concepts using Java or Python.',
        'icon': Icons.code,
        'topics': ['Variables & Loops', 'Functions', 'OOP Concepts', 'Data Structures', 'Problem Solving'],
      },
      {
        'month': 'MONTH 2',
        'title': 'Databases & Backend',
        'description': 'Learn how to store and manage data for real applications.',
        'icon': Icons.storage,
        'topics': ['SQL Basics', 'Database Design', 'REST APIs', 'Authentication', 'Version Control (Git)'],
      },
      {
        'month': 'MONTH 3',
        'title': 'System Design & Projects',
        'description': 'Build complete software projects and learn industry best practices.',
        'icon': Icons.rocket_launch_outlined,
        'topics': ['MVC Architecture', 'Testing', 'Debugging', 'Software Design Patterns', 'Capstone Project'],
      },
    ],
    'AI / ML Engineer': [
      {
        'month': 'MONTH 1',
        'title': 'Python & Math for AI',
        'description': 'Learn Python programming and essential math concepts for AI.',
        'icon': Icons.calculate_outlined,
        'topics': ['Python Basics', 'NumPy & Pandas', 'Linear Algebra', 'Statistics', 'Probability'],
      },
      {
        'month': 'MONTH 2',
        'title': 'Machine Learning Basics',
        'description': 'Understand core machine learning algorithms and how they work.',
        'icon': Icons.smart_toy_outlined,
        'topics': ['Supervised Learning', 'Unsupervised Learning', 'Model Evaluation', 'Scikit-Learn', 'Feature Engineering'],
      },
      {
        'month': 'MONTH 3',
        'title': 'Deep Learning & Projects',
        'description': 'Move into neural networks and build AI-powered applications.',
        'icon': Icons.rocket_launch_outlined,
        'topics': ['Neural Networks', 'TensorFlow/Keras', 'NLP Basics', 'Computer Vision', 'AI Project Deployment'],
      },
    ],
    'Data Scientist': [
      {
        'month': 'MONTH 1',
        'title': 'Data Analysis Foundations',
        'description': 'Learn to work with data using Python and SQL.',
        'icon': Icons.analytics_outlined,
        'topics': ['Python for Data', 'Pandas & NumPy', 'SQL Queries', 'Data Cleaning', 'Exploratory Data Analysis'],
      },
      {
        'month': 'MONTH 2',
        'title': 'Statistics & Visualization',
        'description': 'Understand data patterns through statistics and visualizations.',
        'icon': Icons.bar_chart,
        'topics': ['Descriptive Statistics', 'Inferential Statistics', 'Matplotlib & Seaborn', 'Tableau/Power BI', 'Hypothesis Testing'],
      },
      {
        'month': 'MONTH 3',
        'title': 'Machine Learning for Data',
        'description': 'Apply ML models to make data-driven predictions.',
        'icon': Icons.rocket_launch_outlined,
        'topics': ['Regression Models', 'Classification Models', 'Clustering', 'Model Tuning', 'Real-world Data Project'],
      },
    ],
    'Cyber Security Specialist': [
      {
        'month': 'MONTH 1',
        'title': 'Networking & OS Basics',
        'description': 'Build a strong foundation in networking and operating systems.',
        'icon': Icons.wifi,
        'topics': ['Networking Protocols', 'IP Addressing', 'Linux Commands', 'Windows Security', 'Virtual Machines'],
      },
      {
        'month': 'MONTH 2',
        'title': 'Security Fundamentals',
        'description': 'Learn how to secure systems and understand common threats.',
        'icon': Icons.security,
        'topics': ['Cryptography', 'Authentication', 'Firewalls', 'Vulnerability Scanning', 'Security Policies'],
      },
      {
        'month': 'MONTH 3',
        'title': 'Ethical Hacking & Tools',
        'description': 'Learn penetration testing and use industry-standard security tools.',
        'icon': Icons.rocket_launch_outlined,
        'topics': ['Ethical Hacking Basics', 'Kali Linux', 'Wireshark', 'Metasploit', 'Bug Bounty Practice'],
      },
    ],
    'Web Developer': [
      {
        'month': 'MONTH 1',
        'title': 'Frontend Fundamentals',
        'description': 'Build the visual parts of websites using HTML, CSS, and JavaScript.',
        'icon': Icons.web,
        'topics': ['HTML5', 'CSS3', 'JavaScript Basics', 'Responsive Design', 'DOM Manipulation'],
      },
      {
        'month': 'MONTH 2',
        'title': 'Frontend Frameworks',
        'description': 'Learn modern frontend frameworks to build dynamic web apps.',
        'icon': Icons.code,
        'topics': ['React Basics', 'Components & Props', 'State Management', 'React Router', 'API Integration'],
      },
      {
        'month': 'MONTH 3',
        'title': 'Backend & Full Stack',
        'description': 'Connect your frontend with a backend to build full-stack applications.',
        'icon': Icons.rocket_launch_outlined,
        'topics': ['Node.js Basics', 'Express.js', 'MongoDB', 'Authentication (JWT)', 'Full Stack Project'],
      },
    ],
  };

  List<Map<String, dynamic>> currentRoadmap = [];

  @override
  void initState() {
    super.initState();
    // Career ke hisaab se roadmap set karna
    currentRoadmap = careerRoadmaps[widget.career] ?? careerRoadmaps['Mobile App Developer']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learning Roadmap',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.route, color: Colors.white, size: 36),
                  const SizedBox(height: 14),
                  const Text(
                    'Your Personalized Roadmap',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    widget.career,
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              '3-Month Learning Plan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            Text(
              'Follow these steps to build the skills required for your career.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 22),

            // DYNAMIC ROADMAP CARDS
            ...currentRoadmap.map((monthData) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _RoadmapCard(
                  month: monthData['month'],
                  title: monthData['title'],
                  description: monthData['description'],
                  icon: monthData['icon'],
                  topics: List<String>.from(monthData['topics']),
                ),
              );
            }),

            const SizedBox(height: 12),

            // Progress
            const Text(
              'Roadmap Progress',
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
                      const Icon(Icons.track_changes, color: Colors.deepPurple),
                      const SizedBox(width: 10),
                      const Text(
                        'Overall Progress',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      const Text(
                        '0%',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(value: 0, minHeight: 9),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // AI Message
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.07),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome, color: Colors.deepPurple, size: 27),
                  SizedBox(width: 13),
                  Expanded(
                    child: Text(
                      'Your roadmap is personalized according to your selected career and identified skill gaps. Complete each topic to make progress.',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProgressTrackingScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.bookmark_outline),
                label: const Text(
                  'Save My Roadmap',
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

// Roadmap Card
class _RoadmapCard extends StatelessWidget {
  final String month;
  final String title;
  final String description;
  final IconData icon;
  final List<String> topics;

  const _RoadmapCard({
    required this.month,
    required this.title,
    required this.description,
    required this.icon,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.deepPurple, size: 27),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      month,
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 15),
          ...topics.map(
            (topic) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.deepPurple, size: 19),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      topic,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}