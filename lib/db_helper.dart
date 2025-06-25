import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Palavra {
  final int? id;
  final String palavra;
  final String significado;
  final bool aprendida;

  Palavra({this.id, required this.palavra, required this.significado, this.aprendida = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'palavra': palavra,
      'significado': significado,
      'aprendida': aprendida ? 1 : 0,
    };
  }

  factory Palavra.fromMap(Map<String, dynamic> map) {
    return Palavra(
      id: map['id'],
      palavra: map['palavra'],
      significado: map['significado'],
      aprendida: map['aprendida'] == 1,
    );
  }
}

class DBHelper {
  static Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'palavras.db');

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE palavras(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            palavra TEXT,
            significado TEXT,
            aprendida INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<void> inserirPalavra(Palavra palavra) async {
    final db = await _getDatabase();
    await db.insert(
      'palavras',
      palavra.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Palavra>> listarPalavras() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('palavras');

    return List.generate(maps.length, (i) {
      return Palavra.fromMap(maps[i]);
    });
  }

  static Future<void> atualizarPalavra(Palavra palavra) async {
    final db = await _getDatabase();
    await db.update(
      'palavras',
      palavra.toMap(),
      where: 'id = ?',
      whereArgs: [palavra.id],
    );
  }

  static Future<void> deletarPalavra(int id) async {
    final db = await _getDatabase();
    await db.delete(
      'palavras',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
