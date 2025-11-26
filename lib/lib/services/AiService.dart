

class AiService {
  late final GenerativeModel _model;
  // Mapa para armazenar sessões de chat por herói (mantém o contexto da conversa).
  final Map<String, Chat> _chats = {};

  // Construtor para inicializar a chave da API.
  AiService() {
    // 🛑 ATENÇÃO: COLOQUE A SUA API KEY DO GEMINI AQUI 🛑
    // É ALTAMENTE RECOMENDADO CARREGAR ESTA CHAVE DE FORMA SEGURA (ex: via .env ou dart-define)
    const String apiKey = "AIzaSyDSOeGf12v7fW_CC3b7N61CaSvnouCt6lc";

    if (apiKey.isEmpty) {
      throw Exception("A API Key do Gemini não foi definida.");
    }

    // Inicializa o modelo base
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', // Modelo rápido e ideal para chat
      apiKey: apiKey,
    );
  }

  // Função principal para obter a resposta do herói
  Future<String> getHeroResponse(String heroId, String userMessage) async {
    // 1. Encontrar o herói
    final hero = dcHeroes.firstWhere((h) => h.id == heroId);

    // 2. Tentar recuperar a sessão de chat existente ou criar uma nova se for a primeira mensagem
    if (!_chats.containsKey(heroId)) {
      _initializeChat(hero);
    }

    final chat = _chats[heroId]!;

    try {
      // 3. Enviar a mensagem e esperar a resposta da IA
      final response = await chat.sendMessage(Content.text(userMessage));

      // 4. Retornar o texto da resposta
      return response.text ?? "Desculpe, não consegui gerar uma resposta.";

    } catch (e) {
      print("Erro ao comunicar com a API Gemini: $e");
      // Retorna uma mensagem de erro amigável para o usuário
      return "Erro de Conexão: O herói não está respondendo no momento. (Verifique sua API Key e conexão com a internet).";
    }
  }

  // Inicializa uma nova sessão de chat com a personalidade do herói
  void _initializeChat(HeroCharacter hero) {
    // Configura a instrução do sistema (a personalidade)
    final config = GenerateContentConfig(
      systemInstruction: hero.systemInstruction, // Aqui a personality é injetada
    );

    // Cria e armazena a nova sessão de chat
    _chats[hero.id] = _model.startChat(config: config);
    print("Sessão de chat inicializada para ${hero.name}");
  }
}