import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// ====================================================================
// MODEL DATA (Kriteria 5)
// ====================================================================
class News {
  final String title;
  final String subtitle;
  final String reporter;
  final String imageUrl;
  final String email;

  News({
    required this.title,
    required this.subtitle,
    required this.reporter,
    required this.imageUrl,
    required this.email,
  });

  // Konversi objek News menjadi Map (untuk SharedPreferences)
  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'reporter': reporter,
        'imageUrl': imageUrl,
        'email': email,
      };

  // Membuat objek News dari Map (dari SharedPreferences)
  factory News.fromJson(Map<String, dynamic> json) => News(
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        reporter: json['reporter'] as String,
        imageUrl: json['imageUrl'] as String,
        email: json['email'] as String,
      );
}


// APLIKASI UTAMA
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game News App UTS',
      theme: ThemeData(
        // Kriteria 7: Desain Rapi dan Konsisten
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      // Definisikan rute untuk navigasi
      initialRoute: '/',
      routes: {
        '/': (context) => const MainLayout(selectedIndex: 0),
        '/add': (context) => const MainLayout(selectedIndex: 1),
      },
    );
  }
}

// LAYOUT DENGAN BOTTOM NAVIGATION BAR (Kriteria 3 & 4)
class MainLayout extends StatefulWidget {
  final int selectedIndex;
  const MainLayout({super.key, required this.selectedIndex});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;

  // Daftar halaman
  static final List<Widget> _widgetOptions = <Widget>[
    const NewsListPage(),
    const AddNewsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi menggunakan rute bernama untuk memperbarui URL (pada web)
    if (index == 0) {
      Navigator.pushNamed(context, '/');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/add');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kriteria 3: Navigation Bar (AppBar) yang sama persis
      appBar: AppBar(
        title: const Text('Game News Portal'),
        centerTitle: true,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      // Kriteria 3: Navigation Bar (BottomNavigationBar) yang sama persis
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Berita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Tambah',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[800], // Kriteria 7: Style
        unselectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
      ),
    );
  }
}

// HALAMAN 1: LIST VIEW BERITA (Kriteria 1, 5, 6, 7)
class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<News> _newsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  // Muat data dari SharedPreferences (Kriteria 5)
  Future<void> _loadNews() async {
    final prefs = await SharedPreferences.getInstance();
    final String? newsString = prefs.getString('news_data');
    if (newsString != null) {
      final List<dynamic> jsonList = jsonDecode(newsString);
      setState(() {
        _newsList = jsonList.map((json) => News.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dipanggil setiap kali halaman diakses (untuk memperbarui list)
    _loadNews();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_newsList.isEmpty) {
      return const Center(
        child: Text('Belum ada berita. Tambahkan berita baru!'),
      );
    }

    return ListView.builder(
      // Kriteria 7: Padding
      padding: const EdgeInsets.all(8.0), 
      itemCount: _newsList.length,
      itemBuilder: (context, index) {
        final news = _newsList[index];
        return Card( // Kriteria 6: Card
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4.0,
          child: ListTile(
            // Kriteria 1: Leading (menggunakan Image)
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Kriteria 7: Style
              child: news.imageUrl.startsWith('http')
                  ? Image.network(news.imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                  : Image.asset(
                      news.imageUrl, 
                      width: 60, 
                      height: 60, 
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 40, color: Colors.grey), // Kriteria 6: Widget Tambahan
                    ),
            ),
            // Kriteria 1: Title
            title: Text(
              news.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Kriteria 7: Style
            ),
            // Kriteria 1: Subtitle
            subtitle: Text(
              'Oleh: ${news.reporter}\n${news.subtitle}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            isThreeLine: true,
            // Kriteria 1: Trailing
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reporter Email: ${news.email}')), // Kriteria 6: SnackBar
              );
            },
          ),
        );
      },
    );
  }
}

// HALAMAN 2: FORM TAMBAH BERITA (Kriteria 2 & 5)
class AddNewsPage extends StatefulWidget {
  const AddNewsPage({super.key});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _reporterController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _emailController = TextEditingController();

  // Simpan data ke SharedPreferences (Kriteria 5)
  Future<void> _saveNews(News news) async {
    final prefs = await SharedPreferences.getInstance();
    final String? newsString = prefs.getString('news_data');

    List<News> newsList = [];
    if (newsString != null) {
      final List<dynamic> jsonList = jsonDecode(newsString);
      newsList = jsonList.map((json) => News.fromJson(json)).toList();
    }
    
    // Tambahkan data baru
    newsList.add(news);
    
    // Simpan kembali
    final String updatedNewsString = jsonEncode(newsList.map((n) => n.toJson()).toList());
    await prefs.setString('news_data', updatedNewsString);

    // Tampilkan notifikasi dan reset form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Berita berhasil ditambahkan!')),
    );
    _formKey.currentState!.reset();
    
    // Navigasi ke halaman utama untuk memperbarui tampilan list
    Navigator.pushNamed(context, '/'); 
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Kriteria 7: Padding
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            // Input Judul (Validasi kosong)
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Berita',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.article),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),

            // Input Ringkasan (Kriteria 2: Validasi panjang karakter minimal 20)
            TextFormField(
              controller: _subtitleController,
              decoration: const InputDecoration(
                labelText: 'Ringkasan Berita',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.subject),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.length < 20) {
                  return 'Ringkasan minimal 20 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),

            // Input Nama Reporter
            TextFormField(
              controller: _reporterController,
              decoration: const InputDecoration(
                labelText: 'Nama Reporter',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama reporter wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),

            // Input Email (Kriteria 2: Validasi Format Email)
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Kontak Reporter',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email wajib diisi';
                }
                // Validasi format email sederhana menggunakan RegExp
                final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegExp.hasMatch(value)) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),

            // Input URL/Path Gambar
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Path Gambar (cth: assets/images/p5.jpg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
                helperText: 'Bisa path aset atau URL web',
              ),
            ),
            const SizedBox(height: 24.0),

            // Tombol Simpan
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newNews = News(
                    title: _titleController.text,
                    subtitle: _subtitleController.text,
                    reporter: _reporterController.text,
                    imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : 'assets/images/default.png', // Fallback
                    email: _emailController.text,
                  );
                  _saveNews(newNews);
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Simpan Berita Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), // Kriteria 7: Style
              ),
            ),
          ],
        ),
      ),
    );
  }
}