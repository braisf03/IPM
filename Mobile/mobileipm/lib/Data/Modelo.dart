import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'server_stub.dart' as stub;

import 'package:http/http.dart' as http;
import 'dart:async';

import 'ModeloFichero.dart';

class Modelo extends ChangeNotifier {

  final ModeloFichero _fileManager = ModeloFichero();

  int _currentScreen = 0;
  int get currentScreen => _currentScreen;

  String? _error;
  String? get error => _error;

  final TextEditingController _favController = TextEditingController();
  TextEditingController get favController => _favController;

  final TextEditingController _cController = TextEditingController();
  TextEditingController get cController => _cController;

  String _fromCurrency = 'USD';
  String get fromCurrency => _fromCurrency;

  String _toCurrency = 'EUR';
  String get toCurrency => _toCurrency;

  String _result = "";
  String get result => _result;

  List<String> _symbols = [];
  List<String> get symbols => _symbols;

  String _mainCurrency = "USD";
  String get mainCurrency => _mainCurrency;

  List<String> _favourites = [];
  List<String> get favourites => _favourites;

  String _addableCurrency = "EUR";
  String get addableCurrency => _addableCurrency;

  List<String> _values = [];
  List<String> get values => _values;

  List<String> _historicDates = [];
  List<String> get historicDates => _historicDates;

  List<double> _historicRates = [];
  List<double> get historicRates => _historicRates;

  String? _chartError;
  String? get chartError => _chartError;

  static bool IMtesting = false;

  final Map<String, String> banderasPorSiglas = {
    'AED': '🇦🇪', 'ARS': '🇦🇷', 'AUD': '🇦🇺', 'AZN': '🇦🇿',
    'BHD': '🇧🇭', 'BND': '🇧🇳', 'BOB': '🇧🇴', 'BRL': '🇧🇷',
    'BSD': '🇧🇸', 'BTC': '₿', 'BWP': '🇧🇼', 'CAD': '🇨🇦',
    'CHF': '🇨🇭', 'CLP': '🇨🇱', 'CNY': '🇨🇳', 'COP': '🇨🇴',
    'CZK': '🇨🇿', 'DKK': '🇩🇰', 'ETH': '♢', 'EUR': '🇪🇺',
    'FJD': '🇫🇯', 'GAU': '🇹🇷', 'GBP': '🇬🇧', 'GEL': '🇬🇪',
    'GHS': '🇬🇭', 'HKD': '🇭🇰', 'HUF': '🇭🇺', 'IDR': '🇮🇩',
    'ILS': '🇮🇱', 'INR': '🇮🇳', 'ISK': '🇮🇸', 'JOD': '🇯🇴',
    'JPY': '🇯🇵', 'KRW': '🇰🇷', 'KWD': '🇰🇼', 'KYD': '🇰🇾',
    'KZT': '🇰🇿', 'MAD': '🇲🇦', 'MDL': '🇲🇩', 'MXN': '🇲🇽',
    'MYR': '🇲🇾', 'NIO': '🇳🇮', 'NOK': '🇳🇴', 'NZD': '🇳🇿',
    'OMR': '🇴🇲', 'PEN': '🇵🇪', 'PHP': '🇵🇭', 'PKR': '🇵🇰',
    'PLN': '🇵🇱', 'PYG': '🇵🇾', 'QAR': '🇶🇦', 'RON': '🇷🇴',
    'RUB': '🇷🇺', 'SAR': '🇸🇦', 'SDR': '💵', 'SEK': '🇸🇪',
    'SGD': '🇸🇬', 'THB': '🇹🇭', 'TND': '🇹🇳', 'TRY': '🇹🇷',
    'TWD': '🇹🇼', 'UAH': '🇺🇦', 'USD': '🇺🇸', 'UYU': '🇺🇾',
    'VEF': '🇻🇪', 'VND': '🇻🇳', 'WTI': '🛢️', 'XAG': '🔘',
    'XAU': '🟡', 'XPD': '🗿', 'XPT': '💎', 'ZAR': '🇿🇦',
    'EGP': '🇪🇬'
  };

  Modelo() {
    fetchSymbols();
    getFavouritesFromFile();
  }


  Future<void> setScreen(int index) async{
    _currentScreen = index;
  }

  Future<void> fetchSymbols() async {
    _error = null;
    try {
      if(!IMtesting){
        final response = await http.get(Uri.parse(
            "https://fcsapi.com/api-v3/forex/list?type=forex&access_key=Tn93pQjpXyTf0QRudHrnn5"));
        List<String> exchangeList = [];
        if (response.statusCode == 200) {
          var cuerpo = jsonDecode(response.body) as Map<String, dynamic>;
          if (cuerpo['msg'] == "Successfully") {
            List<dynamic> data = cuerpo["response"];
            for (var element in data) {
              String currency = element["symbol"].toString().substring(0, 3);
              if (!exchangeList.contains(currency)) {
                exchangeList.add(currency);
              }
            }
            exchangeList.sort();
            _symbols = exchangeList;

            notifyListeners();
          }
          else {
            _error = "Error: No access to the database";
            notifyListeners();
          }
        } else {
          _error = ("Error: No access to the database");
          notifyListeners();
        }
      }else{
        _symbols = stub.getCurrencies();
        notifyListeners();
      }

    }catch(e){

      _error = ("Error: No internet connection");
      notifyListeners();
    }
  }

  Future<void> currencyConverter(double amount) async {
    if(_fromCurrency == _toCurrency){
      _result = amount.toStringAsFixed(2);
    }
    else {
      try{
        final respuesta;
        if(!IMtesting){
          respuesta = await http.get
            (Uri.parse(
              "https://fcsapi.com/api-v3/forex/latest?symbol=" + _fromCurrency +
                  "/" + _toCurrency + "&access_key=Tn93pQjpXyTf0QRudHrnn5"));
        }else{
          var uri = Uri(
              scheme: 'https',
              host: 'fcsapi.com',
              path: "/api-v3/forex/latest",
              queryParameters: {
                'symbol': _fromCurrency + "/" + _toCurrency,
                'access_key': 'MY_API_KEY',
              });
          respuesta = await stub.get(uri);
        }

        if (respuesta.statusCode == 200) {
          var cuerpo = jsonDecode(respuesta.body) as Map<String, dynamic>;
          if (cuerpo['msg'] ==
              "Access block for you, You have reached maximum 3 limit per minute in free account, Please stop extra hits or upgrade your account. Restriction remove after 1 minute.") {
            _error = ("Error: No access to the database");
          }
          else if (cuerpo['msg'] ==
              "Sorry, Something wrong, or an invalid value. Please try again or check your required parameters.") {
            _result = "Not found $_fromCurrency -";
          }
          else {
            String price;
            price = cuerpo['response'][0]['c'];

            _result = (double.parse(price) * amount).toStringAsFixed(2);
          }
        }
        else {
          _error = "Error: No access to the database";
        }
      }catch(e){
        _error = "Error: No internet connection";
      }
    }
    notifyListeners();
  }

  Future<void> convertCurrencies(double value) async {
    /* Esta hecho no toqueis por favor */
    _error = null;
    String solicitud = "";

    _favourites.forEach((coin){
      if(coin == _favourites.last){
        solicitud = solicitud + _mainCurrency + "/" + coin;
      }else{
        solicitud = solicitud + _mainCurrency + "/" + coin + ",";
      }
    });
    try{
      final respuesta;
      if(!IMtesting){
        respuesta = await http.get
          (Uri.parse("https://fcsapi.com/api-v3/forex/latest?symbol=" + solicitud + "&access_key=Tn93pQjpXyTf0QRudHrnn5"));
      }else{
        var uri = Uri(
            scheme: 'https',
            host: 'fcsapi.com',
            path: "/api-v3/forex/latest",
            queryParameters: {
              'symbol': solicitud,
              'access_key': 'MY_API_KEY',
            });
        respuesta = await stub.get(uri);
      }
    Map<String, String> prices = {};
    if (respuesta.statusCode == 200) {
      var cuerpo = jsonDecode(respuesta.body) as Map<String, dynamic>;
      if(cuerpo['msg'] != "Access block for you, You have reached maximum 3 limit per minute in free account, Please stop extra hits or upgrade your account. Restriction remove after 1 minute."){

        for (int i = 0; i < cuerpo['response'].length; i++) {
          double rate = double.parse(cuerpo['response'][i]['c']);
          String currency = cuerpo['response'][i]['s'].substring(4, 7);
          prices[currency] = (rate * value).toStringAsFixed(2);
        }

        for (int i = 0; i < _favourites.length; i++) {
          if(_favourites[i] == _mainCurrency){
            _values[i] = value.toStringAsFixed(2);
          }else{
            _values[i] = prices[_favourites[i]] ?? "Not found";
          }
        }
      }else{
        _error = ("Error: No access to the database");
      }
    }else{
      _error = ("Error: No access to the database");
    }
    }catch(e){
      _error = ("Error: No internet connection");
    }
    notifyListeners();
  }


  Future<void> getHistoric() async {
    const int firstHourChecked = 204;
    try{
      final respuesta;
      if(!IMtesting){
        respuesta = await http.get
          (Uri.parse("https://fcsapi.com/api-v3/forex/history?symbol=" + _fromCurrency +"/" + _toCurrency + "&period=1h&access_key=Tn93pQjpXyTf0QRudHrnn5"));
      }else{
        var uri = Uri(
            scheme: 'https',
            host: 'fcsapi.com',
            path: "/api-v3/forex/history?symbol=",
            queryParameters: {
              'symbol': _fromCurrency + "/" + _toCurrency,
              'access_key': 'MY_API_KEY',
            });
        respuesta = await stub.getHistoric(uri);
        print(respuesta);
      }

      if(respuesta.statusCode == 200) {
        var cuerpo = jsonDecode(respuesta.body);

        if(cuerpo['msg'] == "Successfully"){

          final responseList = cuerpo['response'] as Map<String, dynamic>;

          List<String> dates = [];
          List<double> rates = [];
          int hoursChecked = 0;
          for (var element in responseList.values) {
            if(hoursChecked >= firstHourChecked) {
              double rate = double.parse(element['c']);
              String date = element['tm'];
              dates.add(date);
              rates.add(rate);
            }
            hoursChecked++;
          }
          _chartError = null;
          _historicDates = dates;
          _historicRates = rates;
        }else if(cuerpo['msg'] == "No data or an invalid value has been specified. Data not found."){
          _chartError = "Error: Conversion doesn't exist in the database";
        }else{
          print("Mensaje malo");
          _error = ("Error: No access to the database");
        }

      }else{
        print("Status code malo");
        _error = ("Error: No access to the database");
      }
    }catch (e){
      print(e);
      _error = "Error: No internet connection";
    }
    notifyListeners();
  }


  Future<void> addToFavourites() async {
    if (!_favourites.contains(_addableCurrency)) {
      favourites.add(_addableCurrency);
      values.add('');
      if(!IMtesting) {
        _fileManager.addCurrencyToFile(_addableCurrency);
      }
    }
    notifyListeners();
  }

  Future<void> removeFromFavourites(String coin) async {
    _values.removeAt(favourites.indexOf(coin));
    _favourites.remove(coin);
    if(!IMtesting) {
      _fileManager.removeCurrencyFromFile(coin);
    }
    notifyListeners();
  }

  Future<void> resetFavouriteList() async{
    _values = [];
    _favourites = [];
    if(!IMtesting){
      _fileManager.resetFile();
    }
    notifyListeners();
  }

  Future<void> getFavouritesFromFile() async{
    List<String> favs;
    if(!IMtesting) {
      favs = await _fileManager.getAllFromFile();
    }
    else{
      favs = ['EUR', 'USD'];
    }
    for(String currency in favs) {
        _favourites.add(currency);
        _values.add("");
      }
      notifyListeners();

  }

  Future<void> changeMainCurrency(String newCurrency) async{
    _mainCurrency = newCurrency;
    notifyListeners();
  }

  Future<void> changeAddableCurrency(String newCurrency) async{
    _addableCurrency = newCurrency;
    notifyListeners();
  }


  void updateFromCurrency(String value) {
    if(value == _toCurrency){
      _toCurrency = _fromCurrency;
    }
    _fromCurrency = value;
    notifyListeners();
  }

  void updateToCurrency(String value) {
    if(value == _fromCurrency){
      _fromCurrency = _toCurrency;
    }
    _toCurrency = value;
    notifyListeners();
  }

  void exchangeCurrencies(){
    String aux = _fromCurrency;
    _fromCurrency = _toCurrency;
    _toCurrency = aux;
    notifyListeners();
  }




/*
  COMENTARIOS:
    - getSymbols -> Devuelve todas las monedas por id, nombre, symbolo y decimales. Nos interesa el 3er parámetro
    - currencyConverter -> Devuelve muchos parámetros sobre el ratio de las monedas (P.E: EUR/US),
    nos interesa el 5º el ratio de conversión
    - getFavourites ->
    - getHistoric -> Devuelve las últimos 300 valores (actualizados cada frame) de la moneda (Open, high, low, close y fecha).
    En concreto, nos interesa el close.
   */
}

