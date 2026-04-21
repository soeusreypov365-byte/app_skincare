import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _reminderEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Appearance Section
              _buildSectionHeader('Appearance'),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.dark_mode, color: Color(0xFF9C27B0)),
                      title: const Text('Dark Mode'),
                      subtitle: Text(_getThemeModeText(themeProvider.themeMode)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showThemeDialog(context, themeProvider),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Notifications'),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications, color: Color(0xFF9C27B0)),
                      title: const Text('Push Notifications'),
                      subtitle: const Text('Receive updates and offers'),
                      value: _notificationsEnabled,
                      activeThumbColor: const Color(0xFF9C27B0),
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.alarm, color: Color(0xFF9C27B0)),
                      title: const Text('Routine Reminders'),
                      subtitle: const Text('Get reminded for your skincare routine'),
                      value: _reminderEnabled,
                      activeThumbColor: const Color(0xFF9C27B0),
                      onChanged: (value) {
                        setState(() {
                          _reminderEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('General'),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.language, color: Color(0xFF9C27B0)),
                      title: const Text('Language'),
                      subtitle: Text(_selectedLanguage),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showLanguageDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.storage, color: Color(0xFF9C27B0)),
                      title: const Text('Clear Cache'),
                      subtitle: const Text('Free up storage space'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showClearCacheDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Privacy'),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.privacy_tip, color: Color(0xFF9C27B0)),
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description, color: Color(0xFF9C27B0)),
                      title: const Text('Terms of Service'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // App Version
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            ],
          );
        },
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

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System default';
    }
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: RadioGroup<ThemeMode>(
          groupValue: themeProvider.themeMode,
          onChanged: (value) {
            if (value == null) return;
            themeProvider.setThemeMode(value);
            Navigator.pop(context);
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: Text('Light'),
                value: ThemeMode.light,
              ),
              RadioListTile<ThemeMode>(
                title: Text('Dark'),
                value: ThemeMode.dark,
              ),
              RadioListTile<ThemeMode>(
                title: Text('System default'),
                value: ThemeMode.system,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: RadioGroup<String>(
          groupValue: _selectedLanguage,
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _selectedLanguage = value;
            });
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['English', 'Korean', 'Japanese', 'Chinese'].map((lang) {
              return RadioListTile<String>(
                title: Text(lang),
                value: lang,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the cache? This action cannot be undone.'),
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
                  content: Text('Cache cleared successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
