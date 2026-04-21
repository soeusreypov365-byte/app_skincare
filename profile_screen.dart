import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/providers/auth_provider.dart';
import 'package:skincare_app/screens/profile/edit_profile_screen.dart';
import 'package:skincare_app/screens/profile/skin_analysis_screen.dart';
import 'package:skincare_app/screens/profile/settings_screen.dart';
import 'package:skincare_app/screens/profile/help_support_screen.dart';
import 'package:skincare_app/screens/profile/about_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                
                // Profile Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF9C27B0),
                  child: Text(
                    (user?.fullName.isNotEmpty ?? false)
                        ? user!.fullName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // User Name
                Text(
                  user?.fullName ?? 'User',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                
                // User Email
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Menu Items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.face,
                        title: 'Skin Analysis',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SkinAnalysisScreen(),
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.admin_panel_settings,
                        title: 'Admin Dashboard',
                        onTap: () {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          if (authProvider.currentUser?.isAdmin ?? false) {
                            Navigator.pushNamed(context, '/admin');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('You do not have permission to access Admin Dashboard.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpSupportScreen(),
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.info_outline,
                        title: 'About',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF9C27B0),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
