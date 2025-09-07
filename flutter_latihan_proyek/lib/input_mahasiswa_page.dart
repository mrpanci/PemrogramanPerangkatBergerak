import 'package:flutter/material.dart';
import 'main.dart'; // Impor Mahasiswa class dari main.dart

class InputMahasiswaPage extends StatefulWidget {
  const InputMahasiswaPage({super.key});

  @override
  State<InputMahasiswaPage> createState() => _InputMahasiswaPageState();
}

class _InputMahasiswaPageState extends State<InputMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _umurController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kontakController = TextEditingController();

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // Buat objek Mahasiswa
      final mahasiswa = Mahasiswa(
        nama: _namaController.text,
        umur: int.parse(_umurController.text),
        alamat: _alamatController.text,
        kontak: _kontakController.text,
      );
      // Kembali ke halaman sebelumnya dan kirim data
      Navigator.pop(context, mahasiswa);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _umurController.dispose();
    _alamatController.dispose();
    _kontakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Data Mahasiswa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Field Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Umur
              TextFormField(
                controller: _umurController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Umur',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Umur tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Alamat
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Kontak
              TextFormField(
                controller: _kontakController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Kontak',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kontak tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _saveData,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
