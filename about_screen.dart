import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App Logo & Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.spa,
                      size: 60,
                      color: Color(0xFF9C27B0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Skincare App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About the App
                  const Text(
                    'About the App',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Skincare App is your personal skincare companion that helps you build and maintain healthy skincare routines. Discover products tailored to your skin type, track your skincare journey, and achieve your skin goals.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Features
                  const Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    Icons.face,
                    'Skin Analysis',
                    'Understand your skin type and concerns',
                  ),
                  _buildFeatureItem(
                    Icons.shopping_bag,
                    'Product Discovery',
                    'Find products perfect for your skin',
                  ),
                  _buildFeatureItem(
                    Icons.calendar_today,
                    'Routine Tracking',
                    'Build and follow skincare routines',
                  ),
                  _buildFeatureItem(
                    Icons.notifications,
                    'Smart Reminders',
                    'Never miss your skincare routine',
                  ),
                  const SizedBox(height: 32),

                  // Team
                  const Text(
                    'Our Team',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We are a passionate team of skincare enthusiasts and developers dedicated to helping you achieve healthy, glowing skin through technology.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Legal
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.description, color: Color(0xFF9C27B0)),
                          title: const Text('Terms of Service'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.privacy_tip, color: Color(0xFF9C27B0)),
                          title: const Text('Privacy Policy'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.article, color: Color(0xFF9C27B0)),
                          title: const Text('Licenses'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            showLicensePage(
                              context: context,
                              applicationName: 'Skincare App',
                              applicationVersion: '1.0.0',
                              applicationIcon: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.spa,
                                  size: 48,
                                  color: Color(0xFF9C27B0),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Credits
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Made with ❤️ for healthy skin',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '© 2026 Skincare App. All rights reserved.',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF9C27B0)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
