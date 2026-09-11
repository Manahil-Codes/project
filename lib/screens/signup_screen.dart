import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ==============================
  // SIGNUP FUNCTION (FIREBASE)
  // ==============================
  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    // Password match check
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Firebase Authentication mein account banana
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // 2. User ka naam Firebase Auth profile mein update karna
        await user.updateDisplayName(_nameController.text.trim());

        // 3. Firestore mein user ka data save karna (Dynamic Profile ke liye)
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fullName': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'education': 'Not set',
          'cgpa': 'Not set',
          'careerGoal': 'Not selected yet',
          'skills': [],
          'interests': [],
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;

        // 4. Foran Home Screen par bhej dena (Auto Login)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Signup failed';
      if (e.code == 'weak-password') {
        message = 'Password is too weak. Use at least 6 characters.';
      } else if (e.code == 'email-already-in-use') {
        message = 'This email is already registered. Please login.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 45),

                // Logo
                Center(
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 40,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  'Sign up to start your career journey.',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 35),

                // Full Name
                const Text('Full Name',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Email
                const Text('Email Address',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password
                const Text('Password',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Confirm Password
                const Text('Confirm Password',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Re-enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                          () => _obscureConfirmPassword = !_obscureConfirmPassword),
                      icon: Icon(_obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Signup Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Sign Up',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 30),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(color: Colors.grey.shade600)),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Wapas Login par
                      },
                      child: const Text('Login',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}