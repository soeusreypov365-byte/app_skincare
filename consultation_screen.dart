import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/data/models/consultation_model.dart';
import 'package:skincare_app/providers/auth_provider.dart';
import 'package:skincare_app/providers/consultation_provider.dart';
import 'package:skincare_app/screens/book_consultation_screen.dart';
import 'package:skincare_app/widgets/custom_button.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final consultationProvider = Provider.of<ConsultationProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      consultationProvider.loadUserConsultations(authProvider.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BookConsultationScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer2<AuthProvider, ConsultationProvider>(
        builder: (context, authProvider, consultationProvider, child) {
          if (consultationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (consultationProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${consultationProvider.error}'),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Retry',
                    onPressed: () async {
                      if (authProvider.currentUser != null) {
                        await consultationProvider.loadUserConsultations(authProvider.currentUser!.id);
                      }
                    },
                  ),
                ],
              ),
            );
          }

          final upcoming = consultationProvider.upcomingConsultations;
          final past = consultationProvider.pastConsultations;

          if (upcoming.isEmpty && past.isEmpty) {
            return const Center(
              child: Text('No consultations found. Schedule your first consultation!'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (upcoming.isNotEmpty) ...[
                const Text(
                  'Upcoming Consultations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...upcoming.map((consultation) => _buildConsultationCard(consultation)),
                const SizedBox(height: 24),
              ],
              if (past.isNotEmpty) ...[
                const Text(
                  'Past Consultations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...past.map((consultation) => _buildConsultationCard(consultation)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildConsultationCard(ConsultationModel consultation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(consultation.consultationType),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${consultation.date.toString().split(' ')[0]} at ${consultation.date.toString().split(' ')[1].substring(0, 5)}'),
            Text('Notes: ${consultation.notes}'),
            if (consultation.price != null)
              Text('Price: \$${consultation.price!.toStringAsFixed(2)}'),
            if (consultation.paymentStatus != null)
              Text(
                'Payment: ${consultation.paymentStatus}',
                style: TextStyle(
                  color: consultation.paymentStatus == 'paid' ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (consultation.recommendations != null)
              Text('Recommendations: ${consultation.recommendations}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Consultation'),
                content: const Text('Are you sure you want to delete this consultation?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<ConsultationProvider>(context, listen: false)
                          .deleteConsultation(consultation.id);
                      Navigator.pop(context);
                    },
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}