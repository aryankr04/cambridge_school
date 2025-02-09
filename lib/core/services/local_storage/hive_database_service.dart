import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabaseService {
  static final HiveDatabaseService instance = HiveDatabaseService._internal();
  HiveDatabaseService._internal();
  factory HiveDatabaseService()=> instance;


  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox<Map<String,dynamic>>('user_data');
  }
  Future<void> saveUser(Map<String, dynamic> userData) async{
    final userBox =  Hive.box<Map<String, dynamic>>('user_data');
    await userBox.put('user',userData);
  }
  Future<Map<String, dynamic>?> getUser() async{
    final userBox =  Hive.box<Map<String, dynamic>>('user_data');
    return userBox.get('user');
  }

  Future<void> deleteUser() async{
    final userBox =  Hive.box<Map<String, dynamic>>('user_data');
    await userBox.delete('user');
  }
  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox<Map<String,dynamic>>('user_data');
  }
}