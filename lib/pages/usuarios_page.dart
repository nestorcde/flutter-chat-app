import 'package:chat_app/models/usuario_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuarioService = new UsuarioService();

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;
    return  Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre,style: TextStyle(color: Colors.black87),),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            //desconectar del socket
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
            socketService.disconnect();
          }, 
          color: Colors.black87,
          icon: Icon(Icons.exit_to_app)
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus==ServerStatus.Online
              ? Icon(Icons.check_circle, color: Colors.blue[400],)
              : Icon(Icons.offline_bolt, color: Colors.red,),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400],),
          waterDropColor: Colors.blueAccent,
        ),
        onRefresh: _cargarUsuarios,
        child: _listViewUsuarios(),
      )
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_,i) => _usuariosTile(usuarios[i]), 
      separatorBuilder: (_,i) => Divider(), 
      itemCount: usuarios.length
    );
  }

  ListTile _usuariosTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0,2).toUpperCase()),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: (){
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara = usuario;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }

   _cargarUsuarios() async {
    this.usuarios = await usuarioService.getUsuarios();
    setState(() {});
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}