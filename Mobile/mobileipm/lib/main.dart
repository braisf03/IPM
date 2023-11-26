import 'package:flutter/material.dart';
import 'package:hello_flutter/screenMobile.dart';
import 'package:provider/provider.dart';
import 'package:hello_flutter/screenTablet.dart';

import 'package:hello_flutter/Data/Modelo.dart';

void main() {
  runApp(MyApp());
}

void mainMobile(){
  runApp(MobileBuilder());
}

void mainTablet(){
  runApp(TabletBuilder());
}

class MyApp extends StatelessWidget {

  final double minDimension = 550.0;

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.width >= minDimension && MediaQuery.of(context).size.height >= minDimension) {
      // Si la pantalla es de tablet se pone la interfaz de tablet
      return TabletBuilder();
    } else{
      // Si la pantalla no es de tablet se pone la interfaz de móvil
      return MobileBuilder();
    }
  }
}

class TabletBuilder extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(create: (_) => Modelo(),
        child:  MaterialApp(title: 'Provider Example',
            theme: ThemeData(
                primarySwatch: Colors.deepOrange),
            debugShowCheckedModeBanner: false,
            home: TabletScreen()
        )
    );
  }
}

class MobileBuilder extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(create: (_) => Modelo(),
        child:  MaterialApp(title: 'Provider Example',
            theme: ThemeData(
                primarySwatch: Colors.deepOrange),
            debugShowCheckedModeBanner: false,
            home: const MobileScreen()
        )
    );
  }}