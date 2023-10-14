# Diseño software


## Diagrama estático
### Diagrama de clases

```mermaid
classDiagram
    Main <--> View
    View <--> Presenter
    Presenter <--> Model

    class Main
    Main: -view -> View
    Main: +__main__()

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
    Model : +getFromAPI()
    Model : +searchById()


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

