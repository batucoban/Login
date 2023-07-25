import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:login/core/service/model/user.dart';
import 'package:login/core/service/model/user/user_auth_error.dart';
import 'package:login/core/service/model/user/user_request.dart';

import 'model/student.dart';

class FirebaseService{

  static const String FIREBASE_URL = "https://login-36dae-default-rtdb.firebaseio.com/users.json";
  static const String FIREBASE_URL2 = "https://login-36dae-default-rtdb.firebaseio.com/students.json";
  static const String FIREBASE_AUTH_URL = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD1tslg8NWpR6Li_c7rKNy0f0tgyAuuxa0";

  Future postUser(UserRequest request) async{
    var jsonModel = json.encode(request.toJson());
    final response = await http.post(Uri.parse(FIREBASE_AUTH_URL), body: jsonModel);

    switch (response.statusCode) {
      case HttpStatus.ok:
        return true;    
      default:
        var errorJson = json.decode(response.body);
        var error = FirebaseAuthError.fromJson(errorJson);
        return error;
    }
  }

  Future<List<User>> getUsers() async{
    final response = await http.get(Uri.parse(FIREBASE_URL));

    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonModel = json.decode(response.body);
        final userList = jsonModel.map((e) => User.fromJson(e as Map<String, dynamic>)).toList().cast<User>();
        return userList;
        
      default:
      return Future.error(response.statusCode);
    }
  }

  Future<List<Student>> getStudents() async{
    final response = await http.get(Uri.parse(FIREBASE_URL2));


    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonModel = json.decode(response.body) as Map;
        final studentList = <Student>[];
        jsonModel.forEach((key, value) {
          Student student = Student.fromJson(value);
          student.key = key;
          studentList.add(student);
        });
        
        return studentList;
        
      default:
      return Future.error(response.statusCode);
    }
  }

  
}