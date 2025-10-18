import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Mahasiswa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StudentFormPage(),
    );
  }
}

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  _StudentFormPageState createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Data Mahasiswa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const Icon(Icons.school, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Isi Data Mahasiswa',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 25),

              // Input Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Input Nomor HP
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Nomor HP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor HP tidak boleh kosong';
                  }
                  if (value.length < 10) {
                    return 'Nomor HP minimal 10 digit';
                  }
                  if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
                    return 'Nomor HP hanya boleh angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Input Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email (@unsika.ac.id)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.endsWith('@unsika.ac.id')) {
                    return 'Gunakan Email dengan akhiran @unsika.ac.id';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Input Jenis Kelamin
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.wc),
                  labelText: 'Jenis Kelamin',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Laki-laki',
                    child: Text('Laki-laki'),
                  ),
                  DropdownMenuItem(
                    value: 'Perempuan',
                    child: Text('Perempuan'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih jenis kelamin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),

              // Tombol Simpan
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          name: _nameController.text,
                          phone: _phoneController.text,
                          email: _emailController.text,
                          gender: _selectedGender!,
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text('Kirim & Tampilkan Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String gender;

  const ResultPage({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Hasil Data Mahasiswa'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.grey[400]),
                const SizedBox(height: 10),
                InfoRow(icon: Icons.phone, label: 'Nomor HP', value: phone),
                InfoRow(icon: Icons.email, label: 'Email', value: email),
                InfoRow(icon: Icons.wc, label: 'Jenis Kelamin', value: gender),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali ke Form'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(45),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
