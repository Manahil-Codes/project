import 'package:flutter/material.dart';
import 'career_recommendation_screen.dart';

class CareerAssessmentScreen extends StatefulWidget {
  const CareerAssessmentScreen({super.key});

  @override
  State<CareerAssessmentScreen> createState() =>
      _CareerAssessmentScreenState();
}

class _CareerAssessmentScreenState
    extends State<CareerAssessmentScreen> {
  String? selectedEducation;
  String selectedLevel = 'Beginner';
  String? selectedGoal;

  final List<String> interests = [
    'Programming',
    'Artificial Intelligence',
    'Web Development',
    'Data Science',
    'Mobile App Development',
    'Cyber Security',
  ];

  final List<String> selectedInterests = [];

  final List<String> skills = [
    'Flutter',
    'Dart',
    'Python',
    'HTML/CSS',
    'Java',
    'UI/UX',
  ];

  final List<String> selectedSkills = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Career Assessment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Tell us about yourself 👋',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Answer a few questions to get personalized career recommendations.',
              style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 30),

            // Education
            const Text('What is your education?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedEducation,
              decoration: InputDecoration(
                hintText: 'Select your education',
                prefixIcon: const Icon(Icons.school_outlined),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              items: const [
                DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
                DropdownMenuItem(value: 'Bachelor', child: Text('Bachelor')),
                DropdownMenuItem(value: 'Master', child: Text('Master')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) => setState(() => selectedEducation = value),
            ),
            const SizedBox(height: 30),

            // Interests
            const Text('What are your interests?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Select all that apply',
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: interests.map((interest) {
                final isSelected = selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  selectedColor: Colors.deepPurple.withOpacity(0.15),
                  checkmarkColor: Colors.deepPurple,
                  onSelected: (selected) {
                    setState(() {
                      selected ? selectedInterests.add(interest) : selectedInterests.remove(interest);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            // Skills
            const Text('What skills do you have?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Select your current skills',
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: skills.map((skill) {
                final isSelected = selectedSkills.contains(skill);
                return FilterChip(
                  label: Text(skill),
                  selected: isSelected,
                  selectedColor: Colors.deepPurple.withOpacity(0.15),
                  checkmarkColor: Colors.deepPurple,
                  onSelected: (selected) {
                    setState(() {
                      selected ? selectedSkills.add(skill) : selectedSkills.remove(skill);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            // Experience Level
            const Text('Your experience level',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _LevelButton(
                    title: 'Beginner',
                    isSelected: selectedLevel == 'Beginner',
                    onTap: () => setState(() => selectedLevel = 'Beginner'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LevelButton(
                    title: 'Intermediate',
                    isSelected: selectedLevel == 'Intermediate',
                    onTap: () => setState(() => selectedLevel = 'Intermediate'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LevelButton(
                    title: 'Advanced',
                    isSelected: selectedLevel == 'Advanced',
                    onTap: () => setState(() => selectedLevel = 'Advanced'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Career Goal
            const Text('What is your career goal?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedGoal,
              decoration: InputDecoration(
                hintText: 'Choose your career goal',
                prefixIcon: const Icon(Icons.flag_outlined),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              items: const [
                DropdownMenuItem(value: 'Software Developer', child: Text('Software Developer')),
                DropdownMenuItem(value: 'Mobile App Developer', child: Text('Mobile App Developer')),
                DropdownMenuItem(value: 'Data Scientist', child: Text('Data Scientist')),
                DropdownMenuItem(value: 'AI Engineer', child: Text('AI Engineer')),
                DropdownMenuItem(value: 'Cyber Security Specialist', child: Text('Cyber Security Specialist')),
              ],
              onChanged: (value) => setState(() => selectedGoal = value),
            ),
            const SizedBox(height: 35),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Validation Check
                  if (selectedEducation == null ||
                      selectedInterests.isEmpty ||
                      selectedSkills.isEmpty ||
                      selectedGoal == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please complete all fields before proceeding.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  // YAHAN DATA PASS HO RAHA HAI NEXT SCREEN KO
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CareerRecommendationScreen(
                        education: selectedEducation!,
                        interests: selectedInterests,
                        skills: selectedSkills,
                        level: selectedLevel,
                        goal: selectedGoal!,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  'Get AI Recommendations →',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Experience Level Button
class _LevelButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LevelButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? Colors.deepPurple : Colors.grey.shade300),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}