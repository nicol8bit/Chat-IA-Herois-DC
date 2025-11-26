import 'package:flutter/material.dart';
import '../models/Heroi.dart';
import '../models/Mensagem.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Mensagem> _mensagens = []; // Lista de mensagens (inicialmente vazia)
  late Heroi heroi;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtém o herói passado como argumento da rota
    heroi = ModalRoute.of(context)!.settings.arguments as Heroi;
  }

  void _enviarMensagem(String texto) {
    if (texto.isEmpty) return;

    final novaMensagem = Mensagem(
      heroiId: heroi.id,
      texto: texto,
      isUsuario: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _mensagens.add(novaMensagem);
    });

    _controller.clear();
    // Chamar a API de IA para obter a resposta do herói
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversando com ${heroi.nome}'),
      ),
      body: Column(
        children: <Widget>[
          // Lista de Mensagens
          Expanded(
            child: ListView.builder(
              reverse: true, // Para mostrar as mensagens mais recentes embaixo
              itemCount: _mensagens.length,
              itemBuilder: (context, index) {
                final mensagem = _mensagens[_mensagens.length - 1 - index];
                // Substituir por um widget de balão de mensagem mais elaborado
                return Align(
                  alignment: mensagem.isUsuario ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: mensagem.isUsuario ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(mensagem.texto),
                  ),
                );
              },
            ),
          ),
          // Área de Input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onSubmitted: _enviarMensagem, // Envia ao pressionar Enter
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () => _enviarMensagem(_controller.text),
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}