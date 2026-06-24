import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hotel.dart';
import '../providers/favorite_provider.dart';
import '../services/cart_service.dart';
import 'cart_screen.dart';

class HotelDetailsScreen extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailsScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoriteProvider>();
    final isFavorite = favProvider.isFavorite(hotel.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(hotel.imagePath, fit: BoxFit.cover),
            ),
            actions: [
              // 1. Existing Favorite Icon
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                  size: 30,
                ),
                onPressed: () => favProvider.toggleFavorite(hotel),
              ),
              // 2. New Add-to-Cart Heart Icon
              Consumer<CartService>(
                builder: (context, cart, child) {
                  final isInCart = cart.isFavorite(hotel);
                  return IconButton(
                    icon: Icon(
                      isInCart
                          ? Icons.shopping_cart
                          : Icons.shopping_cart_outlined,
                      color: isInCart ? Colors.yellow : Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      cart.toggleFavorite(hotel);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isInCart ? "Removed from Cart" : "Added to Cart",
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1e3a5f),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hotel.location,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1e3a5f),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(hotel.description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const Text(
                    'Amenities',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1e3a5f),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: hotel.features
                        .map(
                          (feature) => Chip(
                            label: Text(feature),
                            backgroundColor: const Color(0xFFE3F2FD),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${hotel.price} / night',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF01579B),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CartService>().addItem(hotel);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ),
                          );
                        },
                        child: const Text('Book Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
