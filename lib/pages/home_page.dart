// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:rtech_deskapp/models/tickets.dart';
import 'package:rtech_deskapp/models/user.dart';
import 'package:rtech_deskapp/models/user_manager.dart';
import 'package:rtech_deskapp/widgets/tickets_detalhes.dart';
import 'adicionar_ticket_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserManager _userManager = UserManager();
  List<Ticket> tickets = [];

  void _adicionarTicket(String titulo, String descricao, String telefone, String userId) {
    setState(() {
      tickets.add(Ticket(titulo: titulo, descricao: descricao, telefone: telefone, userId: userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Tickets'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          final user = _userManager.listUsers().firstWhere((user) => user.id == ticket.userId, orElse: () => User(id: 'unknown', name: 'Desconhecido'));

          return ListTile(
            title: Text(ticket.titulo, style: GoogleFonts.poppins()),
            subtitle: Text(
              '${user.name} - ${ticket.finalizado ? 'Finalizado' : 'Em andamento'}',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketDetalhes(
                    ticket: ticket,
                    onFinalizarTicket: () {
                      setState(() {
                        ticket.finalizarTicket();
                      });
                    },
                    onExcluirTicket: () {
                      setState(() {
                        ticket.excluirTicket(tickets, index);
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Botão para Gerenciamento de Usuários
          FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserPage()), // Navega para a página de gerenciamento de usuários
              );
            },
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 16.0), // Espaço entre os botões
          // Botão para Adicionar Ticket
          FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdicionarTicketPage(onAdicionarTicket: _adicionarTicket, usuarios: _userManager.listUsers(),),
                ),
              );
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
