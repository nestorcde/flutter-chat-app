

import 'package:chat_app/global/environments.dart';
import 'package:chat_app/models/usuarios_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/models/usuario_model.dart';

class UsuarioService {
  

  Future<List<Usuario>> getUsuarios() async {
    try {
      final token = await AuthService.getToken();
      final resp = await http.get(Environment().apiUrl('/usuarios'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        }
      );

      final usuariosResponse = usuarioResponseFromJson(resp.body);

      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}