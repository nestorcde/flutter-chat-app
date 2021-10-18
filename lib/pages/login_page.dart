// ignore_for_file: prefer_const_constructors

import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/custom_logo.dart';
import 'package:chat_app/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height *0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomLogo(imagePath: 'assets/tag-logo.png', textLabel: 'Messenger',),
                _Form(),
                Labels(texto1: '¿No tienes cuenta?',texto2: 'Crea una ahora!',ruta: 'register',),
                Container(
                  child: Text('Terminos y Condiciones', style: TextStyle(fontWeight: FontWeight.w200),),
                  margin: EdgeInsets.only(bottom: 30),
                )
              ],
            ),
          ),
        ),
      )
   );
  }
}



class _Form extends StatefulWidget {
  const _Form({ Key? key }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'email',
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'password',
            textController: passwordController,
            keyboardType: TextInputType.text,
            isPassword: true,
          ),
          BotonAzul(
            texto: 'Login',
            autenticando: authService.autenticando,
            funcion: () async {

              if(verificado()){

               FocusScope.of(context).unfocus();
               final loginOk = await authService.login(emailController.text.trim(), passwordController.text.trim());

               if(loginOk){
                 socketService.connect();
                 Navigator.pushReplacementNamed(context, 'usuarios');
               }else{
                 mostrarAlerta(context, 'Login incorrecto', 'Revise sus credenciales');
               }

              }else{
                mostrarAlerta(context, 'Login incorrecto', 'Revise sus credenciales');
              }

            } 
          )
        ],
      ),
    );
  }

  bool  verificado() {
    if(emailController.text == '' || passwordController.text == '') return false;
      
      return true;
  }
  void _imprimir() {

      
      
            
  }
}

