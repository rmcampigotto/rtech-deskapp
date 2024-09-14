// ignore_for_file: deprecated_member_use

import 'package:url_launcher/url_launcher.dart';

class Ticket {
  String titulo;
  String descricao;
  String telefone;
  String userId;
  bool finalizado;

  Ticket({
    required this.titulo,
    required this.descricao,
    required this.telefone,
    required this.userId,
    this.finalizado = false,
  });

  void finalizarTicket() {
    finalizado = true;
  }

  void excluirTicket(List<Ticket> tickets, int index) {
    tickets.removeAt(index);
  }

  void editarTicket(String novoTitulo, String novaDescricao, String novoTelefone) {
    titulo = novoTitulo;
    descricao = novaDescricao;
    telefone = novoTelefone;
  }

  void abrirWhatsApp(String mensagem) async {
    String url = "https://wa.me/$telefone?text=${Uri.encodeFull(mensagem)}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o WhatsApp!';
    }
  }
}
