import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FeatureService {
  // ============ GPS & MAPS ============
  static Future<Position?> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> openGoogleMapsAtCurrentLocation() async {
    Position? position = await getCurrentLocation();
    if (position == null) return;

    // Corrected URL format to use the 'geo:' intent for map apps
    final Uri googleMapsUrl = Uri.parse(
      'geo:${position.latitude},${position.longitude}?q=${position.latitude},${position.longitude}',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    }
  }

  static Future<List<Map<String, String>>> getNearbyHotels(
    Position position,
  ) async {
    return [
      {'name': 'Marina Blu', 'distance': '1.2km', 'rating': '4.9'},
      {'name': 'Metro Grand', 'distance': '0.8km', 'rating': '4.8'},
      {'name': 'Alpine Lodge', 'distance': '3.5km', 'rating': '4.7'},
    ];
  }

  // ============ CAMERA ============
  static Future<String?> takePhoto() async {
    try {
      PermissionStatus status = await Permission.camera.request();
      if (!status.isGranted) return null;

      List<CameraDescription> cameras = await availableCameras();
      if (cameras.isEmpty) return null;

      CameraController controller = CameraController(
        cameras[0],
        ResolutionPreset.medium,
      );

      await controller.initialize();
      XFile picture = await controller.takePicture();
      await controller.dispose();

      return picture.path;
    } catch (e) {
      return null;
    }
  }

  static Future<XFile?> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      return await picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      return null;
    }
  }

  // ============ QR CODE ============
  static Future<String?> scanQRCode(BuildContext context) async {
    PermissionStatus status = await Permission.camera.request();
    if (!status.isGranted) return null;

    String? result;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Scan QR")),
          body: MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                result = barcodes.first.rawValue;
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
    );
    return result;
  }

  // ============ NOTIFICATIONS ============
  static Future<void> sendNotification(String title, String body) async {
    return;
  }
}
