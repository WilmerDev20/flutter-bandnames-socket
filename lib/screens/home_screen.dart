import 'dart:io';
import 'package:band_name/models/band.dart';
import 'package:band_name/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


// ignore: use_key_in_widget_constructors
class HomeScreen extends StatefulWidget {
  final String ruta = 'home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands=[];
  @override
  void initState() {

    final socketServices=Provider.of<SocketServices>(context,listen:  false);

    socketServices.socket.on('bandas activas', (payload) {
      _handlActiveBands(payload);

    setState(() { });

    });

    super.initState();
  }

  _handlActiveBands(dynamic payload){
     bands = (payload as List)
        .map((banda) => Band.fromJson(banda)).toList();

  }



  @override
  void dispose() {
      final socketServices=Provider.of<SocketServices>(context,listen:  false);
    socketServices.socket.off('bandas activas');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketServices=Provider.of<SocketServices>(context);

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Bands name',style: TextStyle(color: Colors.black87),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: 
            (socketServices.serverStatus== ServerStatus.online)
             ? const Icon(Icons.lightbulb, color: Colors.blue,)
            : const Icon(Icons.lightbulb, color: Colors.red,),

            ),
        ],
      ),
      body: Column(
        children: [

          _showGraph(),

          Expanded(// toma el espacio disponible segun el espacio tenga la columna o el widget padre
            child: ListView.builder(
          
                   itemCount: bands.length,
                  itemBuilder: (BuildContext context, int index)=>_bandTile(bands[index]) ,
          
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() =>  addNewBand(),

        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {

    final socket = Provider.of<SocketServices>(context,listen: false);

    return Dismissible(

      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
       //delete-band
      

      socket.socket.emit('delete-band',{'id':band.id});
    
      setState(() {  bands.removeAt(bands.indexOf(band)); });

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
            socket.socket.emit('vote-band', {'id':band.id } );
              setState(() {  });
              
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

  void addNameToList(String name){
    if(name.length >1){
    final socketServices= Provider.of<SocketServices>(context,listen: false).socket;

    socketServices.emit('add-band',{'name':name});
    
     setState(() { });
    }
    Navigator.pop(context);// se cierra el dialogo

  
  }

  Widget _showGraph(){

    Map<String, double> dataMap = {

  };

  bands.forEach((band) { 
    dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
  });


    return Container(

      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: PieChart(
        dataMap: dataMap,
        chartType: ChartType.ring,
        
        ),

    );
  }





}





class _showGraph extends StatelessWidget {


  Map<String, double> dataMap = {
   
  };
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap));
  }
}