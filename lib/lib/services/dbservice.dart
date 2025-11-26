import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../../models/message.dart';
import '../../../models/hero_character.dart';

class DbService {
  static Database? _database;

  // Nomes das tabelas
  final String tableName = 'messages';
  final String heroTable = 'heroes';

  // Inicializa o banco de dados (será chamado uma vez)
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'conversas.db'); // Nome do arquivo DB

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    // 1. Tabela de Mensagens
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        heroId TEXT NOT NULL,
        text TEXT NOT NULL,
        senderId TEXT NOT NULL, 
        timestamp INTEGER NOT NULL
      )
    ''');

    // 2. Tabela de Heróis (para armazenar as informações, incluindo a System Instruction)
    await db.execute('''
      CREATE TABLE $heroTable (
        id TEXT PRIMARY KEY,
        name TEXT,
        avatarUrl TEXT,
        systemInstruction TEXT
      )
    ''');

    // Insere os heróis iniciais no banco (opcional, mas bom para persistência)
    for (var hero in dcHeroes) {
      await db.insert(heroTable, {
        'id': hero.id,
        'name': hero.name,
        'avatarUrl': hero.avatarUrl,
        'systemInstruction': hero.systemInstruction,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // ✅ SALVA A MENSAGEM NO BANCO DE DADOS
  Future<int> saveMessage(Message message) async {
    final db = await database;
    return db.insert(
      tableName,
      {
        'heroId': message.senderId == 'user' ? 'N/A' : message.senderId, // Simplificado, idealmente você passa o ID do herói
        'text': message.text,
        'senderId': message.senderId,
        'timestamp': message.timestamp.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ CARREGA O HISTÓRICO DE CONVERSAS PARA UM HERÓI ESPECÍFICO
  Future<List<Message>> loadHistory(String heroId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'heroId = ?',
      whereArgs: [heroId],
      orderBy: 'timestamp ASC', // Ordena por data/hora
    );

    return List.generate(maps.length, (i) {
      return Message(
        text: maps[i]['text'],
        senderId: maps[i]['senderId'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(maps[i]['timestamp']),
      );
    });
  }
}