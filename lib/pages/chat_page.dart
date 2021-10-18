import 'dart:io';

import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    this.chatService    = Provider.of<ChatService>(context, listen: false);
    this.socketService  = Provider.of<SocketService>(context, listen: false);
    this.authService    = Provider.of<AuthService>(context,listen: false);

    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial( this.chatService.usuarioPara.uid);
  }

    void _cargarHistorial(String usuarioId)async{
      List<Mensaje> chat = await this.chatService.getChat(usuarioId);
      final history = chat.map((m) => new ChatMessage(
        texto: m.mensaje, 
        uid: m.de, 
        animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward()
        ));

      setState(() {
        _messages.insertAll(0, history);
      });
    }

    void _escucharMensaje(dynamic payload){
      ChatMessage message = new ChatMessage(
        texto: payload['mensaje'], 
        uid: payload['de'], 
        animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300))
      );

      setState(() {
        this._messages.insert(0, message);        
      });

      message.animationController.forward();
    }

  @override
  Widget build(BuildContext context) {

    final usuario = chatService.usuarioPara;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text("${usuario.nombre.substring(0,2).toUpperCase()}",style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3,),
            Text(usuario.nombre,style: TextStyle(color: Colors.black54, fontSize: 12,fontWeight: FontWeight.bold),)
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
    _focusNode.requestFocus();
    _textController.clear();

    final newMessage = new ChatMessage(
      texto: texto, 
      uid: this.authService.usuario.uid,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0,newMessage);
    newMessage.animationController.forward();

    setState(() {_estaEscribiendo = false;});

    this.socketService.emit('mensaje-personal',{
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });

  }

  @override
  void dispose() {
    // TODO: Off del socket
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}