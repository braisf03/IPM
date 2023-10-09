# Diseño software


## Diagrama estático
### Diagrama de clases

```mermaid
classDiagram
    Main --> View
    Main --> View Results
    View --> Presenter
    View Results --> Presenter
    Presenter --> Model
    class Main
    Main: -view -> View
    Main: +__main__()

    note for Model "p1-server"

    class View
    View : -Gtk objects
    View : +destroy()
    View : +update_view()
    View : +reset_view()
    View : +connect_buscar_clicked(handler)
    View : +connect_interval_changed(handler)
    View : +connect_ascdes_changed(handler)
    View : +connect_delete_event(handler)
    View : +show_all()
    View : +hide()

    class View Results
    View Results : -Gtk objects
    View Results : -interval.index -> int
    View Results : -is_asc -> bool
    View Results : -example -> string
    View Results : +cocktail list -> cocktail list
    View Results : +destroy()
    View Results : +update_view()
    View Results : +reset_view()
    View Results : +connect_buscar_clicked(handler)
    View Results : +connect_interval_changed(handler)
    View Results : +connect_ascdes_changed(handler)
    View Results : +connect_delete_event(handler)
    View Results : +show_all()
    View Results : +hide()

    class Presenter
    Presenter : -view -> View
    Presenter : -results -> View Results
    Presenter : -model -> Model
    Presenter : -selected_interval -> int
    Presenter : -selected_asc -> bool
    Presenter : +on_interval_changed()
    Presenter : +on_ascdes_changed()
    Presenter : +on_buscar_clicked()
    Presenter : +on_view_delete_event()
    Presenter : +on_volver_clicked()

    class Model
    Model : -server_address -> string
    Model : -server_port -> string
    Model : -lista_cocktail -> string list
    Model : +get_example(index, is_asc)
    Model : +get_cocktail(index, is_asc)


```

## Diagramas dinámicos
### Diagrama de clases
```mermaid
sequenceDiagram
    Gtk.main->>+View: 1: connect_buscar_clicked()
    View->>+Presenter: 2: on_connect_clicked()
    Presenter->>+Model: 3: get_example()
    Model-->>-Presenter: 4: return
    Presenter->>+Model: 5: get_cocktail()
    Model->>+Server: 6: GET\cocktail
    Server-->>-Model: 7: data:json
    Model-->>-Presenter: 8: return
    Presenter->>+View Results: 9: results.show()
    Presenter-->>-View: 10: return
    View-->>-Gtk.main: 11: return
```    

