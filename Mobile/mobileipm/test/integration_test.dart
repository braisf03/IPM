import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:hello_flutter/main.dart' as app;
import 'package:hello_flutter/Data/Modelo.dart';


void main() {

  setUp(() {
    Modelo.IMtesting = true;
  });

  Size mobileSize = const Size(896, 414);
  Size tabletSize = const Size(1024, 768);

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Select USD and JPY, convert and check result', (tester) async {
    // Build our app and trig
    await tester.binding.setSurfaceSize((mobileSize));

    app.mainMobile();
    await tester.pumpAndSettle();


    // Verificamos que la aplicacion se inicia como es debido.
    final finderToCurrency = find.text('EUR');
    final finderFromCurrency = find.text('USD');

    expect(finderFromCurrency, findsOneWidget);
    expect(finderToCurrency, findsOneWidget);


    // Verificamos que los dropDownButton funcionan
    await tester.tap(finderToCurrency);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final currencyListFinder = find.byType(Scrollable).last;
    expect(currencyListFinder, findsOneWidget);
    final dropdownItemFinder = find.text('JPY');

    await tester.scrollUntilVisible(dropdownItemFinder, 500.0, scrollable: currencyListFinder);

    expect(dropdownItemFinder, findsOneWidget);

    await tester.tap(dropdownItemFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final finderToCurrencyAfter = find.text('JPY');
    expect(finderToCurrencyAfter, findsOneWidget);

    // Verificamos que el widget de texto de entrada funciona
    final textPlacer = find.byType(TextField);
    /*await tester.tap(textPlacer);
    await tester.pumpAndSettle(const Duration(seconds: 3));*/
    await tester.enterText(textPlacer, '25');
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify that exchange works
    final convertButtonFinder = find.text('Convert');
    await tester.tap(convertButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('0 JPY'), findsNothing);
    expect(find.text('3747.90 JPY'), findsOneWidget); //Poner valor supuesto de salida A

    // Verify that exchange currencies works
    final currencyChangerFinder = find.byIcon(Icons.swap_horiz);
    expect(currencyChangerFinder, findsOneWidget);
    await tester.tap(currencyChangerFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    //Verify again if exchange works with changed currencies
    await tester.tap(convertButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('3747.90 JPY'), findsNothing); //Poner valor supuesto de salida A
    expect(find.text('16.68 USD'), findsOneWidget); //Poner valor supuesto de salida B
  });

  testWidgets('Select USD and BOB, convert and check result. It should not work', (tester) async {
    // Build our app
    await tester.binding.setSurfaceSize((mobileSize));

    app.mainMobile();
    await tester.pumpAndSettle();


    // Verificamos que la aplicacion se inicia como es debido.
    final finderToCurrency = find.text('EUR');
    final finderFromCurrency = find.text('USD');

    expect(finderFromCurrency, findsOneWidget);
    expect(finderToCurrency, findsOneWidget);

    // Verificamos que los dropDownButton funcionan
    await tester.tap(finderToCurrency);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    final currencyListFinder = find.byType(Scrollable).last;
    expect(currencyListFinder, findsOneWidget);
    final dropdownItemFinder = find.text('BOB');

    await tester.scrollUntilVisible(dropdownItemFinder, 500.0, scrollable: currencyListFinder);

    expect(dropdownItemFinder, findsOneWidget);
    await tester.tap(dropdownItemFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final finderToCurrencyAfter = find.text('BOB');
    expect(finderToCurrencyAfter, findsOneWidget);

    // Verificamos que el widget de texto de entrada funciona
    final textPlacer = find.byType(TextField);
    /*await tester.tap(textPlacer);
    await tester.pumpAndSettle(const Duration(seconds: 3));*/
    await tester.enterText(textPlacer, '25');
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify that exchange works
    final convertButtonFinder = find.text('Convert');
    await tester.tap(convertButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('0 BOB'), findsNothing);
    expect(find.text('Not found USD - BOB'), findsOneWidget);
  });

  testWidgets('Go to favourites, check add, delete, convert multiple en movil', (WidgetTester tester) async{

    await tester.binding.setSurfaceSize((mobileSize));

    app.mainMobile();
    await tester.pumpAndSettle();

    //Voy a la pestaña de favoritos
    final pestanaFavs = find.text('Cambio Múltiple');
    expect(pestanaFavs, findsOneWidget);
    await tester.tap(pestanaFavs);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    //Miro si se ha iniciado bien la pestaña
    final finderToCurrency = find.text('EUR');
    final finderFromCurrency = find.text('USD');

    expect(finderFromCurrency, findsWidgets);
    expect(finderToCurrency, findsWidgets);
    
    //Pruebo a añadir una moneda
    await tester.tap(finderToCurrency.at(0));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final currencyListFinder = find.byType(Scrollable).last;
    expect(currencyListFinder, findsOneWidget);
    final dropdownItemFinder = find.text('JPY');

    await tester.scrollUntilVisible(dropdownItemFinder, 500.0, scrollable: currencyListFinder);

    expect(dropdownItemFinder, findsOneWidget);
    await tester.tap(dropdownItemFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final finderToCurrencyAfter = find.text('JPY');
    expect(finderToCurrencyAfter, findsOneWidget);
    final currencyAdd = find.byIcon(Icons.add);
    expect(currencyAdd, findsOneWidget);
    await tester.tap(currencyAdd);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    //Pruebo a añadir una moneda que no va a ir
    await tester.tap(finderToCurrencyAfter);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final currencyListFinder2 = find.byType(Scrollable).last;
    expect(currencyListFinder2, findsOneWidget);
    final dropdownItemFinder2 = find.text('BOB');

    await tester.scrollUntilVisible(dropdownItemFinder2, 500.0, scrollable: currencyListFinder2);

    expect(dropdownItemFinder2, findsOneWidget);
    await tester.tap(dropdownItemFinder2);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final finderToCurrencyAfterNotWorking = find.text('BOB');
    expect(finderToCurrencyAfterNotWorking, findsOneWidget);
    await tester.tap(currencyAdd);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    //Elimino el dolar de favoritos
    final deleteIcon = find.byIcon(Icons.delete);
    expect(deleteIcon, findsWidgets);
    await tester.tap(deleteIcon.at(2));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verificamos que el widget de texto de entrada funciona
    final textPlacer = find.byType(TextField);
    await tester.enterText(textPlacer, '25');
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify that exchange works
    final convertButtonFinder = find.text('Convert');
    await tester.tap(convertButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('🇯🇵JPY ----->>'), findsNothing);
    expect(find.text('🇯🇵JPY ----->> 3747.90'), findsOneWidget); //Poner valor supuesto de salida A
    expect(find.text('🇺🇸USD ----->>'), findsNothing);
    expect(find.text('🇺🇸USD ----->> 25.00'), findsNothing);
    expect(find.text('🇪🇺EUR ----->>'), findsNothing);
    expect(find.text('🇪🇺EUR ----->> 23.63'), findsOneWidget);
    expect(find.text('🇧🇴BOB ----->>'), findsNothing);
    expect(find.text('🇧🇴BOB ----->> Not found'), findsOneWidget);
  });


  testWidgets('Go to favourites, check add, delete, convert multiple en table', (WidgetTester tester) async{

    await tester.binding.setSurfaceSize((tabletSize));

    app.mainTablet();
    await tester.pumpAndSettle();

    //Miro si se ha iniciado bien la pestaña
    final finderToCurrency = find.text('EUR');
    final finderFromCurrency = find.text('USD');

    expect(finderFromCurrency, findsWidgets);
    expect(finderToCurrency, findsWidgets);

    //Pruebo a añadir una moneda
    await tester.tap(finderToCurrency.at(1));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    final currencyListFinder = find.byType(Scrollable).last;
    expect(currencyListFinder, findsOneWidget);
    final dropdownItemFinder = find.text('JPY');

    await tester.scrollUntilVisible(dropdownItemFinder, 500.0, scrollable: currencyListFinder);

    expect(dropdownItemFinder, findsOneWidget);
    await tester.tap(dropdownItemFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final finderToCurrencyAfter = find.text('JPY');
    expect(finderToCurrencyAfter, findsOneWidget);
    final currencyAdd = find.byIcon(Icons.add);
    expect(currencyAdd, findsOneWidget);
    await tester.tap(currencyAdd);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    //Pruebo a añadir una moneda que no va a ir
    await tester.tap(finderToCurrencyAfter);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final currencyListFinder2 = find.byType(Scrollable).last;
    expect(currencyListFinder2, findsOneWidget);
    final dropdownItemFinderNotWorking = find.text('BOB');

    await tester.scrollUntilVisible(dropdownItemFinderNotWorking, 500.0, scrollable: currencyListFinder2);

    expect(dropdownItemFinderNotWorking, findsOneWidget);
    await tester.tap(dropdownItemFinderNotWorking);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final finderToCurrencyAfterNotWorking = find.text('BOB');
    expect(finderToCurrencyAfterNotWorking, findsOneWidget);
    await tester.tap(currencyAdd);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    //Elimino el dolar de favoritos
    final deleteIcon = find.byIcon(Icons.delete);
    expect(deleteIcon, findsWidgets);
    await tester.tap(deleteIcon.at(2));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verificamos que el widget de texto de entrada funciona
    final textPlacer = find.byType(TextField);
    await tester.enterText(textPlacer, '25');
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify that exchange works
    final convertButtonFinder = find.text('Convert');
    await tester.tap(convertButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('🇯🇵JPY ----->>'), findsNothing);
    expect(find.text('🇯🇵JPY ----->> 3747.90'), findsOneWidget); //Poner valor supuesto de salida A
    expect(find.text('🇺🇸USD ----->>'), findsNothing);
    expect(find.text('🇺🇸USD ----->> 25.00'), findsNothing);
    expect(find.text('🇪🇺EUR ----->>'), findsNothing);
    expect(find.text('🇪🇺EUR ----->> 23.63'), findsOneWidget);
    expect(find.text('🇧🇴BOB ----->>'), findsNothing);
    expect(find.text('🇧🇴BOB ----->> Not found'), findsOneWidget);
  });

  testWidgets('Test chart', (WidgetTester tester) async{
    await tester.binding.setSurfaceSize((tabletSize));

    app.mainTablet();
    await tester.pumpAndSettle();

    expect(find.text('No data to show'), findsOneWidget);

    final historicButtonFinder = find.text('Get last 4 day rates');
    expect(historicButtonFinder, findsOneWidget);
    await tester.tap(historicButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(LineChart), findsOneWidget);

    final finderFromCurrency = find.text('USD');
    await tester.tap(finderFromCurrency.at(0));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final currencyListFinder = find.byType(Scrollable).last;
    expect(currencyListFinder, findsOneWidget);
    final dropdownItemFinder = find.text('BOB');

    await tester.scrollUntilVisible(dropdownItemFinder, 500.0, scrollable: currencyListFinder);

    expect(dropdownItemFinder, findsOneWidget);
    await tester.tap(dropdownItemFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('BOB'), findsOneWidget);

    await tester.tap(historicButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('Error: Conversion doesn\'t exist in the database'), findsOneWidget);
  });

  testWidgets('Test internet connection', (WidgetTester tester) async{
    // Build our app
    await tester.binding.setSurfaceSize((mobileSize));

    app.mainMobile();
    await tester.pumpAndSettle();

    // Verificamos que la aplicacion se inicia como es debido.
    final finderToCurrency = find.text('EUR');
    final finderFromCurrency = find.text('USD');

    expect(finderFromCurrency, findsOneWidget);
    expect(finderToCurrency, findsOneWidget);


    // Verificamos que los dropDownButton funcionan
    await tester.tap(finderToCurrency);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final currencyListFinder = find.byType(Scrollable).last;
    expect(currencyListFinder, findsOneWidget);
    final dropdownItemFinder = find.text('KZT');

    await tester.scrollUntilVisible(dropdownItemFinder, 500.0, scrollable: currencyListFinder);

    expect(dropdownItemFinder, findsOneWidget);

    await tester.tap(dropdownItemFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));


    expect(find.text('KZT'), findsOneWidget);

    // Verificamos que el widget de texto de entrada funciona
    final textPlacer = find.byType(TextField);
    await tester.enterText(textPlacer, '25');
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify that exchange works
    final convertButtonFinder = find.text('Convert');
    await tester.tap(convertButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('KZT'), findsNothing);
    expect(find.text('Error'), findsOneWidget);
  });

  tearDown(() {
    Modelo.IMtesting = false;
  });
}