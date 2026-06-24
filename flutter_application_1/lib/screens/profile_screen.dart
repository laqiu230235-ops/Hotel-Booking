import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../services/auth_service.dart';
import '../services/booking_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedPath = prefs.getString('profile_image_path');
    if (savedPath != null && File(savedPath).existsSync()) {
      setState(() {
        _avatarImage = File(savedPath);
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500,
        maxHeight: 500,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final inputImage = InputImage.fromFile(imageFile);
        final faceDetector = FaceDetector(options: FaceDetectorOptions());
        final List<Face> faces = await faceDetector.processImage(inputImage);
        faceDetector.close();

        if (faces.isNotEmpty) {
          setState(() => _avatarImage = imageFile);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('profile_image_path', pickedFile.path);
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Profile updated!")));
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Put your face inside!"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> _updatePassword(
    String oldPassword,
    String newPassword,
    BuildContext context,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully!')),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred. Please try again.';
        if (e.code == 'wrong-password') {
          message = 'Wrong password. Please check and try again.';
        } else if (e.code == 'weak-password') {
          message = 'The new password is too weak.';
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    }
  }

  void _showEditNameDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
      text: context.read<AuthService>().currentUser?.name ?? '',
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Name"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Enter your new name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<AuthService>().updateName(nameController.text);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _updatePassword(
              oldPasswordController.text,
              newPasswordController.text,
              context,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1e3a5f),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF1e3a5f),
                            width: 3,
                          ),
                          image: _avatarImage != null
                              ? DecorationImage(
                                  image: FileImage(_avatarImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _avatarImage == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Color(0xFF1e3a5f),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1e3a5f),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'Guest User',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1e3a5f),
                    ),
                  ),
                  Text(
                    user?.email ?? 'No email',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5a6e7e),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildMenuItem(
              Icons.person_outline,
              "Edit Name",
              () => _showEditNameDialog(context),
            ),
            _buildMenuItem(
              Icons.lock_outline,
              "Change Password",
              () => _showChangePasswordDialog(context),
            ),
            _buildMenuItem(
              Icons.history,
              "Booking History",
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookingHistoryScreen(),
                ),
              ),
            ),
            const Divider(),
            _buildMenuItem(
              Icons.logout,
              "Log Out",
              () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1e3a5f)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await context.read<AuthService>().logout();
              if (context.mounted)
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final history = context.watch<BookingService>().bookingHistory;
    return Scaffold(
      appBar: AppBar(title: const Text('Booking History')),
      body: history.isEmpty
          ? const Center(child: Text("No bookings yet."))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final order = history[index];
                return ListTile(
                  title: Text("Booking #${index + 1}"),
                  subtitle: Text("${order.length} hotel(s) booked"),
                );
              },
            ),
    );
  }
}
