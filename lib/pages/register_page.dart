// ignore_for_file: prefer_const_constructors

import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/custom_logo.dart';
import 'package:chat_app/widgets/label.dart';

class RegisterPage extends StatelessWidget {


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
                CustomLogo(imagePath: 'assets/tag-logo.png', textLabel: 'Registro',),
                _Form(),
                Labels(texto1: '¿Ya tienes cuenta?',texto2: 'Inicia sesión!',ruta: 'login',),
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
  
  final nombreController = new TextEditingController();
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
            icon: Icons.account_circle_outlined,
            placeholder: 'nombre',
            textController: nombreController,
          ),
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
            isPassword: true,
          ),
          BotonAzul(
            autenticando: authService.autenticando,
            texto: 'Registrarse',
            funcion: () async {
              FocusScope.of(context).unfocus();
               final registroOk = await authService.signIn(nombreController.text.trim(), emailController.text.trim(), passwordController.text.trim());

               if(registroOk == true){
                 Navigator.pushReplacementNamed(context, 'usuarios');
                 socketService.connect();
               }else{
                 mostrarAlerta(context, 'Registro incorrecto', registroOk);
               }
            }
          )
        ],
      ),
    );
  }

  void _imprimir() {
      print('Email: ${emailController.text}');
      print('Pass: ${passwordController.text}');
            
  }
}

