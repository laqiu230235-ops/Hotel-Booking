import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using context.watch ensures this screen updates whenever the cart changes
    final cartService = context.watch<CartService>();
    final items = cartService.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🛒 Your Cart',
          style: TextStyle(color: Color(0xFF1e3a5f), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: items.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildCartItem(context, cartService, item);
                    },
                  ),
                ),
                _buildTotalFooter(context, cartService),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('Your cart is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
          Text('Add hotels to get started', style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartService cartService, dynamic item) {
    return Card(
      elevation: 0,
      color: const Color(0xFFE3F2FD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                width: 80, height: 80,
                child: Image.asset(item.hotel.imagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.hotel.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1e3a5f))),
                  Text('\$${item.hotel.price} × ${item.nights} night${item.nights > 1 ? 's' : ''}', 
                    style: const TextStyle(color: Color(0xFF5a6e7e), fontSize: 14)),
                ],
              ),
            ),
            Column(
              children: [
                Text('\$${item.subtotal}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1e3a5f))),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 22),
                      onPressed: () => item.nights > 1 ? cartService.updateQuantity(item.hotel.id, item.nights - 1) : null,
                    ),
                    Text('${item.nights}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 22),
                      onPressed: () => cartService.updateQuantity(item.hotel.id, item.nights + 1),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                      onPressed: () => _showRemoveDialog(context, cartService, item),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, CartService cartService, dynamic item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: const Text('Are you sure you want to remove this hotel from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cartService.removeItem(item.hotel.id);
                Navigator.pop(context);
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTotalFooter(BuildContext context, CartService cartService) {
    final totalPrice = cartService.items.fold(0, (sum, item) => sum + item.subtotal);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1e3a5f))),
              Text('\$${totalPrice}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1e3a5f))),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1e3a5f), padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Proceed to Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}