```mermaid
sequenceDiagram

    #Todos los actores de 
    participant Main as Main
    participant Presenter as Presenter
    participant Model as Model
    participant MiAplicacion as MiAplicacion
    participant Server as Server

    Main->>Presenter: Llama al constructor de Presenter
    activate Main
    
    Presenter->>MiAplicacion: Llama al constructor de MiAplicacion

    activate MiAplicacion

    MiAplicacion->>MiAplicacion: Muestra la vista

    loop Crea un thread que muestra 4 cocktails aletorios
        MiAplicacion->>Presenter: Llama a on_cocktail_screen_clicked
        activate Presenter
        Presenter->>Model: Llama a random4Cocktail
        Model->>Server: Realiza múltiples solicitudes a la API
        par if server.response <> null:
        Server->>Server: Selecciona 4 cócteles aleatorios
        Model-->>Presenter: Devuelve nombres e imágenes de cócteles
        Presenter-->>MiAplicacion: Muestra nombres e imágenes de cócteles
        and else 
        Presenter-->>MiAplicacion: Muestra nombres e imágenes de cócteles
        end
    end
    deactivate Presenter
    
    
        MiAplicacion->>Presenter: Llama a on_ingredient_screen_clicked
        activate Presenter
        Presenter->>Model: Llama a random4Ingredients
        Model->>Model: Realiza múltiples solicitudes a la API
        Model->>Model: Selecciona 4 ingredientes aleatorios
        Model-->>Presenter: Devuelve nombres e imágenes de ingredientes
        Presenter-->>MiAplicacion: Muestra nombres e imágenes de ingredientes
    
    deactivate Presenter
    
    
        MiAplicacion->>Presenter: Llama a on_cocktail_clicked
        activate Presenter
        Presenter->>Model: Llama a cocktailDetalleName
        Model->>Model: Realiza una solicitud a la API
        Model-->>Presenter: Devuelve detalles del cóctel
        Presenter-->>MiAplicacion: Muestra detalles del cóctel
    
    deactivate Presenter

    
        MiAplicacion->>Presenter: Llama a on_ingredient_clicked
        activate Presenter
        Presenter->>Model: Llama a ingredientByName
        Model->>Model: Realiza una solicitud a la API
        Model-->>Presenter: Devuelve detalles del ingrediente
        Presenter-->>MiAplicacion: Muestra detalles del ingrediente
    
    deactivate Presenter

    MiAplicacion->>MiAplicacion: Espera mas eventos de usuario
    MiAplicacion-->>Main: Cierra el programa
    deactivate MiAplicacion
    deactivate Main

```    
