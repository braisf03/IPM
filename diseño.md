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
    MiAplicacion->>Presenter: Llama a on_cocktail_screen_clicked
    Presenter->>Model: Llama a cocktailDetalleName [Llamada concurrente]

#-------------Accesos a la base de datos------------#        
    critical Connection to the database stablished and cocktail found
        Model->>Server: Realiza la solicitud a la API
        Server->>Server: Selecciona el cóctel
        Server-->>Model: Devuelve el cóctel
        Model-->>Presenter: Devuelve nombres e imágenes de cócteles
        Presenter-->>MiAplicacion: Muestra nombres e imágenes de cócteles
    option Connection to the database stablished and cocktail Not Found   
            Model-->>Server: Realiza la solicitud a la API
            Server->>Server: No se encuentra el cóctel
            Server-->>Model: Error code
            Model-->>Presenter: Devuelve el codigo de error
            Presenter-->>MiAplicacion: Muestra el error
    option Network Timeout
            Model-->>Model: Error code
            Model-->>Presenter: Devuelve el codigo de error
            Presenter-->>MiAplicacion: Muestra el error
    end
   
    deactivate Presenter

```         
