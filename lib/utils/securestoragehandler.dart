import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHandler {
  final _credsKey = "credentials";

  late FlutterSecureStorage storage;

  SecureStorageHandler(){
    storage = const FlutterSecureStorage();
  }

  Future<String?> getLoggedInUserCredentials() async {
    return await storage.read(key: _credsKey);
  }

  Future<void> safeCredentials(String credentials) async {
    final creds = await storage.read(key: _credsKey); 

    //Noch nichts gespeichert
    if(creds == null){
      storage.write(key: _credsKey, value: credentials);
    }
  }

  Future<void> signOutCurrentUser() async{
    await storage.delete(key: _credsKey);
  }
}