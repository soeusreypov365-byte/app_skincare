import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/providers/auth_provider.dart';
import 'package:skincare_app/providers/consultation_provider.dart';
import 'package:skincare_app/providers/product_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:skincare_app/providers/routine_provider.dart';
import 'package:skincare_app/data/services/admin_storage_service.dart';
import 'package:skincare_app/data/services/local_storage_service.dart';
import 'package:skincare_app/data/models/user_model.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<DateTime> _paymentDates = [];
  List<Map<String, dynamic>> _paymentRecords = [];
  bool _isLoadingPayments = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  Future<void> _loadPaymentHistory() async {
    try {
      final dates = await AdminStorageService.getPaymentDates();
      final records = await AdminStorageService.getPaymentRecords();
      if (!mounted) return;
      setState(() {
        _paymentDates = dates;
        _paymentRecords = records;
        _isLoadingPayments = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _paymentDates = [];
        _paymentRecords = [];
        _isLoadingPayments = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;
    final hasAdminAccess =
        authProvider.isAuthenticated && (currentUser?.isAdmin ?? false);

    if (!hasAdminAccess) {
      return const Scaffold(
        body: Center(
          child: Text('Access Denied: Admin privileges required'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await authProvider.logout();
              if (!mounted) return;
              navigator.pushReplacementNamed('/login');
            },
          ),
        ],
      ),  
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Controls',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Data Management Section
            const Text(
              'Data Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            _buildAdminCard(
              title: 'Export All Data',
              subtitle: 'Save all app data to a file',
              icon: Icons.download,
              onTap: () => _exportAllData(context),
            ),
            
            _buildAdminCard(
              title: 'Clear All User Data',
              subtitle: 'Remove all stored data (except admin)',
              icon: Icons.delete_forever,
              color: Colors.red,
              onTap: () => _showClearDataDialog(context),
            ),

            const SizedBox(height: 16),
            _buildPaymentInfoCard(),
            _buildPaymentStatsCard(),
            const SizedBox(height: 30),
            
            // Statistics Section
            const Text(
              'Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            Consumer<ConsultationProvider>(
              builder: (context, consultationProvider, child) {
                return _buildStatCard(
                  title: 'Total Consultations',
                  value: consultationProvider.consultations.length.toString(),
                  icon: Icons.calendar_today,
                );
              },
            ),
            
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return _buildStatCard(
                  title: 'Total Products',
                  value: productProvider.products.length.toString(),
                  icon: Icons.shopping_bag,
                );
              },
            ),
            
            Consumer<RoutineProvider>(
              builder: (context, routineProvider, child) {
                return _buildStatCard(
                  title: 'Total Routines',
                  value: routineProvider.routines.length.toString(),
                  icon: Icons.list,
                );
              },
            ),

            const SizedBox(height: 30),

            // User Management Section
            const Text(
              'User Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildAdminCard(
              title: 'View All Users',
              subtitle: 'See registered users and their activity',
              icon: Icons.people,
              onTap: () => _showUsersDialog(context),
            ),

            _buildAdminCard(
              title: 'System Info',
              subtitle: 'View app version and system details',
              icon: Icons.info,
              onTap: () => _showSystemInfoDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget _buildPaymentInfoCard() {
    if (_isLoadingPayments) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final lastPaymentDate = _paymentDates.isNotEmpty ? _paymentDates.last : null;
    final hasRecords = _paymentRecords.isNotEmpty;
    final lastRecord = hasRecords ? _paymentRecords.last : null;
    final lastRecordDate = hasRecords
        ? DateTime.tryParse((lastRecord!['date'] ?? '').toString())
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.payment, color: Colors.deepPurple),
        title: const Text('Last Payment'),
        subtitle: Text(
          (lastRecordDate ?? lastPaymentDate) != null
              ? _formatDate(lastRecordDate ?? lastPaymentDate!)
              : 'No payments recorded yet',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: (_paymentDates.isEmpty && _paymentRecords.isEmpty)
              ? null
              : () => _clearPaymentHistory(context),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  double _safeAmount(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Future<void> _clearPaymentHistory(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await AdminStorageService.clearPaymentHistory();
    if (!mounted) return;
    setState(() {
      _paymentDates = [];
      _paymentRecords = [];
    });
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Payment history cleared'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentStatsCard() {
    if (_isLoadingPayments) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final totalPayments =
        _paymentRecords.isNotEmpty ? _paymentRecords.length : _paymentDates.length;
    final DateTime? lastDate = _paymentRecords.isNotEmpty
        ? DateTime.tryParse((_paymentRecords.last['date'] ?? '').toString())
        : (_paymentDates.isNotEmpty ? _paymentDates.last : null);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.payment, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Payment Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Payments:'),
                Text(
                  totalPayments.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            if (lastDate != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Last Payment:'),
                  Text(
                    _formatDate(lastDate),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showPaymentHistoryDialog(context),
              icon: const Icon(Icons.history),
              label: const Text('View Full History'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportAllData(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final consultationProvider = Provider.of<ConsultationProvider>(context, listen: false);
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final routineProvider = Provider.of<RoutineProvider>(context, listen: false);

      // Collect all data
      final data = {
        'exportDate': DateTime.now().toIso8601String(),
        'adminUser': authProvider.currentUser?.toMap(),
        'consultations': consultationProvider.consultations.map((c) => c.toMap()).toList(),
        'products': productProvider.products.map((p) => p.toMap()).toList(),
        'routines': routineProvider.routines.map((r) => r.toMap()).toList(),
      };

      // Get directory for saving file
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'skincare_data_export_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');
      
      // Write data to file
      await file.writeAsString(data.toString());
      
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('Data exported to: ${file.path}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all user data, consultations, routines, and other stored information. This action cannot be undone.\n\nAdmin account will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _clearAllData(context);
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final consultationProvider = Provider.of<ConsultationProvider>(context, listen: false);
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final routineProvider = Provider.of<RoutineProvider>(context, listen: false);

      // Clear all data
      await consultationProvider.clearAllData();
      await productProvider.clearAllData();
      await routineProvider.clearAllData();

      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('All data cleared successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('Clear data failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showUsersDialog(BuildContext context) {
    List<UserModel> allUsers;
    try {
      allUsers = LocalStorageService.getAllUsers();
    } catch (_) {
      allUsers = <UserModel>[];
    }
    final customers = allUsers.where((user) => !user.isAdmin).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Management'),
          content: SizedBox(
            width: double.maxFinite,
            child: customers.isEmpty
                ? const Text('No customer data found yet.')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: customers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = customers[index];
                      return ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: Text(user.fullName),
                        subtitle: Text(user.email),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSystemInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('System Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Skincare App v1.0.0'),
              const SizedBox(height: 8),
              Text('Platform: ${Platform.isAndroid ? 'Android' : Platform.isIOS ? 'iOS' : 'Unknown'}'),
              const SizedBox(height: 8),
              const Text('Built with Flutter'),
              const SizedBox(height: 8),
              const Text('Firebase Integration: Enabled'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment History'),
          content: SizedBox(
            width: double.maxFinite,
            child: _paymentRecords.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _paymentRecords.length,
                    itemBuilder: (context, index) {
                      final record = _paymentRecords[_paymentRecords.length - 1 - index];
                      final date = DateTime.tryParse((record['date'] ?? '').toString());
                      final amount = _safeAmount(record['amount']);
                      final method = (record['paymentMethod'] ?? 'unknown').toString().toUpperCase();
                      final orderId = (record['orderId'] ?? '-').toString();

                      return ListTile(
                        leading: const Icon(Icons.payment, color: Colors.green),
                        title: Text('Order $orderId'),
                        subtitle: Text(
                          '${date != null ? _formatDate(date) : 'Unknown date'} • $method',
                        ),
                        trailing: Text(
                          '\$${amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    },
                  )
                : _paymentDates.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: _paymentDates.length,
                        itemBuilder: (context, index) {
                          final date = _paymentDates[_paymentDates.length - 1 - index];
                          return ListTile(
                            leading: const Icon(Icons.payment, color: Colors.green),
                            title: Text('Payment ${index + 1}'),
                            subtitle: Text(_formatDate(date)),
                          );
                        },
                      )
                    : const Text('No payment history available.'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}