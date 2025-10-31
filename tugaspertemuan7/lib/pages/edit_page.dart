// lib/pages/edit_page.dart
import 'package:flutter/material.dart';
import '../model_helper.dart';

class EditPage extends StatefulWidget {
  final Item item;

  const EditPage({super.key, required this.item});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController titleController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    descController = TextEditingController(text: widget.item.description);
  }

  Future<void> updateItem() async {
    await ItemHelper.updateItem(
      widget.item.id,
      titleController.text,
      descController.text,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Data')),
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
              onPressed: updateItem,
              child: const Text('Perbarui'),
            ),
          ],
        ),
      ),
    );
  }
}
