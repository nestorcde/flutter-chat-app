import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  List<ChatMessage> _messages = [
  ];

  bool _estaEscribiendo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text("TE",style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3,),
            Text("Test1",style: TextStyle(color: Colors.black54, fontSize: 12,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i)=>_messages[i],
                itemCount: _messages.length,
                reverse: true,
              ),
            ),
            Divider(height: 1,),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
   );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto){

                },
                decoration: InputDecoration.collapsed(
                  hintText: "Enviar mensaje"
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS ?
              CupertinoButton(
                child: Text('Enviar'), 
                onPressed: (){}
              ):
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.send )
                )
              )
              ),
            
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto){
    if(texto.length==0) return;
    print(texto);
    _focusNode.requestFocus();
    _textController.clear();

    final newMessage = new ChatMessage(
      texto: texto, 
      uid: '1oiui23',
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0,newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });
  }

  @override
  void dispose() {
    // TODO: Off del socket
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }
}