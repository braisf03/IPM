import gi
from Presenter import Presenter
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
from gi.repository import GdkPixbuf
import requests
from io import BytesIO
from gi.repository import Gio


def iniciar(self):
    self.builder = Gtk.Builder()
    self.builder.add_from_file("CocktailDesktop.glade")  # Buildeo el glade
    self.adminSignals(self)
    self.window = self.builder.get_object("App")
    self.stack = self.builder.get_object("pageStack")
    self.home = self.builder.get_object("home")
    self.boxSearchCocktail = self.builder.get_object("boxSearchCocktail")
    self.boxSearchIngridient = self.builder.get_object("boxSearchIngridient")
    self.boxDetailCocktail = self.builder.get_object("boxDetailCocktail")
    self.boxDetailIngridient = self.builder.get_object("boxDetailIngridient")
    self.boxIngridientDetails = self.builder.get_object("boxIngridientDetails")
    self.cocktailS1 = self.builder.get_object("IngridientS1")
    self.cocktailS2 = self.builder.get_object("IngridientS2")
    self.cocktailS3 = self.builder.get_object("IngridientS3")
    self.cocktailS4 = self.builder.get_object("IngridientS4")
    self.cocktailS1 = self.builder.get_object("cocktailS1")
    self.cocktailS2 = self.builder.get_object("cocktailS2")
    self.cocktailS3 = self.builder.get_object("cocktailS3")
    self.cocktailS4 = self.builder.get_object("cocktailS4")
    self.checkAlcoholicCocktail = self.builder.get_object("checkAlcoholicCocktail")
    self.checkNonAlcoholicCocktail = self.builder.get_object("checkNonAlcoholicCocktail")
    self.window.connect("destroy", Gtk.main_quit)
    self.checkAlcoholicCocktail = self.builder.get_object("checkAlcoholicCocktail")
    self.checkNonAlcoholicCocktail = self.builder.get_object("checkNonAlcoholicCocktail")

    #---------------------------------------------------------------------------------------------------------
    #Botones, cajas y funciones de errores
    #---------------------------------------------------------------------------------------------------------

    self.buttonErrorWebIngDReload = self.builder.get_object("buttonErrorWebIngDReload")
    self.buttonErrorWebCDReload = self.builder.get_object("buttonErrorWebCDReload")
    self.buttonWebErrorIngReload = self.builder.get_object("buttonWebErrorIngReload")
    self.buttonWebErrorCReload = self.builder.get_object("buttonWebErrorCReload")
    self.buttonErrorSIngReload = self.builder.get_object("buttonErrorSIngReload")
    self.buttonErrorSCReload = self.builder.get_object("buttonErrorSCReload")
    self.boxErrorSearchCocktail = self.builder.get_object("boxErrorSearchCocktail")
    self.boxErrorSSearchIngridient = self.builder.get_object("boxErrorSSearchIngridient")
    self.boxWebErrorCSearchCocktail = self.builder.get_object("boxWebErrorCSearchCocktail")
    self.boxWebErrorIngSearchIngridient = self.builder.get_object("boxWebErrorIngSearchIngridient")
    self.boxErrorWebCDDetailCocktail= self.builder.get_object("boxErrorWebCDDetailCocktail")
    self.boxErrorWebCDDetailIngridient = self.builder.get_object("boxErrorWebCDDetailIngridient")


class MiAplicacion:
    def __init__(self):
        iniciar(self)
    
    #Metodo para iniciar la aplicación
    def run(self):
        self.window.show_all()
        Gtk.main()
    
    #Metodo para administrar las señales
    def adminSignals(self, handler):
        self.builder.connect_signals(handler)

    #---------------------------------------------------------------------------------------------------------               
    #---------------------------------------------------------------------------------------------------------
    #Funciones home
    #---------------------------------------------------------------------------------------------------------
    #---------------------------------------------------------------------------------------------------------
    def buttonGoCocktails(self, widget):
        Presenter.deactivateFilter()
        self.checkAlcoholicCocktail.set_active(False)
        self.checkNonAlcoholicCocktail.set_active(False)
        self.generateRandomCocktails()
        
    def buttonGoIngridients(self, widget):
        self.stack.set_visible_child_name("boxSearchIngridient")
        Presenter.deactivateFilter()
        self.checkAlcoholicCocktail.set_active(False)
        self.checkNonAlcoholicCocktail.set_active(False)      
        self.generateRandomIngridients()

    def buttonGoHome(self, widget):
        self.stack.set_visible_child_name("home")
        Presenter.deactivateFilter()
        self.checkAlcoholicCocktail.set_active(False)
        self.checkNonAlcoholicCocktail.set_active(False)


    #---------------------------------------------------------------------------------------------------------               
    #---------------------------------------------------------------------------------------------------------
    #Funciones cocteles
    #---------------------------------------------------------------------------------------------------------
    #---------------------------------------------------------------------------------------------------------

    def buttonClickedCocktail(self, widget, nombre):
        Presenter.deactivateFilter()
        self.checkAlcoholicCocktail.set_active(False)
        self.checkNonAlcoholicCocktail.set_active(False)
        data = Presenter.cocktailDetalleName(nombre)
        if data[0] == None:
            self.stack.set_visible_child_name("boxErrorWebCDDetailCocktail")
            self.buttonErrorWebCDReload.connect('clicked', self.buttonErrorWebCDReload, nombre)
        self.stack.set_visible_child_name("boxDetailCocktail")
        self.labelCocktailName = self.builder.get_object("labelCocktailName")
        self.labelCocktailName.set_text(nombre)
        #Formateo de imagen del cocktail
        self.imageCocktailLook = self.builder.get_object("imageCocktailLook")
        imagen_pocha = mostrar_imagen_desde_url(data[1], 300, 350)
        pixbuf = imagen_pocha.get_pixbuf()
        self.imageCocktailLook.set_from_pixbuf(pixbuf)
        #Formateo de texto de instrucciones
        self.labelCocktailInstruction = self.builder.get_object("labelCocktailInstruction")
        self.labelCocktailInstruction.set_line_wrap(True)
        self.labelCocktailInstruction.set_text(data[2])
        #Formateo de texto de ingredientes
        self.labelCocktailIngridients = self.builder.get_object("labelCocktailIngridients")
        ingredientes = data[3]
        Measures = data [4]
        self.labelCocktailIngridients.set_text("")
        for i in range (0, len(ingredientes) -1):
            self.labelCocktailIngridients.set_text(self.labelCocktailIngridients.get_text() + f" - {ingredientes[i]} (Measure: {Measures[i]})\n")

    def buttonRandomCocktail(self, widget):
        data = Presenter.randomCocktail()
        self.buttonClickedCocktail(self, data[0])


    def generateRandomCocktails(self):
        #Adquiero todos los botones
        self.getbuttonsSCocktail(self)
        (nombres,fotos) = Presenter.random4Cocktail()
        if nombres[0] == None:
            if nombres[1] == "1":
               self.stack.set_visible_child_name("boxErrorSearchCocktail")
               self.buttonErrorSCReload.connect('clicked', self.generateRandomCocktails)
            if nombres[2] == "2":
                self.stack.set_visible_child_name("boxWebErrorCSearchCocktail")
                self.buttonWebErrorCReload.connect('clicked', self.generateRandomCocktails)

        self.stack.set_visible_child_name("boxSearchCocktail")
        #Poner aqui set de las fotos
        image_widget1 = mostrar_imagen_desde_url(fotos[0], 100, 100)
        self.buttonSCocktail1.set_image(image_widget1)
        image_widget2 = mostrar_imagen_desde_url(fotos[1], 100, 100)
        self.buttonSCocktail2.set_image(image_widget2)
        image_widget3 = mostrar_imagen_desde_url(fotos[2], 100, 100)
        self.buttonSCocktail3.set_image(image_widget3)

        image_widget3 = mostrar_imagen_desde_url(fotos[3], 100, 100)
        self.buttonSCocktail4.set_image(image_widget3)

        #Poner aqui set del texto
        self.labelSCocktailName1.set_text(nombres[0])
        self.labelSCocktailName2.set_text(nombres[1])
        self.labelSCocktailName3.set_text(nombres[2])
        self.labelSCocktailName4.set_text(nombres[3])
        
        #Definir funciones sobre botones
        self.buttonSCocktail1.connect('clicked', self.buttonClickedCocktail, nombres[0])
        self.buttonSCocktail2.connect('clicked', self.buttonClickedCocktail, nombres[1])
        self.buttonSCocktail3.connect('clicked', self.buttonClickedCocktail, nombres[2])
        self.buttonSCocktail4.connect('clicked', self.buttonClickedCocktail, nombres[3])
        self.checkAlcoholicCocktail.connect("toggled", self.on_checkbox_toggled, self.checkNonAlcoholicCocktail)
        self.checkNonAlcoholicCocktail.connect("toggled", self.on_checkbox2_toggled, self.checkAlcoholicCocktail)

        #Funciones auxiliares
    def getbuttonsSCocktail(self,widget):
        self.buttonSCocktail1 = self.builder.get_object("buttonSCocktail1")
        self.buttonSCocktail2 = self.builder.get_object("buttonSCocktail2")
        self.buttonSCocktail3 = self.builder.get_object("buttonSCocktail3")
        self.buttonSCocktail4 = self.builder.get_object("buttonSCocktail4")
        self.buttonSCocktail1.show()
        self.buttonSCocktail2.show()
        self.buttonSCocktail3.show()
        self.buttonSCocktail4.show()
        self.labelSCocktailName1 = self.builder.get_object("labelSCocktailName1")
        self.labelSCocktailName2 = self.builder.get_object("labelSCocktailName2")
        self.labelSCocktailName3 = self.builder.get_object("labelSCocktailName3")
        self.labelSCocktailName4 = self.builder.get_object("labelSCocktailName4")
        self.labelSCocktailName1.show()
        self.labelSCocktailName2.show()
        self.labelSCocktailName3 .show()
        self.labelSCocktailName4.show()
        self.searchCocktail = self.builder.get_object("searchCocktail")
        self.searchCocktail.set_text("")
        self.searchCocktailByIngridient = self.builder.get_object("searchCocktailByIngridient")
        self.searchCocktailByIngridient.set_text("")
    
    def BusquedaCocktail(self, entry):
        nombre = entry.get_text()
        self.getbuttonsSCocktail(self)
        (nombres,fotos) = Presenter.cocktailNoDetalleName(nombre)
        #Poner aqui set de las fotos
        image_widgets = []
        buttons = [self.buttonSCocktail1, self.buttonSCocktail2, self.buttonSCocktail3, self.buttonSCocktail4]
        labels = [self.labelSCocktailName1, self.labelSCocktailName2, self.labelSCocktailName3, self.labelSCocktailName4]
        for i in range (0, 4):
            if i > len(nombres)-1:
                buttons[i].hide()
                labels[i].hide()
            else:
                buttons[i].show()
                labels[i].show()
                image_widgets.append(mostrar_imagen_desde_url(fotos[i], 100, 100)) 
                buttons[i].set_image(image_widgets[i])

                #Poner aqui set del texto
                labels[i].set_text(nombres[i])
                
                #Definir funciones sobre botones
                buttons[i].connect('clicked', self.buttonClickedCocktail, nombres[i])

    #---------------------------------------------------------------------------------------------------------               
    #---------------------------------------------------------------------------------------------------------
    #Funciones filtros
    #---------------------------------------------------------------------------------------------------------
    #---------------------------------------------------------------------------------------------------------
    
    def BusquedaCocktailPorIngrediente(self, entry):
        nombre = entry.get_text()
        self.getbuttonsSCocktail(self)
        (nombres,fotos) = Presenter.cocktailByIngredient(nombre)
        #Poner aqui set de las fotos
        image_widgets = []
        buttons = [self.buttonSCocktail1, self.buttonSCocktail2, self.buttonSCocktail3, self.buttonSCocktail4]
        labels = [self.labelSCocktailName1, self.labelSCocktailName2, self.labelSCocktailName3, self.labelSCocktailName4]
        for i in range (0, 4):
            if i > len(nombres)-1:
                buttons[i].hide()
                labels[i].hide()
            else:
                buttons[i].show()
                labels[i].show()
                image_widgets.append(mostrar_imagen_desde_url(fotos[i], 100, 100)) 
                buttons[i].set_image(image_widgets[i])

                #Poner aqui set del texto
                labels[i].set_text(nombres[i])
                
                #Definir funciones sobre botones
                buttons[i].connect('clicked', self.buttonClickedCocktail, nombres[i])

    def on_checkbox_toggled(self, widget, checkNonAlcoholicCocktail):
        if widget.get_active():
            checkNonAlcoholicCocktail.set_active(False)
            Presenter.setFilter(True)

    def on_checkbox2_toggled(self, widget, checkAlcoholicCocktail):
        if widget.get_active():
            checkAlcoholicCocktail.set_active(False)
            Presenter.setFilter(False)

    #---------------------------------------------------------------------------------------------------------               
    #---------------------------------------------------------------------------------------------------------
    #Funciones ingredientes
    #---------------------------------------------------------------------------------------------------------
    #---------------------------------------------------------------------------------------------------------

    def buttonClickedIngridient(self, widget, nombre):
        data = Presenter.ingredientByName(nombre)
        if data[0] == None:
            self.stack.set_visible_child_name("boxErrorWebCDDetailIngridient")
            self.buttonErrorWebIngDReload.connect('clicked', self.buttonErrorWebIngDReload, nombre)
        self.stack.set_visible_child_name("boxDetailIngridient")
        self.labelIngridientName = self.builder.get_object("labelIngridientName")
        self.labelIngridientName.set_text(nombre)

        #Formateo de imagen del cocktail
        self.imageIngridientLook = self.builder.get_object("imageIngridientLook")
        imagen_pocha = mostrar_imagen_desde_url(data[1], 150, 200)
        pixbuf = imagen_pocha.get_pixbuf()
        self.imageIngridientLook.set_from_pixbuf(pixbuf)
        #Formateo de texto de instrucciones
        self.labelIngredientDescription = self.builder.get_object("labelIngredientDescription")
        self.labelIngredientDescription.set_line_wrap(True)
        self.labelIngredientDescription.set_text(data[2])
        self.labelIngridientAlcohol = self.builder.get_object("labelIngridientAlcohol")
        self.labelIngridientAlcohol.set_text(f"Alcohol: {data[3]}")
        if (data[3] == "Yes") & (data[4] != "None%"):
            self.labelIngridientABV = self.builder.get_object("labelIngridientABV")
            self.labelIngridientABV.show()
            self.labelIngridientABV.set_text(f"How much -> {data[4]}")   
        else:
            self.labelIngridientABV = self.builder.get_object("labelIngridientABV") 
            self.labelIngridientABV.hide()
        
        
        #Botones de ingredientes
        self.buttonCocktail1IngridientDetails = self.builder.get_object("buttonCocktail1IngridientDetails")
        self.buttonCocktail2IngridientDetails = self.builder.get_object("buttonCocktail2IngridientDetails")
        self.buttonCocktail3IngridientDetails = self.builder.get_object("buttonCocktail3IngridientDetails")
        self.buttonCocktail4IngridientDetails = self.builder.get_object("buttonCocktail4IngridientDetails")
        self.labelCocktail1IngridientDetails = self.builder.get_object("labelCocktail1IngridientDetails")
        self.labelCocktail2IngridientDetails = self.builder.get_object("labelCocktail2IngridientDetails")
        self.labelCocktail3IngridientDetails = self.builder.get_object("labelCocktail3IngridientDetails")
        self.labelCocktail4IngridientDetails = self.builder.get_object("labelCocktail4IngridientDetails")
        self.buttonCocktail1IngridientDetails.show()
        self.buttonCocktail2IngridientDetails.show()
        self.buttonCocktail3IngridientDetails.show()
        self.buttonCocktail4IngridientDetails.show()
        self.labelCocktail1IngridientDetails.show()
        self.labelCocktail2IngridientDetails.show()
        self.labelCocktail3IngridientDetails.show()
        self.labelCocktail4IngridientDetails.show()   
        (nombres,fotos) = Presenter.cocktailByIngredient(data[0])
        #Poner aqui set de las fotos
        image_widgets = []
        buttons = [self.buttonCocktail1IngridientDetails, self.buttonCocktail2IngridientDetails, self.buttonCocktail3IngridientDetails, self.buttonCocktail4IngridientDetails]
        labels = [self.labelCocktail1IngridientDetails, self.labelCocktail2IngridientDetails, self.labelCocktail3IngridientDetails, self.labelCocktail4IngridientDetails]
        for i in range (0, 4):
            if i > len(nombres)-1:
                buttons[i].hide()
                labels[i].hide()
            else:
                buttons[i].show()
                labels[i].show()
                image_widgets.append(mostrar_imagen_desde_url(fotos[i], 100, 100)) 
                buttons[i].set_image(image_widgets[i])

                #Poner aqui set del texto
                labels[i].set_text(nombres[i])
                
                #Definir funciones sobre botones
                buttons[i].connect('clicked', self.buttonClickedCocktail, nombres[i])
 

    def BusquedaIngredients(self, entry):
        nombre = entry.get_text()
        self.getbuttonsSIngridients(self)
        if nombre == "":
            self.generateRandomIngridients()
        else:
            (nombres,fotos) = Presenter.ingredientsByName(nombre)
            #Poner aqui set de las fotos
            image_widgets = []
            buttons = [self.buttonSIngridient1, self.buttonSIngridient2, self.buttonSIngridient3, self.buttonSIngridient4]
            labels = [self.labelSIngridientName1, self.labelSIngridientName2, self.labelSIngridientName3, self.labelSIngridientName4]
            for i in range (0, 4):
                if i > len(nombres)-1:
                    buttons[i].hide()
                    labels[i].hide()
                else:
                    buttons[i].show()
                    labels[i].show()
                    image_widgets.append(mostrar_imagen_desde_url(fotos[i], 100, 100)) 
                    buttons[i].set_image(image_widgets[i])

                    #Poner aqui set del texto
                    labels[i].set_text(nombres[i])
                    
                    #Definir funciones sobre botones
                    buttons[i].connect('clicked', self.buttonClickedIngridient, nombres[i])

        #Metodos para la pantalla de ingredientes
    def generateRandomIngridients(self):
        #Adquiero todos los botones
        (nombres,fotos) = Presenter.random4Ingredients()
        if nombres[0] == None:
            if nombres[1] == "1":
               self.stack.set_visible_child_name("boxWebErrorIngSearchIngridient")
               self.buttonWebErrorIngReload.connect('clicked', self.generateRandomIngridients)
            if nombres[2] == "2":
                self.stack.set_visible_child_name("boxErrorWebCDDetailCocktail")
                self.buttonErrorWebCDReload.connect('clicked', self.generateRandomIngridients)
        self.getbuttonsSIngridients(self)
        #Poner aqui set de las fotos
        image_widget1 = mostrar_imagen_desde_url(fotos[0], 100, 100)
        self.buttonSIngridient1.set_image(image_widget1)
        image_widget2 = mostrar_imagen_desde_url(fotos[1], 100, 100)
        self.buttonSIngridient2.set_image(image_widget2)
        image_widget3 = mostrar_imagen_desde_url(fotos[2], 100, 100)
        self.buttonSIngridient3.set_image(image_widget3)

        image_widget3 = mostrar_imagen_desde_url(fotos[3], 100, 100)
        self.buttonSIngridient4.set_image(image_widget3)

        #Poner aqui set del texto
        self.labelSIngridientName1.set_text(nombres[0])
        self.labelSIngridientName2.set_text(nombres[1])
        self.labelSIngridientName3.set_text(nombres[2])
        self.labelSIngridientName4.set_text(nombres[3])
        
        #Definir funciones sobre botones
        self.buttonSIngridient1.connect('clicked', self.buttonClickedIngridient, nombres[0])
        self.buttonSIngridient2.connect('clicked', self.buttonClickedIngridient, nombres[1])
        self.buttonSIngridient3.connect('clicked', self.buttonClickedIngridient, nombres[2])
        self.buttonSIngridient4.connect('clicked', self.buttonClickedIngridient, nombres[3])

        #Funciones auxiliares
    def getbuttonsSIngridients(self,widget):
        self.buttonSIngridient1 = self.builder.get_object("buttonSIngridient1")
        self.buttonSIngridient2 = self.builder.get_object("buttonSIngridient2")
        self.buttonSIngridient3 = self.builder.get_object("buttonSIngridient3")
        self.buttonSIngridient4 = self.builder.get_object("buttonSIngridient4")
        self.labelSIngridientName1 = self.builder.get_object("labelSIngridientName1")
        self.labelSIngridientName2 = self.builder.get_object("labelSIngridientName2")
        self.labelSIngridientName3 = self.builder.get_object("labelSIngridientName3")
        self.labelSIngridientName4 = self.builder.get_object("labelSIngridientName4")
        self.buttonSIngridient1.show()
        self.buttonSIngridient2.show()
        self.buttonSIngridient3.show()
        self.buttonSIngridient4.show()
        self.labelSIngridientName1.show()
        self.labelSIngridientName2.show()
        self.labelSIngridientName3.show()
        self.labelSIngridientName4.show()
        self.searchIngridient = self.builder.get_object("searchIngridient")
        self.searchIngridient.set_text("")




def mostrar_imagen_desde_url(url, ancho, alto):
    # Descargar la imagen desde la URL
    response = requests.get(url)
    if response.status_code != 200:
        print("No se pudo descargar la imagen desde la URL.")
        return

    imagen_bytes = BytesIO(response.content)

    # Crear una ventana
    ventana = Gtk.Window()
    ventana.set_title("Visor de Imágenes")
    ventana.connect("destroy", Gtk.main_quit)

    # Crear un contenedor para la imagen
    contenedor = Gtk.Box()
    contenedor.set_orientation(Gtk.Orientation.VERTICAL)
    ventana.add(contenedor)

    # Crear un ScrolledWindow para la imagen
    scrolled_window = Gtk.ScrolledWindow()
    contenedor.add(scrolled_window)

    # Obtener la longitud de los datos descargados
    imagen_bytes_len = imagen_bytes.getbuffer().nbytes

    # Convertir BytesIO a InputStream
    imagen_input_stream = Gio.MemoryInputStream.new_from_data(imagen_bytes.read(), None)

    # Cargar la imagen desde InputStream
    pixbuf = GdkPixbuf.Pixbuf.new_from_stream(imagen_input_stream, None)
    if ancho and alto:
        pixbuf = pixbuf.scale_simple(ancho, alto, GdkPixbuf.InterpType.BILINEAR)
    # Crear un widget de imagen
    imagen = Gtk.Image.new_from_pixbuf(pixbuf)
    return imagen