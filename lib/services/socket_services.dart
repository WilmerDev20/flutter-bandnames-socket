
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';


enum ServerStatus{
  online,
  offline,
  connecting
}


class SocketServices with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;



  SocketServices(){
    initConfig();
   
    
  }


void initConfig(){

_socket = io('http://192.168.0.100:3001', 
    OptionBuilder()
      .setTransports(['websocket']) 
      .enableAutoConnect()  
      .build()
  );

  _socket.onConnect((_) {
    _serverStatus = ServerStatus.online;
    notifyListeners();
    print('connect');
  });

  _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
    notifyListeners();
    print('disconnect');
  } );
  
}






}