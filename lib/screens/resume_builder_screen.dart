import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResumeBuilderScreen extends StatefulWidget {
  const ResumeBuilderScreen({super.key});

  @override
  State<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _educationController = TextEditingController();
  final _skillsController = TextEditingController();
  final _experienceController = TextEditingController();
  final _projectsController = TextEditingController();

  bool _isGenerating = false;
  bool _isSaving = false;
  Map<String, dynamic>? generatedResume;

  @override
  void initState() {
    super.initState();
    _prefillData();
  }

  // Firestore se user ka data auto-fill karna
  Future<void> _prefillData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _nameController.text = data['fullName'] ?? '';
        _emailController.text = data['email'] ?? user.email ?? '';
        _educationController.text = data['education'] ?? '';
        
        if (data['skills'] != null) {
          List<String> skills = List<String>.from(data['skills']);
          _skillsController.text = skills.join(', ');
        }
        
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint("Prefill error: $e");
    }
  }

  // ==========================================
  // 🧠 AI RESUME GENERATE KARNA
  // ==========================================
  void _generateResume() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isGenerating = true);

    // Thoda delay taaki "AI" feel ho
    Future.delayed(const Duration(seconds: 2), () {
      List<String> skillsList = _skillsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      List<String> experienceList = _experienceController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      List<String> projectsList = _projectsController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // AI-generated Professional Summary
      String summary = _generateAISummary(skillsList);

      if (mounted) {
        setState(() {
          generatedResume = {
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'education': _educationController.text.trim(),
            'skills': skillsList,
            'experience': experienceList,
            'projects': projectsList,
            'summary': summary,
            'generatedAt': DateTime.now().toIso8601String(),
          };
          _isGenerating = false;
        });
      }
    });
  }

  // AI Summary Generator
  String _generateAISummary(List<String> skills) {
    String topSkills = skills.take(3).join(', ');
    String education = _educationController.text.trim();

    if (topSkills.isEmpty) {
      return "Motivated student pursuing $education with a strong passion for learning and growth in the technology field.";
    }

    return "Dedicated $education student with expertise in $topSkills. "
        "Passionate about building innovative solutions and continuously improving technical skills. "
        "Seeking opportunities to apply knowledge in real-world projects and grow as a technology professional.";
  }

  // ==========================================
  // RESUME FIRESTORE MEIN SAVE KARNA
  // ==========================================
  Future<void> _saveResume() async {
    if (generatedResume == null) return;

    setState(() => _isSaving = true);
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'resume': generatedResume,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resume saved successfully! ✅'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    _experienceController.dispose();
    _projectsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Resume Builder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: generatedResume == null
            ? _buildForm()
            : _buildResumePreview(),
      ),
    );
  }

  // ==========================================
  // FORM UI
  // ==========================================
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Color(0xFF7E57C2)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome, color: Colors.white, size: 34),
                SizedBox(height: 12),
                Text(
                  'AI Resume Builder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Fill your details and let AI create a professional resume for you.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          _buildField(_nameController, 'Full Name', Icons.person, 'Enter your full name'),
          const SizedBox(height: 15),
          _buildField(_emailController, 'Email', Icons.email, 'Enter your email',
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 15),
          _buildField(_phoneController, 'Phone Number', Icons.phone, 'Enter your phone number',
              keyboardType: TextInputType.phone),
          const SizedBox(height: 15),
          _buildField(_educationController, 'Education', Icons.school, 'e.g., BS Information Technology'),
          const SizedBox(height: 15),
          _buildField(_skillsController, 'Skills (comma separated)', Icons.psychology,
              'e.g., Flutter, Dart, Firebase'),
          const SizedBox(height: 15),
          _buildField(_experienceController, 'Experience (one per line, optional)',
              Icons.work_outline, 'e.g., Internship at ABC Company'),
          const SizedBox(height: 15),
          _buildField(_projectsController, 'Projects (one per line, optional)',
              Icons.folder_outlined, 'e.g., Chat App using Flutter'),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateResume,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                _isGenerating ? 'AI is generating...' : 'Generate Resume with AI',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: label.contains('Experience') || label.contains('Projects') ? 3 : 1,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      validator: (value) {
        if (label.contains('optional')) return null;
        if (value == null || value.trim().isEmpty) {
          return 'Please fill this field';
        }
        return null;
      },
    );
  }

  // ==========================================
  // RESUME PREVIEW UI (AI-Generated)
  // ==========================================
  Widget _buildResumePreview() {
    final resume = generatedResume!;
    final List<String> skills = List<String>.from(resume['skills']);
    final List<String> experience = List<String>.from(resume['experience']);
    final List<String> projects = List<String>.from(resume['projects']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.deepPurple.withOpacity(0.2), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      resume['name'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${resume['email']}  |  ${resume['phone']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Divider(color: Colors.deepPurple.withOpacity(0.3)),
              const SizedBox(height: 10),

              // Professional Summary
              _resumeSection('Professional Summary'),
              const SizedBox(height: 8),
              Text(
                resume['summary'],
                style: const TextStyle(fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 18),

              // Education
              _resumeSection('Education'),
              const SizedBox(height: 8),
              Text(
                resume['education'],
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 18),

              // Skills
              _resumeSection('Skills'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: skills.map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // Experience
              if (experience.isNotEmpty) ...[
                _resumeSection('Experience'),
                const SizedBox(height: 8),
                ...experience.map((exp) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.circle, size: 6, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(exp, style: const TextStyle(fontSize: 13)),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 18),
              ],

              // Projects
              if (projects.isNotEmpty) ...[
                _resumeSection('Projects'),
                const SizedBox(height: 8),
                ...projects.map((proj) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.circle, size: 6, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(proj, style: const TextStyle(fontSize: 13)),
                          ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),

        const SizedBox(height: 25),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => generatedResume = null),
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveResume,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Saving...' : 'Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _resumeSection(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}