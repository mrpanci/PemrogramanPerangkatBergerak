import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = prefs.getString("username") != null;

  runApp(MyApp(isLogged: isLogged));
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({super.key, required this.isLogged});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'latihan_api2',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLogged ? const UserListPage() : const LoginPage(),
    );
  }
}

// Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  Future<void> saveLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", usernameC.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(
                controller: usernameC,
                decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordC,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async {
                  if (usernameC.text.isEmpty || passwordC.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Username dan Password tidak boleh kosong")),
                    );
                    return;
                  }

                  await saveLogin();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UserListPage()));
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 45)),
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// User List Page
class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List users = [];
  bool isLoading = false;
  String username = "";

  Future<void> fetchUsers() async {
    setState(() => isLoading = true);
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat data pengguna")),
      );
    }
  }

  Future<void> loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => username = prefs.getString("username") ?? "");
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
    loadSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Halo, $username 👋"),
        actions: [
          IconButton(onPressed: fetchUsers, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final u = users[index];
                return Card(
                  child: ListTile(
                    title: Text(u['name']),
                    subtitle: Text("${u['email']} • ${u['address']['city']}"),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
    );
  }
}
