import 'package:biribi_financas/models/usuario.dart';
import 'package:sqflite/sqflite.dart';
import 'package:biribi_financas/services/database.dart' as data;


class UsuariosService {
  final data.Database _database = data.Database.create();
  final String _tabela = 'usuarios';

  Future<Usuario> insert(Usuario usuario) async {
    usuario.id = await _database.db.insert(_tabela, usuario.toMap());
    return usuario;
  }

  Future<List<Usuario>> getUsuarios({
    List<RelacionamentosUsuario> relacionamentos,
  }) async {
    List<Map> maps = await _database.db.query(
      _tabela,
      orderBy: 'id DESC',
    );

    if (maps.length == 0) {
      return new List<Usuario>();
    }

    List<Usuario> usuarios = new List<Usuario>();

    for (dynamic p in maps) {
      Usuario usuario = Usuario.fromMap(p);
      await usuario.carregaRelacionamentos(relacionamentos);
      usuarios.add(usuario);
    }

    return usuarios;
  }

  Future<List<Usuario>> getUsuariosByGrupo(int idGrupo,{
    List<RelacionamentosUsuario> relacionamentos,
  }) async {
    List<Map> maps = await _database.db.query(
      _tabela,
      where: 'idGrupo = ?',
      whereArgs: [idGrupo],
      orderBy: 'id DESC',
    );

    if (maps.length == 0) {
      return new List<Usuario>();
    }

    List<Usuario> usuarios = new List<Usuario>();

    for (dynamic p in maps) {
      Usuario usuario = Usuario.fromMap(p);
      await usuario.carregaRelacionamentos(relacionamentos);
      usuarios.add(usuario);
    }

    return usuarios;
  }

  Future<Usuario> getUsuario(int id,
      {List<RelacionamentosUsuario> relacionamentos}) async {
    List<Map> maps = new List<Map>();
    if (id != null)
      maps = await _database.db.query(
        _tabela,
        where: 'id = ?',
        whereArgs: [id],
      );

    if (maps.length > 0) {
      var usuario = Usuario.fromMap(maps.first);
      if (relacionamentos != null) {
        await usuario.carregaRelacionamentos(relacionamentos);
      }
      return usuario;
    }

    return null;
  }

  Future<int> delete(int id) async {
    return await _database.db.delete(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Usuario usuario) async {
    return await _database.db.update(
      _tabela,
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<Usuario> insertOrUpdate(Usuario usuario) async {
    usuario.id = await _database.db.insert(_tabela, usuario.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return usuario;
  }
}
