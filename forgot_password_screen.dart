import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/providers/auth_provider.dart';
import 'package:skincare_app/widgets/custom_button.dart';
import 'package:skincare_app/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: const Color(0xFF9C27B0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.lock_reset,
                size: 80,
                color: Color(0xFF9C27B0),
              ),
              const SizedBox(height: 20),
              Text(
                'Reset Your Password',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF9C27B0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Enter your email address to receive a password reset link.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return CustomButton(
                    text: 'Send Reset Link',
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);
                      if (_formKey.currentState!.validate()) {
                        final success = await authProvider.sendPasswordResetEmail(
                          email: _emailController.text.trim(),
                        );

                        if (!mounted) return;
                        if (success) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Password reset email sent! Check your inbox.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          navigator.pop();
                        } else {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                  authProvider.error ?? 'Failed to send reset email'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    isLoading: authProvider.isLoading,
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Remembered your password? '),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}