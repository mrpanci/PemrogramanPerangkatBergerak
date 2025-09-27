import 'package:flutter/material.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NewsPage(),
    );
  }
}

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data berita 
    final List<Map<String, String>> newsList = [
      {
        "title": "Comeback Epic No Man's Sky",
        "subtitle":
            "Game No Man’s Sky akhirnya mendapat review positif dari gamers setelah 8 tahun perilisannya di platform steam.",
        "image": "assets/nomansky.jpg"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Berita"),
      ),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          return ListTile(
            leading: Image.asset(
              news["image"]!,
              width: 60,
              fit: BoxFit.cover,
            ),
            title: Text(news["title"]!),
            subtitle: Text(news["subtitle"]!),
            trailing: const Icon(Icons.bookmark_border),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Mengalihkan ke halaman berita"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
