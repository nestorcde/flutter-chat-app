import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/usuarios_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: ( context, snapshot) { 
          if(snapshot.connectionState == ConnectionState.done){

            return  Center(
              child: Text('Espere...'),
            );
          }else{
            return Container();
          }

         },
        
      ),
   );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen:  false);
    final autenticado = await authService.isLoggedIn();

    if(autenticado){
      //conectar socketserver
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___)=> UsuariosPage()
          )
        );
    }else{
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___)=> LoginPage()
          )
        );
    }
  }
}