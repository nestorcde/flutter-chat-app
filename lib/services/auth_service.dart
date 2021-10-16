


import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/global/environments.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario_model.dart';

class AuthService with ChangeNotifier {
  
  late Usuario usuario;

  bool _autenticando = false;

  bool get autenticando => this._autenticando;

  set autenticando( bool valor ){
    this._autenticando = valor;
    notifyListeners();
  }

  final _storage = new FlutterSecureStorage();

  //Getters del token 
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }


  Future<bool> login( String email, String password) async {

    this.autenticando = true;

    final data = {
      "email": email,
      "password": password
    };
    //print('email: ${email} - pass: ${password}');
    final resp = await http.post(Environment().apiUrl('/login'), 
      body: jsonEncode(data),
      headers: {
        'Content-Type' : 'application/json',
      }
    );
    this.autenticando = false;

    if(resp.statusCode==200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    }else{
      return false;
    }


  }

   Future signIn(String nombre, String email, String password) async {

    this.autenticando = true;

    final data = {
      "nombre": nombre,
      "email": email,
      "password": password
    };
    //print('email: ${email} - pass: ${password}');
    final resp = await http.post(Environment().apiUrl('/login/new'), 
      body: jsonEncode(data),
      headers: {
        'Content-Type' : 'application/json',
      }
    );
    this.autenticando = false;

    if(resp.statusCode==200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      
        await _guardarToken(loginResponse.token);

      return true;
    }else{
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }


  }

  Future _guardarToken(String token) async{
      return await  _storage.write(key: 'token', value: token);
  }

  Future logout() async{
    return await _storage.delete(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: "token") ?? '';
    final resp = await http.get(Environment().apiUrl('/login/renew'), 
      headers: {
        'Content-Type' : 'application/json',
        'x-token': token
      }
    );

    if(resp.statusCode==200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    }else{
      logout();
      return false;
    }
  }
}