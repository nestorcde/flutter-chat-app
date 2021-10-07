import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String texto;
  final String uid;
  final AnimationController animationController;
  const ChatMessage({ 
    Key? key, 
    required this.texto, 
    required this.uid, 
    required this.animationController 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController, 
          curve: Curves.easeOut
        ),
        child: Container(
          child: this.uid == '123'
            ? _miMessage()
            : notMyMessage(),
        ),
      ),
    );
  }

  Widget _miMessage() {
    return Align(
      child: Container(
        child: Text(texto, style: TextStyle(color: Colors.white),),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(
          bottom: 5,
          left: 50,
          right: 5
        ),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(20)
        ),
      ),
      alignment: Alignment.centerRight,

    );
  }

  Widget notMyMessage() {
    return Align(
      child: Container(
        child: Text(texto, style: TextStyle(color: Colors.white),),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(
          bottom: 5,
          left: 5,
          right: 50
        ),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20)
        ),
      ),
      alignment: Alignment.centerLeft,

    );
  }
}