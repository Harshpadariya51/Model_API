import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:model_api/model/user.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<user> users = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("MODEL API"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name.first),
            subtitle: Text(user.phone),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchuser,
        child: const Icon(Icons.add),
      ),
    );
  }

  void fetchuser() async {
    print('fetchuser call');
    const url = 'https://randomuser.me/api/?results=100';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['results'] as List<dynamic>;
    final transformed = results.map((e) {
      final name = UserName(
        title: e['name']['title'],
        first: e['name']['first'],
        last: e['name']['last'],
      );
      return user(
        cell: e['cell'],
        email: e['email'],
        nat: e['nat'],
        phone: e['phone'],
        gender: e['gender'],
        name: name,
      );
    }).toList();
    setState(() {
      users = transformed;
    });
    print('fetchuser comp..');
  }
}
