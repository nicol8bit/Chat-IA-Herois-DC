import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Definição do Alinhamento e Cores
    // O alinhamento determina se a bolha fica à direita (usuário) ou à esquerda (herói)
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;

    // As cores ajudam a distinguir quem está falando (Interface Amigável - Recurso Planejado)
    final color = isUser ? Colors.blue.shade300 : Colors.grey.shade300;
    final textColor = isUser ? Colors.white : Colors.black;

    return Container(
      alignment: alignment,
      child: Container(
        // Margem e Preenchimento
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),

        // 2. Decoração da Bolha
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            // Define o "bico" do balão de chat baseado no remetente
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
          ),
        ),

        // 3. Limita o tamanho máximo da bolha
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),

        // 4. Conteúdo da Mensagem
        child: Text(
          message.text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}