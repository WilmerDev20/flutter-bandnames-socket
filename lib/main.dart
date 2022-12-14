import 'package:band_name/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_name/services/services.dart';

void main() => runApp(
  MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SocketServices(),) ],
  child: const MyApp(),
  ),
);





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: HomeScreen().ruta ,
      routes: {
        HomeScreen().ruta:(context) => HomeScreen(),
     const ServerScreen().ruta:(context) =>const ServerScreen(),
      },
      
    );
  }
}