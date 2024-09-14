// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rtech_deskapp/models/user.dart';

class AdicionarTicketPage extends StatefulWidget {
  final List<User> usuarios; // Lista de usuários
  final Function(String, String, String, String) onAdicionarTicket; // Inclui userId

  const AdicionarTicketPage({super.key, required this.onAdicionarTicket, required this.usuarios});

  @override
  _AdicionarTicketPageState createState() => _AdicionarTicketPageState();
}

class _AdicionarTicketPageState extends State<AdicionarTicketPage> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  String? selectedUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Ticket'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
              style: GoogleFonts.poppins(),
            ),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              style: GoogleFonts.poppins(),
            ),
            TextField(
              controller: telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedUserId,
              hint: const Text('Selecione um usuário'),
              items: widget.usuarios.map((user) {
                return DropdownMenuItem<String>(
                  value: user.id,
                  child: Text(user.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUserId = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (tituloController.text.isNotEmpty &&
                    descricaoController.text.isNotEmpty &&
                    telefoneController.text.isNotEmpty &&
                    selectedUserId != null) {
                  widget.onAdicionarTicket(
                    tituloController.text,
                    descricaoController.text,
                    telefoneController.text,
                    selectedUserId!,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
