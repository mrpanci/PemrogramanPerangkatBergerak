import 'package:flutter/material.dart';
import 'api_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<dynamic>> users;

  @override
  void initState() {
    super.initState();
    users = ApiService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Users")),
      body: FutureBuilder<List<dynamic>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final user = data[index];

              return ListTile(
                leading: CircleAvatar(child: Text(user["id"].toString())),
                title: Text(user["name"]),
                subtitle: Text(user["email"]),
              );
            },
          );
        },
      ),
    );
  }
}
