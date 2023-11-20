# Diseño software
## Diagrama estático
### Diagrama de clases

```mermaid
classDiagram
    
    Presenter --> Model
    Presenter *-- View
    View ..> Presenter

    class Presenter{
    +__init__(self, view: MiAplicacion)
    +run(self)
    +parseURL(self, response, give_all_elems -> bool)
    +getInstructionsByLang(self, data)
    +getIngredientList(self, data)
    +getFields(self, fields -> list, data -> dict)
    +getAllFields(self, fields -> list, data -> list)
    +pick4Random(self, names, images)
    +addAlcoholFilter(self, names, images)
    +applyAlcohol(self, names, photos, alcohol)
    +cocktailNoDetalleName(self, name)
    +cocktailDetalleName(self, name)
    +cocktailByIngredient(self, ingName)
    +ingredientByName(self, name)
    +ingredientsByName(self, name)
    +randomCocktail(self)
    +random4Cocktail(self)
    +random4Ingredients(self)
    +on_cocktail_screen_clicked(self)
    +on_ingredient_screen_clicked(self)
    +on_cocktail_clicked(self, name)
    +def on_ingredient_clicked(self, name)
    +on_cocktail_searched(self, name)
    +on_ingredient_searched(self, name)
    +on_cocktail_by_ingredient(self, ingredient)
    +on_random_cocktail_clicked(self)
}
    class View{
    -t -> gettext
    -run_on_main_thread -> Collable
    -CocktailDesktop.glade -> glade
    +__init__(self)
    +run(self)
    +setHandler(self, AppHandler -> presenter)
    +adminSignals(self, handler)
    +buttonGoCocktails(self, widget)
    +buttonGoIngredients(self, widget)
    +buttonGoHome(self, widget)
    +buttonClickedCocktail(self, widget, nombre)
    +buttonRandomCocktail(self, widget)
    +getbuttonsSCocktail(self, widget)
    +getbuttonsSIngridients(self, widget)
    +BusquedaCocktail(self, entry)
    +BusquedaCocktailPorIngrediente(self, entry)
    +on_checkbox_toggled(self, widget, checkNonAlcoholicCocktail)
    +on_checkbox_toggled2(self, widget, checkNonAlcoholicCocktail)
    +isToggledAlcohol(self)
    +def isToggledNonAlcohol(self)
    +buttonClickedIngredient(self, widget, nombre)
    +BusquedaIngredients(self, entry)
    +displayCocktails(self, names, images, changeScreen -> bool)
    +displayIngredients(self, names, images, changeScreen -> bool)
    +displayCocktailInfo(self, info)
    +displayIngredientInfo(self, info, cnames, cimages)
    +cocktailSearchError(self)
    +cocktailDBError(self)
    +ingredientSearchError(self)
    +ingredientDBError(self)
    +cocktailFetchError(self, name)
    +ingredientFetchError(self, name)
    +mostrar_imagen_desde_url(url, ancho, alto)
}
    class Model{
     -APIUrl -> string
     +_getFromAPI(url -> string)
     +searchByName(name -> string)
     +alcoholFilter(hasAlcohol -> bool)
     +getRandom()
     +searchIngById(id -> int)
     +searchIngByName(name -> string)
     +searchByIng(ingredient -> string)
    
}
```

## Diagramas dinámicos
### Diagrama de secuencia
### Cóctel Detalle ✅
```mermaid
sequenceDiagram

#--------------Definiciones de actores--------------#
    participant Presenter as Presenter
    participant MiAplicacion as MiAplicacion
    participant Model as Model
    participant Server as Server

#--------------Inicio de la aplicación--------------#
    Presenter->>MiAplicacion: Llama al constructor de MiAplicacion
    activate Presenter
    MiAplicacion->>MiAplicacion: Muestra la vista
    MiAplicacion->>Presenter: Llama a on_cocktail_clicked()
    Presenter->>Presenter: Llama a cocktailDetalleName() [Llamada concurrente]

#-------------Accesos a la base de datos------------#
    critical Connection to the database stablished
        Presenter ->> Model : Llama a searchByName()
        Model->>Server: Realiza la solicitud a la API
        Server->>Server: Consigue el cóctel
        Server-->>Model: Devuelve el cóctel
        Model-->>Presenter: Devuelve descripción entera del cóctel
        Presenter->>MiAplicacion: Llama a displayCocktailInfo() [Thread principal]
    option Network Timeout
            Presenter ->> Model : Llama a searchByName()
            Model->>Model: Error code
            Model-->>Presenter: Devuelve el codigo de error
            Presenter->>MiAplicacion: Llama a cocktailFetchError() [Thread principal]
    end
   
    MiAplicacion->> MiAplicacion : Se actualiza la vista
    deactivate Presenter

```



### Ingrediente Detalle ✅
```mermaid
sequenceDiagram

#--------------Definiciones de actores--------------#
    participant Presenter as Presenter
    participant MiAplicacion as MiAplicacion
    participant Model as Model
    participant Server as Server

#--------------Inicio de la aplicación--------------#
    Presenter->>MiAplicacion: Llama al constructor de MiAplicacion
    activate Presenter
    MiAplicacion->>MiAplicacion: Muestra la vista
    MiAplicacion->>Presenter: Llama a on_ingredient_clicked()
    Presenter->>Presenter: Llama a ingredientByName() [Llamada concurrente]

#-------------Accesos a la base de datos------------#
    critical Connection to the database stablished
        Presenter ->> Model : Llama a searchByName()
        Model->>Server: Realiza la solicitud a la API
        Server->>Server: Consigue el ingrediente
        Server-->>Model: Devuelve el ingrediente
        Model-->>Presenter: Devuelve descripción entera del ingrediente
        Presenter->>MiAplicacion: Llama a displayIngredientInfo() [Thread principal]
    option Network Timeout
            Presenter ->> Model : Llama a searchByName()
            Model->>Model: Error code
            Model-->>Presenter: Devuelve el codigo de error
            Presenter->>MiAplicacion: Llama a ingredientFetchError() [Thread principal]
    end
   
    MiAplicacion->> MiAplicacion : Se actualiza la vista
    deactivate Presenter

```

### Mostrar pantalla cócteles✅
```mermaid
sequenceDiagram

#--------------Definiciones de actores--------------#
    participant Presenter as Presenter
    participant MiAplicacion as MiAplicacion
    participant Model as Model
    participant Server as Server

#--------------Inicio de la aplicación--------------#
    Presenter->>MiAplicacion: Llama al constructor de MiAplicacion
    activate Presenter
    MiAplicacion->>MiAplicacion: Muestra la vista
    MiAplicacion->>Presenter: Llama a on_cocktail_searched
    Presenter->>Presenter: Llama a cocktailNoDetalleName() [Llamada concurrente]

#-------------Accesos a la base de datos------------#        
    critical Connection to the database stablished
        Presenter->>Model: Llama a searchByName
        Model->>Server: Realiza la solicitud a la API
        Server->>Server: Selecciona los cócteles
        Server-->>Model: Devuelve los 4 cócteles
        Model-->>Presenter: Devuelve nombres e imágenes de los cócteles
        Presenter->>MiAplicacion: Llama a displayCocktails()
    option Network Timeout
            Presenter->>Model: Llama a searchByName   
            Model->>Model: Error code
            Model-->>Presenter: Devuelve el codigo de error
            Presenter->>MiAplicacion: Llama a cocktailSearchError()
    end
   MiAplicacion->>MiAplicacion: Actualiza la vista

    deactivate Presenter
```
### Mostrar pantalla ingredientes
```mermaid
sequenceDiagram

#--------------Definiciones de actores--------------#
    participant Presenter as Presenter
    participant MiAplicacion as MiAplicacion
    participant Model as Model
    participant Server as Server

#--------------Inicio de la aplicación--------------#
    Presenter->>MiAplicacion: Llama al constructor de MiAplicacion
    activate Presenter
    MiAplicacion->>MiAplicacion: Muestra la vista
    MiAplicacion->>Presenter: Llama a random4Ingredients() 
    Presenter->>Model: Llama a show_ingredients() [Llamada concurrente]

#-------------Accesos a la base de datos------------#        
    critical Connection to the database stablished
        Model->>Server: Realiza la solicitud a la API
        Server->>Server: Selecciona los ingredientes
        Server-->>Model: Devuelve los 4 ingredientes
        Model-->>Presenter: Devuelve nombres e imágenes de los ingredientes
        Presenter-->>MiAplicacion: Muestra nombres e imágenes de los ingredientes
    option Network Timeout   
            Model-->>Model: Error code
            Model-->>Presenter: Devuelve el codigo de error
            Presenter-->>MiAplicacion: Muestra el error
    end
   
    deactivate Presenter

```

### Buscar Ingredientes

```mermaid
sequenceDiagram
#--------------Definiciones de actores--------------#
    participant Presenter as Presenter
    participant MiAplicacion as MiAplicacion
    participant Model as Model
    participant Server as Server

#--------------Inicio de la aplicación--------------#
    Presenter->>MiAplicacion: Llama al constructor de MiAplicacion
    activate Presenter
    MiAplicacion->>MiAplicacion: Muestra la vista
    MiAplicacion->>Presenter: Llama a on_ingredient_searched() 
    Presenter->>Model: Llama a BusquedaIngredient() [Llamada concurrente]

#-------------Accesos a la base de datos------------#        
    critical Connection to the database stablished and ingredient found
        Model->>Server: Realiza la solicitud a la API
        Server->>Server: Selecciona los ingredientes
        Server-->>Model: Devuelve 4 ingredientes
        Model-->>Presenter: Devuelve nombres e imágenes de los ingredientes
        Presenter-->>MiAplicacion: Muestra nombres e imágenes de los ingredientes
    option Connection to the database stablished and ingredient not found
        Model->>Server: Realiza la solicitud a la API
        Server->>Server: No se encuentran los ingredientes
        Server-->>Model: Devuelve error not found
        Model-->>Presenter: Devuelve error not found
        Presenter-->>MiAplicacion: Muestra error mot found
    option Network Timeout   
        Model-->>Model: Error code
        Model-->>Presenter: Devuelve el codigo de error
        Presenter-->>MiAplicacion: Muestra el error
    end
```

### Buscar Cócteles
```mermaid
sequenceDiagram
#--------------Definiciones de actores--------------#
    participant Presenter as Presenter
    participant MiAplicacion as MiAplicacion
    participant Model as Model
    participant Server as Server

#--------------Inicio de la aplicación--------------#
    Presenter->>MiAplicacion: Llama al constructor de MiAplicacion
    activate Presenter
    MiAplicacion->>MiAplicacion: Muestra la vista
    MiAplicacion->>Presenter: Llama a on_cocktail_searched() 
    Presenter->>Model: Llama a BusquedaCocktail() [Llamada concurrente]

#-------------Accesos a la base de datos------------#        
    critical Connection to the database stablished and cocktail found
        Model->>Server: Realiza la solicitud a la API
        Server->>Server: Selecciona los cócteles
        Server-->>Model: Devuelve 4 cócteles
        Model-->>Presenter: Devuelve nombres e imágenes de los cócteles
        Presenter-->>MiAplicacion: Muestra nombres e imágenes de los cócteles
    option Connection to the database stablished and cocktail not found
        Model->>Server: Realiza la solicitud a la API
        Server->>Server: No se encuentran los cócteles
        Server-->>Model: Devuelve error not found
        Model-->>Presenter: Devuelve error not found
        Presenter-->>MiAplicacion: Muestra error mot found
    option Network Timeout   
        Model-->>Model: Error code
        Model-->>Presenter: Devuelve el codigo de error
        Presenter-->>MiAplicacion: Muestra el error
    end
```
