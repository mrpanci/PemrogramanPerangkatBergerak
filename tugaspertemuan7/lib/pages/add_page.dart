// lib/pages/add_page.dart
import 'package:flutter/material.dart';
import '../model_helper.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  Future<void> saveItem() async {
    final newItem = Item(
      id: DateTime.now().millisecondsSinceEpoch,
      title: titleController.text,
      description: descController.text,
    );
    await ItemHelper.addItem(newItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveItem,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
