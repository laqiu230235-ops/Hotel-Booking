import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/hotel_service.dart';
import '../services/feature_service.dart'; // Ensure this is imported
import 'notifications_screen.dart';
import 'hotel_details_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const FavoriteScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1e3a5f),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Fav'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final hotelService = Provider.of<HotelService>(context);
    final hotels = hotelService.allHotels;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hotels',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1e3a5f),
                      ),
                    ),
                    Text(
                      'Find your perfect stay',
                      style: TextStyle(fontSize: 14, color: Color(0xFF5a6e7e)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // GPS Button
                    IconButton(
                      icon: const Icon(
                        Icons.gps_fixed,
                        color: Color(0xFF1e3a5f),
                      ),
                      onPressed: () =>
                          FeatureService.openGoogleMapsAtCurrentLocation(),
                    ),
                    // NEW: QR Scanner Button
                    IconButton(
                      icon: const Icon(
                        Icons.qr_code_scanner,
                        color: Color(0xFF1e3a5f),
                      ),
                      onPressed: () async {
                        String? result = await FeatureService.scanQRCode(
                          context,
                        );
                        if (result != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Scanned: $result')),
                          );
                        }
                      },
                    ),
                    // Notifications
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        size: 28,
                        color: Color(0xFF1e3a5f),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelDetailsScreen(hotel: hotel),
                    ),
                  ),
                  child: Card(
                    elevation: 0,
                    color: const Color(0xFFE3F2FD),
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: Image.asset(
                            hotel.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hotel.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1e3a5f),
                                ),
                              ),
                              Text(
                                hotel.location,
                                style: const TextStyle(
                                  color: Color(0xFF5a6e7e),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
