import 'package:flutter/material.dart';


class BotonAzul extends StatelessWidget {
  final String texto;
  final Function funcion;
  final bool autenticando;
  const BotonAzul({ 
    Key? key, 
    required this.texto, 
    required this.funcion, 
    required this.autenticando 
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              elevation: 2,
              shape: StadiumBorder()
            ),
            onPressed: this.autenticando ? null : () => this.funcion(), 
            
            child: Container(
              child: Center(
                child: Text(
                    texto,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                  )
              ),
              width: double.infinity,
              height: 55,
            ));
  }
}