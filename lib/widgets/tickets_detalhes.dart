import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rtech_deskapp/models/tickets.dart';

class TicketDetalhes extends StatelessWidget {
  final Ticket ticket;
  final Function onFinalizarTicket;
  final Function onExcluirTicket;

  const TicketDetalhes({super.key, 
    required this.ticket,
    required this.onFinalizarTicket,
    required this.onExcluirTicket,
  });

  @override
  Widget build(BuildContext context) {
    final mensagemController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(ticket.titulo, style: GoogleFonts.poppins()),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(ticket.descricao, style: GoogleFonts.poppins()),
            const SizedBox(height: 20),
            TextField(
              controller: mensagemController,
              decoration: const InputDecoration(labelText: 'Mensagem para o cliente'),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ticket.abrirWhatsApp(mensagemController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Enviar WhatsApp'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                onFinalizarTicket();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Finalizar Ticket'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                onExcluirTicket();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}
