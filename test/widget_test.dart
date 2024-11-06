import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:rtech_deskapp/models/tickets.dart';
import 'package:rtech_deskapp/models/user_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MockClient extends Mock implements http.Client {}

void main() {
  group('Tickets Tests', () {
    test('Adicionar um ticket', () {
      // Arrange
      final Ticket tickets = Tickets();
      final String descricao = 'Erro na aplicação';
      final String prioridade = 'Alta';

      // Act
      tickets.adicionarTicket(descricao, prioridade);

      // Assert
      expect(tickets.listaTickets.length, 1);
      expect(tickets.listaTickets.first.descricao, descricao);
      expect(tickets.listaTickets.first.prioridade, prioridade);
    });
  });

  group('User Manager Tests', () {
    test('Verificar detalhes do usuário', () {
      // Arrange
      final UserManager userManager = UserManager();
      userManager.login('usuario_teste', 'senha123');

      // Act
      final user = userManager.usuarioAtual;

      // Assert
      expect(user.nome, 'usuario_teste');
      expect(user.estaAutenticado, true);
    });
  });

  group('HTTP Tests with Mock', () {
    test('Filtrar tickets pela prioridade usando Mock HTTP GET', () async {
      // Arrange
      final client = MockClient();
      final Tickets tickets = Tickets();

      final responseJson = [
        {'id': 1, 'descricao': 'Erro na aplicação', 'prioridade': 'Alta'},
        {'id': 2, 'descricao': 'Melhoria na UI', 'prioridade': 'Baixa'},
        {'id': 3, 'descricao': 'Erro na conexão', 'prioridade': 'Alta'},
      ];

      when(client.get(Uri.parse('https://api.exemplo.com/tickets')))
          .thenAnswer((_) async => http.Response(jsonEncode(responseJson), 200));

      // Act
      final response = await client.get(Uri.parse('https://api.exemplo.com/tickets'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        tickets.listaTickets = data
            .map((ticket) => Ticket(
                id: ticket['id'],
                descricao: ticket['descricao'],
                prioridade: ticket['prioridade']))
            .toList();
      }

      final ticketsAltaPrioridade = tickets.listaTickets
          .where((ticket) => ticket.prioridade == 'Alta')
          .toList();

      // Assert
      expect(tickets.listaTickets.length, 3);
      expect(ticketsAltaPrioridade.length, 2);
      expect(ticketsAltaPrioridade.first.descricao, 'Erro na aplicação');
      expect(ticketsAltaPrioridade.last.descricao, 'Erro na conexão');
    });
  });

  group('Widget Tests', () {
    testWidgets('Verificar exibição da lista de tickets', (WidgetTester tester) async {
      // Arrange
      final Tickets tickets = Tickets();
      tickets.adicionarTicket('Erro na aplicação', 'Alta');
      tickets.adicionarTicket('Melhoria na UI', 'Baixa');

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            itemCount: tickets.listaTickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets.listaTickets[index];
              return ListTile(
                title: Text(ticket.descricao),
                subtitle: Text('Prioridade: ${ticket.prioridade}'),
              );
            },
          ),
        ),
      ));

      // Act
      await tester.pump();

      // Assert
      expect(find.text('Erro na aplicação'), findsOneWidget);
      expect(find.text('Melhoria na UI'), findsOneWidget);
      expect(find.text('Prioridade: Alta'), findsOneWidget);
      expect(find.text('Prioridade: Baixa'), findsOneWidget);
    });
  });
}
