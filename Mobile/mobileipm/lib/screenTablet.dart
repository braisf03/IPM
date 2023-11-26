import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import 'Data/Modelo.dart';

class TabletScreen extends StatelessWidget {

  TabletScreen({super.key});

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

class HistoricChart extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    final currencyProvider = Provider.of<Modelo>(context);

    if(currencyProvider.chartError != null) {
      return Text(
          currencyProvider.chartError!,
          style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
          ),
      );
    }
    if(currencyProvider.historicDates.isEmpty){
        return const Text(
          'No data to show',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      }
    return AspectRatio(
      aspectRatio: 2.0,
      child: LineChart(
        LineChartData(
          backgroundColor: const Color(0xFF212936),
          titlesData: FlTitlesData(
            rightTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 40,
              getTextStyles: (context, value) => const TextStyle(
                  color: Color(0xFF212936),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            topTitles: SideTitles(showTitles: false),
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTextStyles: (context, value) => const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
                getTitles: (value){
                  return value.toStringAsFixed(3);
                }
            ),
            bottomTitles: SideTitles(
              showTitles: true,
                reservedSize: 20,
              getTextStyles: (context, value) => const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              interval: 12,
              getTitles: (value) {
                if(value % 24 == 12) {
                  return currencyProvider.historicDates[value.toInt()]
                      .substring(0, 10);
                }
                else{
                  return "";
                }
              }
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              left: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              right: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              top: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
          minX: 0,
          maxX: currencyProvider.historicDates.length.toDouble() - 1,
          minY: currencyProvider.historicRates.reduce((a, b) => a < b ? a : b),
          maxY: currencyProvider.historicRates.reduce((a, b) => a > b ? a : b),
          lineBarsData: [
            LineChartBarData(
              spots: currencyProvider.historicRates
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                  .toList(),
              isCurved: true,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: false),
              colors: [Colors.blue, Colors.deepOrange],
              isStrokeCapRound: true,
            ),
          ],
        ),
      ),
    );
  }
}

class Landscape extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    final currencyProvider = Provider.of<Modelo>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF212936),
      appBar: AppBar(
        backgroundColor: const Color(0xFF212936),
        title: const Text('Currency Converter'),
      ),

      body: Row(
        children: <Widget>[
          // Parte izquierda con el gráfico
          Expanded(
            flex: 4,

            child: SingleChildScrollView(
              child:

            Column(
              children: [
                const SizedBox(height: 25.0),
                const Text(
                  'Historic rates',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20.0),
                //GRAFICO DEL HISTORIAL DE LA MONEDA
                HistoricChart(),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        currencyProvider.exchangeCurrencies();
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
                  ],
                ),
                const SizedBox(height: 16.0),
                CupertinoButton.filled(
                  child: const Text('Get last 4 day rates'),
                  onPressed: () {
                    currencyProvider.getHistoric();
                  },
                ),
              ],
            ),
          ),
          ),

          // Línea de separación
          Container(
            width: 10,
            color: Colors.grey,
          ),

          // Parte derecha con la lista y el formulario
          Expanded(
            flex: 3, // Flex para ocupar 1/3 del ancho de la pantalla
            child: Scaffold(
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
                    backgroundColor: const Color(0xFF212936),
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
                          currencyProvider.addToFavourites(/*currencyProvider.mainCurrency*/);
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete),
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
            ),
          ),
        ],
      ),
    );
  }
}

class Portrait extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    final currencyProvider = Provider.of<Modelo>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF212936),
      body: Column(
          children: [
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child:

              Column(
                children: [
                  const SizedBox(height: 25.0),
                  const Text(
                    'Historic rates',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  //GRAFICO DEL HISTORIAL DE LA MONEDA
                  HistoricChart(),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          currencyProvider.exchangeCurrencies();
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
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  CupertinoButton.filled(
                    child: const Text('Get last 4 day rates'),
                    onPressed: () {
                      currencyProvider.getHistoric();
                    },
                  ),
                ],
              ),
            ),
            ),

        //Linea divisoria
        Container(
          height: 10,
          color: Colors.grey,
        ),

        // Parte derecha con la lista y el formulario
        Expanded(
          flex: 3, // Flex para ocupar 1/3 del ancho de la pantalla
          child: Scaffold(
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
                  backgroundColor: const Color(0xFF212936),
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
                        currencyProvider.addToFavourites(/*currencyProvider.mainCurrency*/);
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.delete),
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
          ),
        ),
      ],
    ),
    );
  }
}