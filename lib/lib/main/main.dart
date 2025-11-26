
import 'package:flutter/cupertino.dart';

import '../services/dbservice.dart';
import '../view_models/chat_provider.dart';

void main() async {
  // Garante que o Flutter esteja pronto antes de inicializar o DB
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa os serviços
  final aiService = AiService();
  final dbService = DbService(); // ✅ Inicializa o serviço de DB

  // Garante que o DB foi criado antes de rodar o app
  await dbService.database;

  runApp(
    ChangeNotifierProvider(
      // ✅ Passa os dois serviços para o ChatProvider
      create: (context) => ChatProvider(aiService, dbService),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

}