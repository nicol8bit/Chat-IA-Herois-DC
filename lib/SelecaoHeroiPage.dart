import 'package:flutter/material.dart';
import 'Heroi.dart';

// Dados estáticos
final List<Heroi> heroisDC = [
  Heroi(
    id: 'batman',
    nome: 'Batman',
    avatarUrl: '',
    personalidade: '',
  ),
  Heroi(
    id: 'superman',
    nome: 'Superman',
    avatarUrl: '',
    personalidade: '',
  ),
];

class SelecaoHeroiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione seu Herói'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: heroisDC.length,
        itemBuilder: (context, index) {
          final heroi = heroisDC[index];
          return Card(
            child: InkWell(
              onTap: () {
                // Navegar para a tela de chat, passando o herói selecionado
                Navigator.pushNamed(
                  context,
                  '/chat',
                  arguments: heroi,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Image.asset para o avatar (falta configurar assets no pubspec.yaml)
                  // ícone placeholder
                  Icon(Icons.person, size: 50),
                  SizedBox(height: 10),
                  Text(heroi.nome, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
