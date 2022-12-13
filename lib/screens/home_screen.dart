import 'dart:io';
import 'package:band_name/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// ignore: use_key_in_widget_constructors
class HomeScreen extends StatefulWidget {
  final String ruta = 'home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands=[
    Band(id: '1', name: 'Mana', votes: 5),
    Band(id: '2', name: 'Aventura', votes: 0),
    Band(id: '3', name: 'Los Bukis', votes: 10),
    Band(id: '4', name: 'Soda Stereo', votes: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Bands name',style: TextStyle(color: Colors.black87),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(

        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index)=>_bandTile(bands[index]) ,

      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() =>  addNewBand(),

        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print(direction);
        print(band.id);
        //llamar el borrado en el server
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 15),
        color: Colors.red,
        child: const Text('Borrar Banda',style: TextStyle(color: Colors.white,fontSize: 20),),

      ),
      child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.blue[100]
            ,child: 
            Text(band.name.substring(0,2)),
            ),
            title: Text(band.name),
            trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20),),
            onTap: () {
              print(band.name);
            },
            
    
          ),
    );
  }



  addNewBand(){
    final textController = TextEditingController();

    if(Platform.isAndroid){
      return showDialog( // ANDROID
      context: context,
      builder: (context) {
        return  AlertDialog(
          title: const Text('Nueva Banda'),
          content:  TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              elevation: 1,
              textColor: Colors.blue,
              onPressed: ()=> addNameToList(textController.text),
              child: const Text('Agregar'),
              )
          ],
        );
      },
    
      );
    }

    showCupertinoDialog( // IOS
      context: context,
       builder: ((context) {
         return  CupertinoAlertDialog(
          title: const Text('Nueva Banda'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions:  [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Agregar'),
              onPressed: ()=> addNameToList(textController.text),  
              ),

            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Cerrar'),
              onPressed: ()=> Navigator.pop(context),  
              ),
          ],


         );
       })
       
       );



    

  }

  void addNameToList(String nombre){
    if(nombre.length >1){
     bands.add(Band(id: DateTime.now().toString(), name: nombre, votes: 7, ));
     setState(() { });
    }
    Navigator.pop(context);// se cierra el dialogo

  
  }

}