import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Color(0xFF1e3a5f)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1e3a5f)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          // Data list to make it cleaner
          final notifications = [
            {
              'title': 'Special Offer',
              'sub': '20% off on Marina Blu',
              'icon': Icons.local_offer,
              'color': Colors.blue,
            },
            {
              'title': 'Booking Confirmed',
              'sub': 'Stay at Alpine Lodge confirmed',
              'icon': Icons.check_circle,
              'color': Colors.green,
            },
            {
              'title': 'Price Drop',
              'sub': 'Metro Grand reduced by \$50',
              'icon': Icons.trending_down,
              'color': Colors.orange,
            },
          ];

          final item = notifications[index];

          return Container(
            decoration: BoxDecoration(
              // UPDATED: Light blue theme background
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(
                item['icon'] as IconData,
                color: item['color'] as Color,
              ),
              title: Text(
                item['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1e3a5f),
                ),
              ),
              subtitle: Text(
                item['sub'] as String,
                style: const TextStyle(color: Color(0xFF5a6e7e)),
              ),
            ),
          );
        },
      ),
    );
  }
}
