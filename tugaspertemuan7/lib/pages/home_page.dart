// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../model_helper.dart';
import 'add_page.dart';
import 'edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    await ItemHelper.loadFromPrefs();
    setState(() {
      items = ItemHelper.getItems();
    });
  }

  Future<void> deleteItem(int id) async {
    await ItemHelper.deleteItem(id);
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tugas Pertemuan 7')),
      body: items.isEmpty
          ? const Center(child: Text("Belum ada data"))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPage(item: item),
                              ),
                            );
                            loadItems();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteItem(item.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );
          loadItems();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
