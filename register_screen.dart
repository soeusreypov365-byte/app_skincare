import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/providers/auth_provider.dart';
import 'package:skincare_app/widgets/custom_button.dart';
import 'package:skincare_app/widgets/custom_textfield.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0x199C27B0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.spa,
                    size: 60,
                    color: Color(0xFF9C27B0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Skincare',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9C27B0),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
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
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
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
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock),
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        tooltip: _obscureConfirmPassword ? 'Show password' : 'Hide password',
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return CustomButton(
                    text: 'Register',
                    isLoading: authProvider.isLoading,
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);
                      if (_formKey.currentState!.validate()) {
                        final success =
                        await authProvider.register(
                          email:
                          _emailController.text.trim(),
                          password:
                          _passwordController.text.trim(),
                          fullName:
                          _nameController.text.trim(),
                        );
                        if (!mounted) return;
                        if (success) {
                          navigator.pushReplacementNamed('/home');
                        } else {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                authProvider.error ??
                                    'Registration failed',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Text(
                      'Already have an account? '),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9C27B0),
                      ),
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
