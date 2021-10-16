import 'package:chat_app/models/usuario_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuarios = [
    Usuario(uid: '1', email: 'test1@gmail.com', nombre: 'test1', online: true),
    Usuario(uid: '2', email: 'test2@gmail.com', nombre: 'test2', online: false),
    Usuario(uid: '3', email: 'test3@gmail.com', nombre: 'test3', online: true),
    Usuario(uid: '4', email: 'test4@gmail.com', nombre: 'test4', online: false),
    Usuario(uid: '5', email: 'test5@gmail.com', nombre: 'test5', online: true),
  ];

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
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
          }, 
          color: Colors.black87,
          icon: Icon(Icons.exit_to_app)
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            //child: Icon(Icons.check_circle, color: Colors.blue[400],),
            child: Icon(Icons.offline_bolt, color: Colors.red,),
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
      );
  }

   _cargarUsuarios() async {
     await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}