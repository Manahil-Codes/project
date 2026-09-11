import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentEducation;
  final String currentCgpa;
  final List<String> currentSkills;
  final List<String> currentInterests;
  final String currentGoal;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentEducation,
    required this.currentCgpa,
    required this.currentSkills,
    required this.currentInterests,
    required this.currentGoal,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _educationController;
  late TextEditingController _cgpaController;
  late TextEditingController _goalController;
  late TextEditingController _skillsController;
  late TextEditingController _interestsController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _educationController = TextEditingController(text: widget.currentEducation);
    _cgpaController = TextEditingController(text: widget.currentCgpa);
    _goalController = TextEditingController(text: widget.currentGoal);
    _skillsController = TextEditingController(text: widget.currentSkills.join(', '));
    _interestsController = TextEditingController(text: widget.currentInterests.join(', '));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _educationController.dispose();
    _cgpaController.dispose();
    _goalController.dispose();
    _skillsController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Skills aur Interests ko comma se split karke list banana
    List<String> skillsList = _skillsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    List<String> interestsList = _interestsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'fullName': _nameController.text.trim(),
        'education': _educationController.text.trim(),
        'cgpa': _cgpaController.text.trim(),
        'careerGoal': _goalController.text.trim(),
        'skills': skillsList,
        'interests': interestsList,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully! ✅')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(_nameController, 'Full Name', Icons.person),
            const SizedBox(height: 15),
            _buildTextField(_educationController, 'Education', Icons.school),
            const SizedBox(height: 15),
            _buildTextField(_cgpaController, 'CGPA', Icons.grade),
            const SizedBox(height: 15),
            _buildTextField(_goalController, 'Career Goal', Icons.flag),
            const SizedBox(height: 15),
            _buildTextField(
                _skillsController, 'Skills (comma separated)', Icons.psychology),
            const SizedBox(height: 15),
            _buildTextField(_interestsController, 'Interests (comma separated)',
                Icons.favorite),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Changes',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
    );
  }
}