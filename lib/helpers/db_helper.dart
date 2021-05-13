import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:visit_sps/models/categoria.dart';
import 'package:visit_sps/models/percurso.dart';
import '../models/local.dart';

class DBHelper {
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  //Eliminar Base de Dados

  Future deleteDB() async {
    final db = await database;
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, "visit_sps.db");

    deleteDatabase(dbPath);

    print("base de dados eliminada");

    db.close();
    //-USAR PARA DAR RESET DE FORMA CORRETA ENQUANTO EM DEV -
  }

  //Iniciar base de dados

  Future startDB() async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, "visit_sps.db");

    bool exist = await databaseExists(dbPath);

    if (exist) {
      print("db ja existe");
    } else {
      print("a criar copia dos assets");
      try {
        await Directory(dirname(dbPath)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load("assets/database/visit_sps.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);

      print("db copiada");
    }
    openDatabase(dbPath);
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'visit_sps.db'),
    );
  }

  //Obter lista de todos os locais

  Future<List<Local>> getLocais() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('local');
      return List.generate(
        maps.length,
        (i) {
          return Local.fromMap(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return new List<Local>();
    }
  }

  //Obter um local

  Future<Local> getLocal(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'local',
      where: "id_local = ?",
      whereArgs: [id],
    );

    return Local(
        id: maps[0]["id_local"],
        nome: maps[0]["nome"],
        desc: maps[0]["desc"],
        descEng: maps[0]["desc_eng"],
        imagemUrl: maps[0]["imageUrl"],
        horario: maps[0]["horario"],
        horarioEng: maps[0]["horario_eng"],
        contacto: maps[0]["contacto"],
        morada: maps[0]["morada"],
        latitude: maps[0]["latitude"],
        longitude: maps[0]["longitude"],
        isBook: maps[0]["isBook"],
        trivago: maps[0]["trivago"]);
  }

  //Adicionar/Remover Marcados

  Future alterarBook(int valor, int id) async {
    final Database db = await database;
    return await db.rawUpdate(
      '''
      UPDATE local 
      SET isBook = ? 
      WHERE id_local = ?
      ''',
      [valor, id],
    );
  }

  //Obter lista de todos os Locais marcados

  Future<List<Local>> buscarBook(int book) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'local',
        where: "isBook = ?",
        whereArgs: [book],
      );
      return List.generate(
        maps.length,
        (i) {
          return Local.fromMap(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return new List<Local>();
    }
  }

  //Obter todas as Categorias

  Future<List<Categoria>> getCats() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('categoria');
      return List.generate(
        maps.length,
        (i) {
          return Categoria.fromMap(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return new List<Categoria>();
    }
  }

  //Obter Locais associadas a uma Categoria

  Future<List<Local>> getLocaisCat(int idCat) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT local.id_local, local.nome, local.desc, local.imageUrl, local.horario,
        local.contacto, local.latitude, local.longitude, local.morada, local.isBook, local.desc_eng, local.horario_eng 
        FROM local, categoria, localCategoria
        WHERE (local.id_local = localCategoria.id_local) AND (categoria.id_cat = localCategoria.id_cat) AND (categoria.id_cat = ?)
        ''',
        [idCat],
      );
      return List.generate(
        maps.length,
        (i) {
          return Local.fromMap(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return new List<Local>();
    }
  }

  //Obter Categorias associadas a um Local

  Future<List<Categoria>> getLocalCat(int idLocal) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT categoria.id_cat, categoria.nome, categoria.icon, categoria.nome_eng
        FROM  categoria, local, localCategoria
        WHERE (local.id_local = localCategoria.id_local) AND (categoria.id_cat = localCategoria.id_cat) AND (local.id_local = ?)
        ''',
        [idLocal],
      );
      return List.generate(
        maps.length,
        (i) {
          return Categoria.fromMap(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return new List<Categoria>();
    }
  }

  //Definir isBook para falso

  Future reset() async {
    final Database db = await database;
    return await db.rawUpdate(
      '''
      UPDATE local 
      SET isBook = 0 
      ''',
    );
  }

  //Buscar um local através do seu nome

  Future<List<Local>> procurarLocal(String texto) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        "local",
        where: "nome LIKE ?",
        whereArgs: [
          '%$texto%',
        ],
      );
      return List.generate(
        maps.length,
        (i) {
          return Local.fromMap(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return new List<Local>();
    }
  }

  //Obter Locais com a categoria Natureza

  Future<List<Local>> getLocaisCatNatureza() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT local.id_local, local.nome, local.desc, local.imageUrl, local.horario,
        local.contacto, local.latitude, local.longitude, local.morada, local.isBook, local.desc_eng, local.horario_eng 
        FROM local, categoria, localCategoria
        WHERE (local.id_local = localCategoria.id_local) AND (categoria.id_cat = localCategoria.id_cat) AND (categoria.id_cat = 5)
        ''',
        [],
      );
      return List.generate(
        maps.length,
        (i) {
          return Local.fromMap(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return new List<Local>();
    }
  }

  Future<List<Percurso>> getPercurso() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        ''' SELECT * FROM percurso''',
        [],
      );

      return List.generate(
        maps.length,
        (i) {
          return Percurso.fromMap(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return new List<Percurso>();
    }
  }
}
