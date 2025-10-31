// lib/model_helper.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Item {
  int id;
  String title;
  String description;

  Item({
    required this.id,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }
}

class ItemHelper {
  static List<Item> _items = [];

  /// --- Menyimpan semua item ke SharedPreferences ---
  static Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        _items.map((item) => jsonEncode(item.toMap())).toList();
    await prefs.setStringList('items', jsonList);
  }

  /// --- Memuat data dari SharedPreferences ---
  static Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('items');

    if (jsonList != null) {
      _items = jsonList
          .map((jsonStr) => Item.fromMap(jsonDecode(jsonStr)))
          .toList();
    }
  }

  // CREATE
  static Future<void> addItem(Item item) async {
    _items.add(item);
    await _saveToPrefs();
  }

  // READ
  static List<Item> getItems() {
    return _items;
  }

  // UPDATE
  static Future<void> updateItem(
      int id, String newTitle, String newDescription) async {
    var index = _items.indexWhere((element) => element.id == id);
    if (index != -1) {
      _items[index].title = newTitle;
      _items[index].description = newDescription;
      await _saveToPrefs();
    }
  }

  // DELETE
  static Future<void> deleteItem(int id) async {
    _items.removeWhere((element) => element.id == id);
    await _saveToPrefs();
  }
}
