import 'package:chat_app/global/environments.dart';
import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/models/usuario_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class ChatService with ChangeNotifier{

  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioId) async{
    final token = await AuthService.getToken();
    final resp = await http.get(Environment().apiUrl('/mensajes/'+usuarioId),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token.toString()
      }
    );

    final mensajesResponse = mensajesResponseFromJson(resp.body);
    return mensajesResponse.mensajes;
  }

}