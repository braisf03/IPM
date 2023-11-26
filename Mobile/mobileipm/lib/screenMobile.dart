import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import 'Data/Modelo.dart';


class MobileScreen extends StatelessWidget {
  const MobileScreen({Key? key});

  @override
  Widget build(BuildContext context) {

    final currencyProvider = Provider.of<Modelo>(context);

    if(currencyProvider.error != null){
      return AlertDialog(
        title: const Text("Error"),
        content: Text(currencyProvider.error!),
        actions: <Widget>[
          ElevatedButton(
            child: const Text("Cerrar"),
            onPressed: () {
              Navigator.of(context).pop();
              Restart.restartApp();
            },
          ),
        ],
      );
    }

    if(currencyProvider.symbols.isEmpty){
      return const Text(
        'Fetching symbols...',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }

    if (MediaQuery.of(context).orientation == Orientation.portrait){
      // is portrait
      return Portrait();
    }else{
      // is landscape
      return Landscape();
    }

  }
}

class Landscape extends StatelessWidget {

  Widget build(BuildContext context){
    final currencyProvider = Provider.of<Modelo>(context);

    return DefaultTabController(
      initialIndex: currencyProvider.currentScreen,
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF5c5250),
        appBar: AppBar(
          title: const Text('Currency Converter'),
          backgroundColor: const Color(0xFF212936),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.currency_exchange,
                  color: Colors.lightGreen,
                ),
                text: 'Cambio Simple',
              ),
              Tab(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                text: 'Cambio Múltiple',
              ),
            ],
          ),
        ),
        body:  TabBarView(
          children: <Widget>[
            Center(
              child: LandscapeCS(),
            ),
            Center(
              child: FavoriteCurrencies(),
            ),
          ],
        ),
      ),
    );
  }
}

class LandscapeCS extends StatelessWidget {


  Widget build(BuildContext context){

    final currencyProvider = Provider.of<Modelo>(context);

    currencyProvider.setScreen(0);
    return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 40),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: TextField(
                  controller: currencyProvider.cController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Input value to convert',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                        color: Colors.indigo,
                      )
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
            const SizedBox(width: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Result:',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  Text(
                    '${currencyProvider.result} ${currencyProvider.toCurrency}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, color: Colors.indigo),
                  ),
                ],
              ),
            )
          ],
        ),
        const  SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(currencyProvider.banderasPorSiglas[currencyProvider.fromCurrency]!),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: currencyProvider.fromCurrency,
                          items: currencyProvider.symbols.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            currencyProvider.updateFromCurrency(value ?? 'USD');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  FloatingActionButton(
                    onPressed: () {
                      final from = currencyProvider.fromCurrency;
                      final to = currencyProvider.toCurrency;
                      currencyProvider.updateFromCurrency(to);
                      currencyProvider.updateToCurrency(from);
                    },
                    elevation: 0.0,
                    backgroundColor: Colors.indigoAccent,
                    child: const Icon(Icons.swap_horiz),
                  ),
                  const SizedBox(width: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(currencyProvider.banderasPorSiglas[currencyProvider.toCurrency]!),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: currencyProvider.toCurrency,
                          items: currencyProvider.symbols.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            currencyProvider.updateToCurrency(value ?? 'USD');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: CupertinoButton.filled(
                    padding: const EdgeInsets.all(15.0),
                    child: const Text('Convert'),
                    onPressed: () {
                      final amount = double.tryParse(currencyProvider.cController.text) ?? 0.0;
                      currencyProvider.currencyConverter(amount);
                    },
                  ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }
}

class Portrait extends StatelessWidget {

  Widget build(BuildContext context){
    final currencyProvider = Provider.of<Modelo>(context);
    return DefaultTabController(
      initialIndex: currencyProvider.currentScreen,
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF5c5250),
        appBar: AppBar(
          title: const Text('Currency Converter'),
          backgroundColor: const Color(0xFF212936),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.currency_exchange,
                  color: Colors.lightGreen,
                ),
                text: 'Cambio Simple',
              ),
              Tab(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                text: 'Cambio Múltiple',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: CurrencyConverter(),
            ),
            Center(
              child: FavoriteCurrencies(),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyConverter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<Modelo>(context);
    currencyProvider.setScreen(0);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                color: Colors.white,
                child: Center(
                  child: TextField(
                    controller: currencyProvider.cController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Input value to convert',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                        color: Colors.indigo,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Text(currencyProvider.banderasPorSiglas[currencyProvider.fromCurrency]!),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: currencyProvider.fromCurrency,
                        items: currencyProvider.symbols.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          currencyProvider.updateFromCurrency(value ?? 'USD');
                        },
                      ),
                    ],
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    final from = currencyProvider.fromCurrency;
                    final to = currencyProvider.toCurrency;
                    currencyProvider.updateFromCurrency(to);
                    currencyProvider.updateToCurrency(from);
                  },
                  elevation: 0.0,
                  backgroundColor: Colors.indigoAccent,
                  child: const Icon(Icons.swap_horiz),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Text(currencyProvider.banderasPorSiglas[currencyProvider.toCurrency]!),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: currencyProvider.toCurrency,
                        items: currencyProvider.symbols.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          currencyProvider.updateToCurrency(value ?? 'USD');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CupertinoButton.filled(
            child: const Text('Convert'),
            onPressed: () {
              final amount = double.tryParse(currencyProvider.cController.text) ?? 0.0;
              currencyProvider.currencyConverter(amount);
            },
          ),
          const SizedBox(height: 40),
          Container(
            width: 300,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Result:',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
                SizedBox.fromSize(size: const Size(0, 20)),
                Text(
                  '${currencyProvider.result} ${currencyProvider.toCurrency}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30, color: Colors.indigo),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteCurrencies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<Modelo>(context);
    currencyProvider.setScreen(1);


    return Scaffold(
      backgroundColor: const Color(0xFF5c5250),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: currencyProvider.favController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Input value',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                            color: Colors.indigo,
                          )
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Text(currencyProvider.banderasPorSiglas[currencyProvider.mainCurrency]!),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: currencyProvider.mainCurrency,
                        items: currencyProvider.symbols.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          currencyProvider.changeMainCurrency(value ?? 'USD');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(15.0),
                  padding: const EdgeInsets.all(15.0),
                  onPressed: () {
                    final amount = double.tryParse(currencyProvider.favController.text) ?? 0.0;
                    currencyProvider.convertCurrencies(amount);
                  },
                  child: const Text('Convert'),
                ),
              ],
            ),
          ),
          AppBar(
            title: const Text('Divisas asignadas'),
            backgroundColor: Color(0xFF212936),
            actions: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(currencyProvider.banderasPorSiglas[currencyProvider.addableCurrency]!),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: currencyProvider.addableCurrency,
                      items: currencyProvider.symbols.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        currencyProvider.changeAddableCurrency(value ?? 'USD');
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  currencyProvider.addToFavourites();
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  currencyProvider.resetFavouriteList();
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: currencyProvider.favourites.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blueGrey, width: 3),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    title: Text(currencyProvider.banderasPorSiglas[currencyProvider.favourites[index]]! +
                        currencyProvider.favourites[index] +
                        ' ----->> ' +
                        currencyProvider.values[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        currencyProvider.removeFromFavourites(currencyProvider.favourites[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}