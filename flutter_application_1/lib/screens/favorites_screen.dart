import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart'; // Ensure you import the provider
import 'hotel_details_screen.dart'; // Import this to navigate to details

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We now watch the FavoriteProvider for changes
    final favProvider = Provider.of<FavoriteProvider>(context);
    final favorites = favProvider.favoriteHotels;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '❤️ Favorites',
          style: TextStyle(color: Color(0xFF1e3a5f)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final hotel = favorites[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelDetailsScreen(hotel: hotel),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0,
                    color: const Color(0xFFE3F2FD),
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: Image.asset(
                            hotel.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            hotel.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1e3a5f),
                            ),
                          ),
                          subtitle: Text(
                            '⭐ ${hotel.rating} · \$${hotel.price}/night',
                            style: const TextStyle(color: Color(0xFF5a6e7e)),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            // This now calls the method in your FavoriteProvider
                            onPressed: () => favProvider.toggleFavorite(hotel),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
