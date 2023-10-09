import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
import requests

# Modelo
class Modelo:
    def __init__(self):
        self.resultado = None

    def obtener_cocktail(self, name):
        #url = f"https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i={id}"
        url = f"https://www.thecocktaildb.com/api/json/v1/1/search.php?s={name}"
        response = requests.get(url)
        data = response.json()
        self.resultado = data["drinks"][0] if "drinks" in data else None

# Presentador
class Presentador:
    def __init__(self, modelo, vista):
        self.modelo = modelo
        self.vista = vista

    def obtener_cocktail(self, id):
        self.modelo.obtener_cocktail(id)
        self.vista.mostrar_cocktail(self.modelo.resultado)

# Vista
class Vista(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="Cocktail Info")

        self.label_id = Gtk.Label(label="ID del cocktail:")
        self.entry_id = Gtk.Entry()
        self.resultado_label = Gtk.Label(label="Información del cocktail:")
        self.resultado_valor = Gtk.Label(label="")
        self.obtener_button = Gtk.Button(label="Obtener Cocktail")

        self.obtener_button.connect("clicked", self.obtener_cocktail)

        grid = Gtk.Grid()
        grid.attach(self.label_id, 0, 0, 1, 1)
        grid.attach(self.entry_id, 1, 0, 1, 1)
        grid.attach(self.resultado_label, 0, 1, 2, 1)
        grid.attach(self.resultado_valor, 0, 2, 2, 1)
        grid.attach(self.obtener_button, 0, 3, 2, 1)

        self.add(grid)

    def mostrar_cocktail(self, cocktail):
        if cocktail:
            self.resultado_valor.set_label(f"Nombre: {cocktail['strDrink']}\nInstrucciones: {cocktail['strInstructions']}")
        else:
            self.resultado_valor.set_label("Cocktail no encontrado")

    def obtener_cocktail(self, widget):
        cocktail_id = self.entry_id.get_text()
        presentador.obtener_cocktail(cocktail_id)

# Crear instancias
modelo = Modelo()
vista = Vista()
presentador = Presentador(modelo, vista)

vista.connect("destroy", Gtk.main_quit)
vista.show_all()

Gtk.main()