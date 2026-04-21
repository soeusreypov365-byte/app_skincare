import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/providers/auth_provider.dart';

class SkinAnalysisScreen extends StatefulWidget {
  const SkinAnalysisScreen({super.key});

  @override
  State<SkinAnalysisScreen> createState() => _SkinAnalysisScreenState();
}

class _SkinAnalysisScreenState extends State<SkinAnalysisScreen> {
  String? _selectedSkinType;
  final List<String> _selectedConcerns = [];

  final List<String> _skinTypes = [
    'Normal',
    'Dry',
    'Oily',
    'Combination',
    'Sensitive',
  ];

  final List<String> _skinConcerns = [
    'Acne',
    'Aging',
    'Dark spots',
    'Dryness',
    'Dullness',
    'Fine lines',
    'Large pores',
    'Oiliness',
    'Redness',
    'Uneven texture',
    'Wrinkles',
  ];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _selectedSkinType = authProvider.currentUser?.skinType;
    if (authProvider.currentUser?.skinConcerns != null) {
      _selectedConcerns.addAll(authProvider.currentUser!.skinConcerns!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Analysis'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C27B0), Color(0xFFFFB74D)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.face, size: 50, color: Colors.white),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Know Your Skin',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Help us understand your skin better',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Skin Type Section
                const Text(
                  'What is your skin type?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _skinTypes.map((type) {
                    final isSelected = _selectedSkinType == type;
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedSkinType = selected ? type : null;
                        });
                      },
                      selectedColor: const Color(0xFF9C27B0),
                      backgroundColor: isDark ? Colors.grey.shade800 : null,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // Skin Concerns Section
                const Text(
                  'What are your skin concerns?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select all that apply',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _skinConcerns.map((concern) {
                    final isSelected = _selectedConcerns.contains(concern);
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    return FilterChip(
                      label: Text(concern),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedConcerns.add(concern);
                          } else {
                            _selectedConcerns.remove(concern);
                          }
                        });
                      },
                      selectedColor: isDark 
                          ? const Color(0xFF9C27B0).withValues(alpha: 0.4) 
                          : const Color(0xFF9C27B0).withValues(alpha: 0.2),
                      backgroundColor: isDark ? Colors.grey.shade800 : null,
                      checkmarkColor: isDark ? Colors.white : const Color(0xFF9C27B0),
                      labelStyle: TextStyle(
                        color: isSelected 
                            ? (isDark ? Colors.white : const Color(0xFF9C27B0)) 
                            : (isDark ? Colors.white : Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9C27B0), Color(0xFFFFB74D)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                              final navigator = Navigator.of(context);
                              final messenger = ScaffoldMessenger.of(context);
                              final success = await authProvider.updateUserProfile({
                                'skinType': _selectedSkinType,
                                'skinConcerns': _selectedConcerns,
                              });

                              if (!mounted) return;
                              if (success) {
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Skin profile updated!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                navigator.pop();
                              } else {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(authProvider.error ?? 'Failed to update'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save Skin Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
