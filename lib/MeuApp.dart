import 'package:flutter/material.dart';
import 'SelecaoHeroiPage.dart';
import 'ChatPage.dart';

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat IA DC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: '/',

      routes: {
        // Rota '/': Tela de Seleção de Herói
        '/': (context) => SelecaoHeroiPage(),

        // Rota '/chat': Tela de Chat
        // Esta tela receberá o objeto Heroi como argumento
        '/chat': (context) => ChatPage(),
      },
    );
  }
}