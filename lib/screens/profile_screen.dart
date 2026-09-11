import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_screen.dart'; // Edit Profile screen ka import

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Default values (jab tak Firebase se data na aaye)
  String fullName = 'Student User';
  String education = 'Not set';
  String cgpa = 'Not set';
  String careerGoal = 'Not selected yet';
  List<String> skills = [];
  List<String> interests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // ==========================================
  // FIREBASE FIRESTORE SE DATA LOAD KARNA
  // ==========================================
  Future<void> _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (!mounted) return;
        setState(() {
          fullName = data['fullName'] ?? fullName;
          education = data['education'] ?? education;
          cgpa = data['cgpa'] ?? cgpa;
          careerGoal = data['careerGoal'] ?? careerGoal;

          if (data['skills'] != null) {
            skills = List<String>.from(data['skills']);
          }
          if (data['interests'] != null) {
            interests = List<String>.from(data['interests']);
          }
          isLoading = false;
        });
      } else {
        // Agar document nahi hai, toh naya bana dein
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'education': education,
          'cgpa': cgpa,
          'careerGoal': careerGoal,
          'skills': skills,
          'interests': interests,
          'email': user.email,
        }, SetOptions(merge: true));
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUserProfile,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
                child: Column(
                  children: [
                    // ============================
                    // PROFILE HEADER
                    // ============================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.deepPurple, Color(0xFF7E57C2)],
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(Icons.person,
                                size: 55, color: Colors.deepPurple),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            education,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ============================
                    // PERSONAL INFORMATION
                    // ============================
                    const _SectionTitle(
                      title: 'Personal Information',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.person,
                      title: 'Full Name',
                      value: fullName,
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.school_outlined,
                      title: 'Education',
                      value: education,
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.grade_outlined,
                      title: 'CGPA',
                      value: cgpa,
                    ),

                    const SizedBox(height: 25),

                    // ============================
                    // SKILLS
                    // ============================
                    const _SectionTitle(
                      title: 'My Skills',
                      icon: Icons.psychology_outlined,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: skills.isEmpty
                          ? const Text("No skills added yet. Edit profile to add.")
                          : Wrap(
                              spacing: 9,
                              runSpacing: 9,
                              children: skills
                                  .map((skill) => _SkillChip(label: skill))
                                  .toList(),
                            ),
                    ),

                    const SizedBox(height: 25),

                    // ============================
                    // INTERESTS
                    // ============================
                    const _SectionTitle(
                      title: 'Interests',
                      icon: Icons.favorite_outline,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: interests.isEmpty
                          ? const Text("No interests added yet. Edit profile to add.")
                          : Wrap(
                              spacing: 9,
                              runSpacing: 9,
                              children: interests
                                  .map((interest) => _SkillChip(label: interest))
                                  .toList(),
                            ),
                    ),

                    const SizedBox(height: 25),

                    // ============================
                    // CAREER GOAL
                    // ============================
                    const _SectionTitle(
                      title: 'Career Goal',
                      icon: Icons.flag_outlined,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.work_outline,
                              color: Colors.deepPurple, size: 30),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Target Career',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13)),
                                const SizedBox(height: 5),
                                Text(
                                  careerGoal,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ============================
                    // EDIT PROFILE BUTTON
                    // ============================
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                currentName: fullName,
                                currentEducation: education,
                                currentCgpa: cgpa,
                                currentSkills: skills,
                                currentInterests: interests,
                                currentGoal: careerGoal,
                              ),
                            ),
                          );
                          // Wapas aane par data refresh karein
                          if (mounted) _loadUserProfile();
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text(
                          'Edit Profile',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
            ),
    );
  }
}

// ==========================================
// SECTION TITLE
// ==========================================
class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 24),
        const SizedBox(width: 9),
        Text(title,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ==========================================
// INFORMATION CARD (ARROWS HATA DIYE)
// ==========================================
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.deepPurple),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          // ARROW YAHAN SE HATA DIYA HAI
        ],
      ),
    );
  }
}

// ==========================================
// SKILL CHIP
// ==========================================
class _SkillChip extends StatelessWidget {
  final String label;

  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.deepPurple, fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}