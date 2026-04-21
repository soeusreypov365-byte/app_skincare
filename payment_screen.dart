import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/data/models/product_model.dart';
import 'package:skincare_app/data/services/local_storage_service.dart';
import 'package:skincare_app/data/services/admin_storage_service.dart';
import 'package:skincare_app/data/services/order_service.dart';
import 'package:skincare_app/data/models/order_model.dart';
import 'package:skincare_app/providers/auth_provider.dart';
import 'package:skincare_app/data/services/payment_service.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _quantity = 1;
  String _selectedPayment = 'card';
  bool _isProcessingPayment = false;
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as ProductModel?;
    
    // Handle case where no product is passed
    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
        ),
        body: const Center(
          child: Text('Error: No product selected'),
        ),
      );
    }
    
    final price = product.price ?? 0;
    final totalPrice = price * _quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Summary
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrl ?? '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Product Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.brand,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF9C27B0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quantity
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Payment Methods
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentOption(
                    value: 'card',
                    title: 'Credit/Debit Card',
                    iconData: Icons.credit_card,
                  ),
                  _buildPaymentOption(
                    value: 'paypal',
                    title: 'ACLEDA',
                    textIcon: 'AC',
                  ),
                  _buildPaymentOption(
                    value: 'apple',
                    title: 'ABA',
                    textIcon: 'ABA',
                  ),
                  _buildPaymentOption(
                    value: 'google',
                    title: 'FTB',
                    textIcon: 'FTB',
                  ),
                ],
              ),
            ),

            // Card Details (if card selected)
            if (_selectedPayment == 'card') ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Card Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Card Number
                    TextField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        hintText: '1234 5678 9012 3456',
                        prefixIcon: const Icon(Icons.credit_card),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Card Holder
                    TextField(
                      controller: _cardHolderController,
                      decoration: InputDecoration(
                        labelText: 'Card Holder Name',
                        hintText: 'John Doe',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Expiry and CVV
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expiryController,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              labelText: 'Expiry Date',
                              hintText: 'MM/YY',
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              hintText: '123',
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            // Order Summary
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal', '\$${(price * _quantity).toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Shipping', 'Free'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Tax', '\$${(totalPrice * 0.1).toStringAsFixed(2)}'),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Total',
                    '\$${(totalPrice * 1.1).toStringAsFixed(2)}',
                    isBold: true,
                  ),
                ],
              ),
            ),

            // Pay Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: _isProcessingPayment
                        ? null
                        : () => _processPayment(totalPrice * 1.1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isProcessingPayment
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Pay \$${(totalPrice * 1.1).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String title,
    IconData? iconData,
    String? textIcon,
  }) {
    final isSelected = _selectedPayment == value;
    final iconColor = isSelected ? const Color(0xFF9C27B0) : Colors.grey;

    final leadingIcon = iconData != null
        ? Icon(
            iconData,
            color: iconColor,
          )
        : Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: iconColor),
            ),
            child: Text(
              textIcon ?? '',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          );

    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF9C27B0) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? const Color(0xFF9C27B0).withValues(alpha: 0.05) : null,
        ),
        child: Row(
          children: [
            leadingIcon,
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF9C27B0) : null,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF9C27B0),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? null : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? const Color(0xFF9C27B0) : null,
          ),
        ),
      ],
    );
  }

  void _processPayment(double amount) async {
    final screenContext = context;
    final product = ModalRoute.of(screenContext)?.settings.arguments as ProductModel?;
    final authProvider = Provider.of<AuthProvider>(screenContext, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(screenContext);
    final navigator = Navigator.of(screenContext);
    bool isLoadingDialogOpen = false;
    
    // Validate product
    if (product == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Error: No product selected for payment'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate payment method
    if (_selectedPayment == 'card' && 
        (_cardNumberController.text.isEmpty || 
         _cardHolderController.text.isEmpty || 
         _expiryController.text.isEmpty || 
         _cvvController.text.isEmpty)) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please fill in all card details'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (mounted) {
      setState(() {
        _isProcessingPayment = true;
      });
    }
    
    showDialog(
      context: screenContext,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF9C27B0),
        ),
      ),
    );
    isLoadingDialogOpen = true;

    try {
      // For non-card methods or missing Stripe keys, allow local completion.
      // This keeps checkout functional in demo/offline mode.
      if (_selectedPayment == 'card' && PaymentService.isConfigured) {
        // Create or get customer ID
        String customerId;
        final currentUser = authProvider.currentUser;
        if (currentUser != null) {
          customerId = await PaymentService.createCustomer(
            email: currentUser.email,
            name: currentUser.fullName,
          );
        } else {
          customerId = await PaymentService.createCustomer(
            email: 'guest@example.com',
            name: 'Guest User',
          );
        }

        // Create payment intent
        final paymentIntent = await PaymentService.createPaymentIntent(
          amount: amount,
          currency: 'usd',
          customerId: customerId,
        );

        // Close loading dialog before presenting payment sheet.
        if (mounted && isLoadingDialogOpen) {
          navigator.pop();
          isLoadingDialogOpen = false;
        }

        // Present payment sheet
        await PaymentService.presentPaymentSheet(
          paymentIntentClientSecret: paymentIntent['client_secret'],
        );
      }

      if (mounted && isLoadingDialogOpen) {
        navigator.pop();
        isLoadingDialogOpen = false;
      }

      // Payment successful - create order
      final orderId = 'ORD_${DateTime.now().millisecondsSinceEpoch}';
      final order = OrderModel(
        id: const Uuid().v4(),
        userId: authProvider.currentUser?.id ?? 'guest_user',
        orderId: orderId,
        productId: product.id,
        productName: product.name,
        productImage: product.imageUrl,
        quantity: _quantity,
        totalAmount: amount,
        paymentMethod: _selectedPayment,
        status: 'Completed',
        orderDate: DateTime.now(),
        createdAt: DateTime.now(),
      );

      // Try to save order to Firestore
      try {
        final orderService = OrderService();
        await orderService.addOrder(order);
      } catch (firestoreError) {
        debugPrint('Failed to save to Firestore (this is normal if Firebase is not configured): $firestoreError');
      }

      // Save order to local storage (always as backup)
      final orderMap = {
        'orderId': orderId,
        'productId': product.id,
        'productName': product.name,
        'productImage': product.imageUrl,
        'quantity': _quantity,
        'totalAmount': amount,
        'paymentMethod': _selectedPayment,
        'status': 'Completed',
        'orderDate': DateTime.now().toIso8601String(),
      };
      
      await LocalStorageService.saveOrder(orderMap);
      await AdminStorageService.addPaymentRecord({
        'orderId': orderId,
        'productName': product.name,
        'quantity': _quantity,
        'amount': amount,
        'paymentMethod': _selectedPayment,
        'status': 'Completed',
        'date': DateTime.now().toIso8601String(),
      });

      // Show success dialog
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
        if (!mounted) return;
        _showSuccessDialog(amount);
      }
    } catch (e) {
      // Close loading dialog
      if (mounted && isLoadingDialogOpen) {
        navigator.pop();
      }
      
      if (!mounted) return;
      setState(() {
        _isProcessingPayment = false;
      });
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog(double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have paid \$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order is being processed',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext); // Close dialog
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
