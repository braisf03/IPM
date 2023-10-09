import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

#Class window prueba

class MyWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="Cocktail Desktop")                                                              #Nombre de la pestaña


        def createLabel():
            label = "Click Here"
            return label

        self.button = Gtk.Button(label = createLabel())                                                         #Se crea el botón con su texto
        handler_id = self.button.connect("clicked", self.on_button_clicked)                                    #Defino el ID del proceso de click del botón
        self.add(self.button)                                                                                  #Se añade a la interfaz

        print(f"ID del proceso, {handler_id}")

    def on_button_clicked(self, widget):                                                                     #Se determina el uso del botón
        print("Hello World")


win = MyWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main() #Simplemente ejecutamos el programa