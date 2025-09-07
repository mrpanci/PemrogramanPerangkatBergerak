import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile_page.dart';
import 'input_mahasiswa_page.dart';

// Class sederhana untuk menampung data mahasiswa
class Mahasiswa {
  final String nama;
  final int umur;
  final String alamat;
  final String kontak;

  Mahasiswa({
    required this.nama,
    required this.umur,
    required this.alamat,
    required this.kontak,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contoh Navigasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Mahasiswa? _mahasiswa;

  // Latihan 1: Navigasi sederhana ke ProfilePage
  void _navigateToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  // Latihan 2: Navigasi dan menerima data dari InputMahasiswaPage
  void _navigateAndReceiveData() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InputMahasiswaPage()),
    );

    if (result != null && result is Mahasiswa) {
      setState(() {
        _mahasiswa = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data mahasiswa berhasil disimpan!')),
      );
    }
  }

  // Latihan 3: Membuka aplikasi telepon dengan nomor kontak
  void _callContact() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: _mahasiswa!.kontak,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Utama'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Tombol untuk Latihan 1
              ElevatedButton(
                onPressed: _navigateToProfilePage,
                child: const Text('Ke Halaman Profil'),
              ),
              const SizedBox(height: 20),

              // Tombol untuk Latihan 2
              ElevatedButton(
                onPressed: _navigateAndReceiveData,
                child: const Text('Input Data Mahasiswa'),
              ),
              const SizedBox(height: 40),

              // Tampilkan data mahasiswa yang diterima
              if (_mahasiswa != null) ...[
                const Text(
                  'Data Mahasiswa:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Nama: ${_mahasiswa!.nama}'),
                Text('Umur: ${_mahasiswa!.umur}'),
                Text('Alamat: ${_mahasiswa!.alamat}'),
                Text('Kontak: ${_mahasiswa!.kontak}'),
                const SizedBox(height: 20),

                // Tombol untuk Latihan 3 (hanya muncul jika ada data kontak)
                ElevatedButton(
                  onPressed: _callContact,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Call'),
                ),
              ] else ...[
                const Text('Belum ada data mahasiswa.'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
