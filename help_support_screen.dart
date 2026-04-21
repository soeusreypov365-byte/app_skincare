import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.support_agent, size: 60, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'How can we help you?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'We\'re here to assist you',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Frequently Asked Questions'),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildFAQItem(
                  context,
                  'How do I create a skincare routine?',
                  'Go to the Routines tab and tap the + button to create a new routine. You can add products and set times for morning and evening routines.',
                ),
                const Divider(height: 1),
                _buildFAQItem(
                  context,
                  'How do I track my skin progress?',
                  'Use the Skin Analysis feature in your profile to track changes in your skin over time. Regular updates help you see improvements.',
                ),
                const Divider(height: 1),
                _buildFAQItem(
                  context,
                  'Can I customize my product recommendations?',
                  'Yes! Complete your Skin Analysis to get personalized product recommendations based on your skin type and concerns.',
                ),
                const Divider(height: 1),
                _buildFAQItem(
                  context,
                  'How do I delete my account?',
                  'Go to Settings > Privacy > Delete Account. Please note that this action is irreversible and all your data will be lost.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Contact Options
          _buildSectionHeader('Contact Us'),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.email, color: Color(0xFF9C27B0)),
                  ),
                  title: const Text('Email Support'),
                  subtitle: const Text('support@skincareapp.com'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening email...')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chat, color: Color(0xFF9C27B0)),
                  ),
                  title: const Text('Live Chat'),
                  subtitle: const Text('Chat with our support team'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Starting live chat...')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.phone, color: Color(0xFF9C27B0)),
                  ),
                  title: const Text('Phone Support'),
                  subtitle: const Text('+1 (555) 123-4567'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening dialer...')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Social Media
          _buildSectionHeader('Follow Us'),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(Icons.facebook, 'Facebook'),
                  _buildSocialButton(Icons.camera_alt, 'Instagram'),
                  _buildSocialButton(Icons.play_circle_filled, 'YouTube'),
                  _buildSocialButton(Icons.alternate_email, 'Twitter'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Report a Problem
          OutlinedButton.icon(
            onPressed: () {
              _showReportProblemDialog(context);
            },
            icon: const Icon(Icons.bug_report),
            label: const Text('Report a Problem'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9C27B0),
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF9C27B0)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _showReportProblemDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Problem'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Describe your issue...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report submitted. Thank you!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
