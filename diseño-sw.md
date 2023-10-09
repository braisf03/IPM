# Diseño software


## Diagrama estático
### Diagrama de clases

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
