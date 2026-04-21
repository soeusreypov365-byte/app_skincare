import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/data/models/consultation_model.dart';
import 'package:skincare_app/data/services/payment_service.dart';
import 'package:skincare_app/providers/auth_provider.dart';
import 'package:skincare_app/providers/consultation_provider.dart';
import 'package:skincare_app/widgets/custom_button.dart';

class BookConsultationScreen extends StatefulWidget {
  const BookConsultationScreen({super.key});

  @override
  State<BookConsultationScreen> createState() => _BookConsultationScreenState();
}

class _BookConsultationScreenState extends State<BookConsultationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedType = 'General Consultation';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  final _notesController = TextEditingController();
  bool _isLoading = false;

  final List<String> _consultationTypes = [
    'General Consultation',
    'Skin Analysis',
    'Acne Treatment',
    'Anti-Aging Consultation',
    'Product Recommendation',
  ];

  final Map<String, double> _consultationPrices = {
    'General Consultation': 50.0,
    'Skin Analysis': 75.0,
    'Acne Treatment': 100.0,
    'Anti-Aging Consultation': 120.0,
    'Product Recommendation': 40.0,
  };

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _bookConsultation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final consultationProvider = Provider.of<ConsultationProvider>(context, listen: false);

      if (authProvider.currentUser == null) {
        throw Exception('User not logged in');
      }

      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final price = _consultationPrices[_selectedType]!;

      // Create Stripe customer
      final customerId = await PaymentService.createCustomer(
        email: authProvider.currentUser!.email,
        name: authProvider.currentUser!.fullName,
      );

      // Create payment intent
      final paymentIntent = await PaymentService.createPaymentIntent(
        amount: price,
        currency: 'usd',
        customerId: customerId,
      );

      // Present payment sheet
      await PaymentService.presentPaymentSheet(
        paymentIntentClientSecret: paymentIntent['client_secret'],
      );

      // Create consultation
      final consultation = ConsultationModel(
        id: '', // Will be set by Firestore
        userId: authProvider.currentUser!.id,
        date: dateTime,
        consultationType: _selectedType,
        notes: _notesController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        price: price,
        paymentStatus: 'paid',
        paymentIntentId: paymentIntent['id'],
      );

      final success = await consultationProvider.addConsultation(consultation);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consultation booked successfully!')),
        );
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to book consultation');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = _consultationPrices[_selectedType] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Consultation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Consultation Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                items: _consultationTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a consultation type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Date & Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectTime(context),
                      child: Text(_selectedTime.format(context)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Additional Notes (Optional)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Describe your skin concerns...',
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Consultation Summary',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Type: $_selectedType'),
                    Text('Date: ${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}'),
                    Text('Time: ${_selectedTime.format(context)}'),
                    const SizedBox(height: 8),
                    Text(
                      'Price: \$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: _isLoading ? 'Processing...' : 'Book & Pay',
                onPressed: _isLoading ? null : _bookConsultation,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}