import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/booking_service.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We 'watch' the BookingService so this screen updates
    // automatically when a new booking is added.
    final history = context.watch<BookingService>().bookingHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1e3a5f),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1e3a5f)),
      ),
      body: history.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No bookings yet.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final order = history[index];
                // Displaying summary of each booking
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE3F2FD),
                      child: Icon(Icons.hotel, color: Color(0xFF1e3a5f)),
                    ),
                    title: Text(
                      "Booking #${index + 1}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${order.length} hotel(s) booked"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Optional: Navigate to a detailed view of this specific booking
                    },
                  ),
                );
              },
            ),
    );
  }
}
