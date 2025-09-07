import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Profile Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Nama Aplikasi: My Flutter App'),
            const SizedBox(height: 8),
            const Text('Versi: 1.0.0'),
            const SizedBox(height: 8),
            const Text('Developer: Fachry Firdaus Avicenna'),
          ],
        ),
      ),
    );
  }
}
