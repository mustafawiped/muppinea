// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:src/models/searchmodel.dart';
import 'package:src/services/auth/authservice.dart';

// ignore: camel_case_types
class localRecents {
  Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'recents.db');

    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE recents (owner TEXT, docId TEXT PRIMARY KEY, accName TEXT, profilePhoto TEXT, aboutText TEXT)");
      },
      version: 3,
    );
  }

  // Yeni kullanıcı ekle
  Future<void> insertUser(searchUserDatas user) async {
    final db = await database();

    await db.insert('recents', toMap(user),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteUser(String docId) async {
    final db = await database();
    await db.delete(
      'recents',
      where: 'owner = ? AND docId = ?',
      whereArgs: [AuthService.me.id, docId],
    );
  }

  Map<String, dynamic> toMap(user) {
    searchUserDatas userDatas = user;

    return {
      'owner': AuthService.me.id,
      'docId': userDatas.documentId,
      'accName': userDatas.username,
      'profilePhoto': userDatas.pp,
      'aboutText': userDatas.about,
    };
  }

  Future<List<searchUserDatas>?> getAllRecents() async {
    try {
      final db = await database();
      final List<Map<String, dynamic>> userData = await db.query(
        'recents',
        columns: ['docId, accName, profilePhoto, aboutText'],
        where: "owner = ?",
        whereArgs: [AuthService.me.id],
        limit: 20,
      );

      List<searchUserDatas> userList = [];

      for (Map<String, dynamic> data in userData) {
        userList.add(searchUserDatas(
          username: data['accName'],
          pp: data["profilePhoto"],
          documentId: data['docId'],
          about: data['aboutText'],
        ));
      }

      if (userList.isNotEmpty) {
        return userList;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("localRecent | Error: $e");
      }
      return [];
    }
  }
}
