import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  // cria/abre a conexao com banco
  static Future<sql.Database> _getDataBase() async {
    return await sql.openDatabase('livro',
        version: 1,
        onCreate: (database, index) => database.execute(_createTable()));
  }

  // sql que gera a tabela
  static String _createTable() {
    return '''
       CREATE TABLE livro (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT NOT NULL,
          autor TEXT NOT NULL
       );
    ''';
  }

  // cria ou atualiza um registro
    static Future<int> gravar(String titulo, String autor, [int id = -1]) async {
      final database = await _getDataBase();
      final values = {'titulo': titulo, 'autor': autor};
      if (id > 0) {
        return database.update('livro', values, where: 'id = ?', whereArgs: [id]);
      } else {
        return database.insert('livro', values);
      }
    }

  // busca um livro pelo seu id
  static Future<List<Map<String, dynamic>>> getlivro(int id) async {
    final database = await _getDataBase();
    return database.query('livro', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getList() async {
    final database = await _getDataBase();
    return database.query('livro', orderBy: 'titulo');
  }

  static Future<bool> deleteItem(int id) async {
    final database = await _getDataBase();

    final linhasAfetadas =
        await database.delete("livro", where: "id = ?", whereArgs: [id]);
    return linhasAfetadas > 0;
  }
}
