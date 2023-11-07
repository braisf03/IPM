# Diseño software
## Diagrama estático

```mermaid
classDiagram

App --> Home
Home -- Error
Home -- CambioMultiple
Error -- CambioMultiple
Error -- CambioSimple

CambioMultiple -- Model
CambioSimple -- Model
Home -- CambioSimple

class App {
+build(): widget
}

class Home {
+build(): widget
}

class Error {
+build(): widget
}

class CambioSimple {
-exchanges: List Map
+build(): widget
+convert(): void
}

class CambioMultiple {
-currency: List
+build(): widget
+convert(): void
+add(currency : string): void
+remove(currency : string): void
}

class Model {
-String url
-String key
+getExchanges(): String List
+getCurrency(): String json
}

```

## Diagramas dinámicos
### Diagrama de secuencia

### Realizar un cambio de divisa
```mermaid
sequenceDiagram

    participant App as App
    participant Home as Home
    participant CambioSimple as CambioSimple
    participant Model as Model

    activate App
    
    App ->>+ Home: build()
    Home ->>+ CambioSimple: build()
    CambioSimple ->>+ Model: getExchange()
    Model -->>- CambioSimple: return json
    CambioSimple -->>- Home: Muestra por pantalla el cambio hecho


```


### Añadir moneda
```mermaid
sequenceDiagram

    participant App as App
    participant Home as Home
    participant Provider as Provider
    participant SelectedCurrencies as SelectedCurrencies


    activate App

    App ->>+ Home: buttonPressed()
    Home ->> Provider: addCurrency()
    Provider ->>SelectedCurrencies: addCurrency()
    SelectedCurrencies ->>Provider: notify()
    Provider ->> Home: setState()
    Home->>Home: build()
    Home ->> Provider: getCurrencies()
    Provider ->> SelectedCurrencies: getCurrencies()
    SelectedCurrencies -->> Provider: return currencies
    Provider -->> Home: return currencies
    Home ->>App: Muestra por pantalla la página actualizada

```
