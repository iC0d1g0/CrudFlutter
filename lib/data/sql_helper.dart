import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        'CREATE TABLE persona (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nombre TEXT,sexo TEXT, telefono TEXT,correo TEXT, edad TEXT, direccion TEXT,created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,updated_at TIMESTAMP)');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'funciona.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> crearItem(String nombre, String sexo, String telefono,
      String correo, String edad, String? direccion) async {
    final db = await SqlHelper.db();
    final data = {
      'nombre': nombre,
      'sexo': sexo,
      'telefono': telefono,
      'correo': correo,
      'edad': edad,
      'direccion': direccion
    };

    return await db.insert('persona', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getDatos() async {
    final db = await SqlHelper.db();
    return await db.query('persona', orderBy: 'id');
    ;
  }

  static Future<List<Map<String, dynamic>>> getUnaPersona(int id) async {
    final db = await SqlHelper.db();
    return await db.query('persona', where: 'id= ?', whereArgs: [id], limit: 1);
    ;
  }

  static Future<int> actualizar(int id, String nombre, String sexo,
      String telefono, String correo, String edad, String? direccion) async {
    final db = await SqlHelper.db();
    final data = {
      'nombre': nombre,
      'sexo': sexo,
      'telefono': telefono,
      'correo': correo,
      'edad': edad,
      'direccion': direccion,
      'updated_at': DateTime.now().toString()
    };
    final result =
        await db.update('persona', data, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  static Future<void> borrar(int id) async {
    final db = await SqlHelper.db();
    try {
      await db.delete('persona', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print("Error en eliminar datos SQLHELPER: $err");
      debugPrint("ALgo salio mal $err");
    }
  }
}
