// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const AssistenciaTecnicaApp());
}

class AssistenciaTecnicaApp extends StatelessWidget {
  const AssistenciaTecnicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        primaryColor: Colors.teal,
        appBarTheme: AppBarTheme(
          color: Colors.teal,
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.primary, // Garantir que o texto do botão seja branco
        ),
      ),
    );
  }
}

class Ticket {
  String titulo;
  String descricao;
  String telefone;
  bool finalizado;

  Ticket({
    required this.titulo,
    required this.descricao,
    required this.telefone,
    this.finalizado = false,
  });

  // Método para finalizar o ticket
  void finalizarTicket() {
    finalizado = true;
  }

  // Método para excluir o ticket
  void excluirTicket(List<Ticket> tickets, int index) {
    tickets.removeAt(index);
  }

  // Método para editar o ticket
  void editarTicket(String novoTitulo, String novaDescricao, String novoTelefone) {
    titulo = novoTitulo;
    descricao = novaDescricao;
    telefone = novoTelefone;
  }

  // Método para abrir o WhatsApp
  void abrirWhatsApp(String mensagem) async {
    String url = "https://wa.me/$telefone?text=${Uri.encodeFull(mensagem)}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o WhatsApp!';
    }
  }

  // Widget que detalha o ticket
  Widget detalhesWidget(
      BuildContext context, Function onFinalizarTicket, Function onExcluirTicket) {
    final _mensagemController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo, style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(descricao, style: GoogleFonts.poppins()),
            const SizedBox(height: 20),
            TextField(
              controller: _mensagemController,
              decoration: const InputDecoration(labelText: 'Mensagem para o cliente'),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                abrirWhatsApp(_mensagemController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white, // Texto do botão branco
              ),
              child: const Text('Enviar WhatsApp'),
            ),
            ElevatedButton(
              onPressed: () {
                onFinalizarTicket();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white, // Texto do botão branco
              ),
              child: const Text('Finalizar Ticket'),
            ),
            ElevatedButton(
              onPressed: () {
                onExcluirTicket();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white, // Texto do botão branco
              ),
              child: const Text('Excluir Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Ticket> tickets = [];

  // Método para adicionar um novo ticket
  void _adicionarTicket(String titulo, String descricao, String telefone) {
    setState(() {
      tickets.add(Ticket(titulo: titulo, descricao: descricao, telefone: telefone));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Tickets'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tickets[index].titulo, style: GoogleFonts.poppins()),
            subtitle: Text(
              tickets[index].finalizado ? 'Finalizado' : 'Em andamento',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => tickets[index].detalhesWidget(
                    context,
                    () {
                      setState(() {
                        tickets[index].finalizarTicket();
                      });
                    },
                    () {
                      setState(() {
                        tickets[index].excluirTicket(tickets, index);
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _adicionarTicketWidget(),
            ),
          );
        },
      ),
    );
  }

  // Tela para adicionar ticket
  Widget _adicionarTicketWidget() {
    final _tituloController = TextEditingController();
    final _descricaoController = TextEditingController();
    final _telefoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Ticket'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
              style: GoogleFonts.poppins(),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              style: GoogleFonts.poppins(),
            ),
            TextField(
              controller: _telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _adicionarTicket(
                  _tituloController.text,
                  _descricaoController.text,
                  _telefoneController.text,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white, // Texto do botão branco
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
