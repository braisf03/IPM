# Diseño software


## Diagrama estático
### Diagrama de clases

```mermaid
classDiagram
    Main --> View
    Presenter <--> View
    Presenter <--> Model

    class Main{
    +__init__()
}

    class Presenter{
    +parseUrlDetalle(response)
    +parseUrlNoDetalle(response)
    +parseUrlIng(response)
    +parseUrlIngNoDetalle(response)
    +cocktailNoDetalleName(identificador)
    +cocktailDetalleName(identificador)
    +cocktailNoDetalleId(identificador)
    +cocktailDetalleId(identificador)
    +cocktailByIngredient(identificador)
    +ingredientByName(identificador)
    +ingredientsByName(identificador)
    +ingredientById(identificador)
    +randomCocktail()
    +filterByAlcohol(identificador)
    +filterByCategory(identificador)
    +filterByGlass(identificador)
    +random4Cocktail()
    
}
    class View{
    -CocktailDesktop.glade -> glade
    +__init__(self)
    +run(self)
    +adminSignals(self, handler)
    +buttonGoCocktails(self, widget)
    +buttonGoIngredients(self, widget)
    +buttonGoHome(self, widget)
    +buttonGoHome(self, widget)
    +buttonClickedCocktail(self, widget, nombre)
    +buttonRandomCocktail(self, widget)
    +generateRandomCocktails(self)
    +getbuttonsSCocktail(self, widget)
    +BusquedaCocktail(self, entry)
    +buttonClickedIngredient(self, widget, nombre)
    +BusquedaIngredients(self, entry)
    +generateRandomIngridients(self)
    +getbuttonsSIngridients(self, widget)
    +mostrar_imagen_desde_url(url, ancho, alto)
}
    class Model{
     -APIUrl -> string
     +_getFromAPI(url -> string)
     +searchById(id -> int)
     +searchByName(name -> string)
     +categoryFilter(category -> string)
     +alcoholFilter(hasAlcohol -> bool)
     +getRandom()
     +searchIngById(id -> int)
     +searchIngByName(name -> string)
     +searchByIng(ingredient -> string)
    
}
```

## Diagramas dinámicos
### Diagrama de clases
```mermaid
sequenceDiagram
    main->>+View: 1: Gtk.main()
    View->>+Presenter: 2: on_connect_clicked()
    Presenter->>+Model: 3: get_example()
    Model-->>-Presenter: 4: return
    Presenter->>+Model: 5: get_cocktail()
    Model->>+Server: 6: GET\cocktail
    Server-->>-Model: 7: data:json
    Model-->>-Presenter: 8: return
    Presenter->>+View Results: 9: results.show()
    Presenter-->>-View: 10: return
    View-->>-main: 11: return
```    

