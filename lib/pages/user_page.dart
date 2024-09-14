// user_page.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:rtech_deskapp/models/user.dart';
import 'package:rtech_deskapp/models/user_manager.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserManager _userManager = UserManager();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _errorMessage = '';

  void _addUser() {
    final id = _idController.text;
    final name = _nameController.text;

    if (id.isNotEmpty && name.isNotEmpty) {
      try {
        _userManager.addUser(User(id: id, name: name));
        setState(() {
          _errorMessage = ''; // Limpa a mensagem de erro
        });
        _idController.clear();
        _nameController.clear();
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _removeUser(String id) {
    setState(() {
      _userManager.removeUser(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciamento de Usuários')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'ID do Usuário'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome do Usuário'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Adicionar Usuário'),
            ),
            if (_errorMessage.isNotEmpty) 
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _userManager.listUsers().length,
                itemBuilder: (context, index) {
                  final user = _userManager.listUsers()[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text('ID: ${user.id}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeUser(user.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
