// UNCOMMENT THIS LINE WHEN USING THE STUB IN A FLUTTER PROJECT
import 'package:flutter/services.dart' show rootBundle;

import 'dart:convert';
import 'dart:math';

// Available currencies:
// EUR
// USD
// JPY
// DKK
// GBP
// SEK
// CHF
// NOK
// RUB
// TRY
// AUD
// BRL
// CAD
// CNY
// INR
// MXN
// ZAR

class StubResponse {
  final bool ok;
  final int statusCode;
  final String body;
  StubResponse(this.ok, this.statusCode, this.body);
}



Future<StubResponse> get(Uri uri) async {
  print("-- Using stub server ---");
  
  // UNCOMMENT THIS LINE WHEN USING THE STUB IN A FLUTTER PROJECT
  var stringData = await rootBundle.loadString('assets/exchangeRates.json');

  // COMMENT THESE TWO LINES WHEN USING THE STUB
  // var file = File("assets/exchangeRates.json"); // COMMENT IN FLUTTER PROJECT
  // var stringData = await file.readAsString();   // COMENNT IN FLUTTER PROJECT
  
  
  var staticData = jsonDecode(stringData);
 

  var response = [];
  bool error = false;
  var symbolAsString = uri.queryParameters['symbol'];
  if (symbolAsString != null) {
    var symbolList = symbolAsString.split(",");
    for (var symbol in symbolList) {
      if(symbol == 'USD/KZT'){
        error = true;
      }
      var currencies = symbol.split("/");
      var exchangeRates = staticData[currencies[0]];
      if (exchangeRates != null) {
        var data = exchangeRates["response"]
            .firstWhere((exchangeRate) => exchangeRate["s"] == symbol, orElse: () => {});
        if (data.isNotEmpty) {
          print(data);
          response.add(data);
        }
      }
    }
  }
  var body = {};
  if(error){
    body = {
      "status": false,
      "code": 213,
      "msg": "Access block for you, You have reached maximum 3 limit per minute in free account, Please stop extra hits or upgrade your account. Restriction remove after 1 minute.",
      "response": response,
      "info": staticData["EUR"]["info"]
    };
  }
  else {
    if (response.isNotEmpty) {
      body = {
        "status": true,
        "code": 200,
        "msg": "Successfuly",
        "response": response,
        "info": staticData["EUR"]["info"]
      };
    } else {
      body = {
        "status": false,
        "code": 113,
        "msg":
        "Sorry, Something wrong, or an invalid value. Please try again or check your required parameters.",
        "info": {"credit_count": 0}
      };
    }
  }
  var rng = Random();
  return Future.delayed(Duration(seconds: rng.nextInt(5))).then((value) => StubResponse(true, 200, jsonEncode(body)));
}

List<String> getCurrencies(){
  List <String> currencies = ['EUR', 'USD', 'JPY', 'KZT', 'DKK', 'GBP', 'SEK', 'CHF', 'NOK', 'RUB', 'TRY', 'AUD', 'BRL', 'CAD', 'CNY', 'INR', 'MXN', 'ZAR', 'BOB'];
  return currencies;
}

Future<StubResponse> getHistoric(Uri uri) async {
   print("-- Using stub server ---");

  // UNCOMMENT THIS LINE WHEN USING THE STUB IN A FLUTTER PROJECT
  var stringData = await rootBundle.loadString('assets/historicRates.json');

  // COMMENT THESE TWO LINES WHEN USING THE STUB
  // var file = File("assets/exchangeRates.json"); // COMMENT IN FLUTTER PROJECT
  // var stringData = await file.readAsString();   // COMENNT IN FLUTTER PROJECT


  var staticData = jsonDecode(stringData);


  var response = {};
  var symbol = uri.queryParameters['symbol'];
  if(symbol == 'USD/EUR'){
    response = staticData['response'];
    print(response);
  }
  var body = {};
  if (response.isNotEmpty) {
    body = {
      "status": true,
      "code": 200,
      "msg": "Successfully",
      "response": response,
      "info": staticData["info"]
    };
  } else {
    body = {
      "status": false,
      "code": 113,
      "msg":
          "No data or an invalid value has been specified. Data not found.",
      "info": {"credit_count": 0}
    };
  }
  var rng = Random();
  return Future.delayed(Duration(seconds: rng.nextInt(5))).then((value) => StubResponse(true, 200, jsonEncode(body)));
}