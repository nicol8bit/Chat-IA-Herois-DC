class Mensagem {
  final int? id; // ID do banco de dados
  final String heroiId;
  final String texto;
  final bool isUsuario; // true se for do usuário, false se for do herói
  final DateTime timestamp;

  Mensagem({
    this.id,
    required this.heroiId,
    required this.texto,
    required this.isUsuario,
    required this.timestamp,
  });
}