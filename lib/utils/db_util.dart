import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

// Classe utilitária para centralizar funções relacionadas ao banco de dados SQLite
class DbUtil {

  // Função que inicializa e retorna a instância do banco de dados
  static Future<sql.Database> database() async {
    // Pega o caminho onde os bancos de dados do app são armazenados
    final dbPath = await sql.getDatabasesPath();

    // Abre (ou cria, se não existir) o banco de dados chamado 'places.db
    return sql.openDatabase(
      // Define o caminho completo do arquivo do banco
      path.join(dbPath, 'places.db'),
      // Esta função é executada apenas na criação do banco (primeira vez)
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE places (id TEXT PRIMARY KEY, title TEXT, image TEXT, latitude REAL, longitude REAL, address TEXT)',
        );
      },
      // Versão do banco — importante para futuras migrações
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    // Obtém a instância atual do banco
    final db = await DbUtil.database();
    // Insere os dados, se o id já existir, substitui o registro (útil para evitar duplicações)
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  // Função para buscar todos os registros de uma tabela específica
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();

    // Retorna os dados da tabela (como uma lista de mapas)
    return db.query(table);
  }
}
