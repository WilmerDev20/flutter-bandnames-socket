import 'package:band_name/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServerScreen extends StatelessWidget {

  final String ruta= 'server';
   
  const ServerScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final socketservice = Provider.of<SocketServices>(context);
      socketservice.initConfig();
    final socket = socketservice.socket;
    

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Server Status'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Center(child: Text('Server status : ${socketservice.serverStatus}'))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          socket.emit('emitir mensaje',{
            'nombre':' Flutter app', 
            'mensaje':'Hola desde flutter' });
        },
        child: const Icon(Icons.message_sharp),
      ),
    );
  }
}