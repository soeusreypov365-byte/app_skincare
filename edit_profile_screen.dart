import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: authProvider.currentUser?.fullName ?? '');
    _emailController = TextEditingController(text: authProvider.currentUser?.email ?? '');
    _phoneController = TextEditingController(text: authProvider.currentUser?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Picture
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: const Color(0xFF9C27B0),
                          child: Text(
                            (authProvider.currentUser?.fullName.isNotEmpty ?? false)
                                ? authProvider.currentUser!.fullName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(fontSize: 48, color: Colors.white),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9C27B0),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Full Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email (read-only)
                  TextFormField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone Number
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                              final navigator = Navigator.of(context);
                              final messenger = ScaffoldMessenger.of(context);
                              if (_formKey.currentState!.validate()) {
                                final success = await authProvider.updateUserProfile({
                                  'fullName': _nameController.text.trim(),
                                  'phoneNumber': _phoneController.text.trim(),
                                });

                                if (!mounted) return;
                                if (success) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Profile updated successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  navigator.pop();
                                } else {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(authProvider.error ?? 'Failed to update profile'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C27B0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save Changes', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
