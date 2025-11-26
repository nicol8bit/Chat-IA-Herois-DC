import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/hero_character.dart';
import '../services/ai_service.dart';
import '../services/AiService.dart'; // ✅ NOVO IMPORT

class ChatProvider with ChangeNotifier {
  final AiService _aiService;
  final DbService _dbService; // ✅ INSTÂNCIA DO DB SERVICE

  List<Message> _messages = [];
  HeroCharacter? _selectedHero;
  bool _isLoading = false;

  List<Message> get messages => _messages;
  HeroCharacter? get selectedHero => _selectedHero;
  bool get isLoading => _isLoading;

  // ✅ O construtor agora exige os dois serviços
  ChatProvider(this._aiService, this._dbService);

  // --- Lógica de Seleção de Herói (Carrega Histórico) ---
  void selectHero(HeroCharacter hero) async {
    _selectedHero = hero;

    // 1. ✅ CARREGA O HISTÓRICO DO SQLITE
    _messages = await _dbService.loadHistory(hero.id);

    notifyListeners();
  }

  // --- Lógica do Chat (Salva Mensagens) ---
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _selectedHero == null) return;

    final userMessage = Message(
      text: text,
      senderId: 'user',
      timestamp: DateTime.now(),
    );

    // 1. Adiciona e salva a mensagem do usuário
    _messages.add(userMessage);
    await _dbService.saveMessage(userMessage); // ✅ SALVA NO DB

    _isLoading = true;
    notifyListeners();

    // 2. Chama o serviço de IA
    final heroResponseText = await _aiService.getHeroResponse(
      _selectedHero!.id,
      text,
    );

    final heroMessage = Message(
      text: heroResponseText,
      senderId: _selectedHero!.id,
      timestamp: DateTime.now(),
    );

    // 3. Adiciona e salva a resposta do herói
    _messages.add(heroMessage);
    await _dbService.saveMessage(heroMessage); // ✅ SALVA NO DB

    // 4. Finaliza o carregamento
    _isLoading = false;
    notifyListeners();
  }
}