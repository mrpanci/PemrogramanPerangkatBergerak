import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://jsonplaceholder.typicode.com";

  static Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/users"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengambil data");
    }
  }
}
