import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QRGeneratorScreen extends StatelessWidget {
  final String? hotelName;
  final String? hotelId;

  const QRGeneratorScreen({super.key, this.hotelName, this.hotelId});

  @override
  Widget build(BuildContext context) {
    final String bookingData = hotelName != null
        ? 'Hotel: $hotelName\nBooking ID: ${DateTime.now().millisecondsSinceEpoch}\nDate: ${DateTime.now().toString().split(' ')[0]}'
        : 'Hotel Booking\nUser: ${DateTime.now().millisecondsSinceEpoch}\nDate: ${DateTime.now().toString().split(' ')[0]}';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'QR Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1e3a5f),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1e3a5f)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Your Booking QR Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1e3a5f),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hotelName ?? 'Scan to view booking details',
                style: const TextStyle(fontSize: 16, color: Color(0xFF5a6e7e)),
              ),
              const SizedBox(height: 30),

              // QR Container with Theme Background
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: QrImageView(
                  data: bookingData,
                  version: QrVersions.auto,
                  size: 250,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF1e3a5f),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF1e3a5f),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Details Container with Theme Background
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1e3a5f),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bookingData,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5a6e7e),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Share.share('My Hotel Booking: $bookingData'),
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: const Text(
                        'Share',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1e3a5f),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('✅ Saved!'))),
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
