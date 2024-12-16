import 'package:managerpassword/utils/encryption_helper.dart';

class Password {
  int? id;
  String title;
  String username;
  String password;
  String passwordView;
  String passwordEncrypted;

  Password({this.id, required this.title, required this.username, required this.password, required this.passwordView, required this.passwordEncrypted});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password
    };
  }

  factory Password.fromMap(Map<String, dynamic> map){
    return Password(
      id: map['id'],
      title: map['title'],
      username: map['username'],
      password: map['password'],
      passwordView: EncryptionHelper.encryptPassword(map['password'], map['username']),
      passwordEncrypted: EncryptionHelper.decryptPassword(map['password'], map['username']),
    );
  }
}