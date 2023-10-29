import json
import random
import threading


from Model import Model
from View import MiAplicacion, run_on_main_thread

import gettext

t = gettext.gettext

class Presenter:


    def __init__(self, view: MiAplicacion):
        self.view = view
        self.activeThread = None


    def run(self):
        self.view.setHandler(self)
        self.view.run()
    #Variables que representan los filtros seleccionados
    #Cada filtro tiene un campo que indica si está activo y otro que indica su valor  
  

    


    #A partir de una URL, hace una petición a la API, y dependiendo de give_all_elems, devuelve los datos de un elemento o de todos
    def parseURL(self, response, give_all_elems = False):
        if(response == ""):
            return None
        json_data = json.loads(response)
         #La línea de abajo devuelve los cócteles o ingredientes, ya que son el único valor del diccionario inicial
        elements = next(iter(json_data.values()))
        if elements == None:
            return None
        if(give_all_elems):
            return elements
        else:
            return elements[0]

        
    def getInstructionsByLang(self, data) -> str:
        instructions = data[t("strInstructions")]
        if instructions == None:
            return data["strInstructions"]
        else:
            return instructions
        
    def getIngredientList(self, data):
        ingList, ingQuantities = [], []
        for i in range(1, 15):     
            if data[f'strIngredient{i}'] is not None:
                ingList.append(data[f'strIngredient{i}'])
                ingQuantities.append(data[f'strMeasure{i}'])
            else:
                return ingList, ingQuantities
    #Devuelve una lista que representa los campos del diccionario indexados por las claves "Fields".
    #Si uno de los "fields" es ingredients, añade una lista con todos los ingredientes y otra con sus cantidades
    def getFields(self, fields: list, data: dict):
        if data == None:
            return None
        results = []
        for field in fields:
            if field == "instructions":
                results.append(self.getInstructionsByLang(data))
            elif field == "ingredients":
                ingList, ingQuantities = self.getIngredientList(data)
                results.append(ingList)
                results.append(ingQuantities)
            elif field == "strABV":
                results.append(f"{data[field]}%")
            elif field == "ingredientThumb":
                results.append(f"https://www.thecocktaildb.com/images/ingredients/{data['strIngredient']}-Small.png")
            elif (field == "strDescription") & (data[field] == None):
                results.append(t("No description"))
            else:
                results.append(data[field])
        return results

    
    #Para cada uno de los campos en "fields", devuelve una lista con su valor en cada uno de los elementos de "data"
    def getAllFields(self, fields: list, data: list):
        if data == None:
            return None
        results = []
        for i in range(0, len(fields)):
            results.append([])
            for element in data:
                results[i].append(element[fields[i]])
        return results


    #Función auxiliar que selecciona 4 elementos aleatorios en caso de que existan más de 4
    def pick4Random(self, names, images):
        if(len(names) <= 4):
            return (names, images)
        else:
            res_names = []
            res_images = []
            randNums = random.sample(range(1, len(names)), 4)
            for i in randNums:
                res_names.append(names[i])
                res_images.append(images[i])
        return res_names, res_images
            
    
    def addAlcoholFilter(self, names, images):
        if self.view.isToggledAlcohol():
            request = Model.alcoholFilter(hasAlcohol=True)
        elif self.view.isToggledNonAlcohol():
            request = Model.alcoholFilter(hasAlcohol=False)
        else:
            return names, images
        if request == "Internet error":
            return "Internet error", []
        data_json = request.text
        data = self.parseURL(data_json, True)
        a_names = self.getAllFields(["strDrink"], data)
        f_names, f_images = [], []
        for i in range(0, len(names)):
            if names[i] in a_names:
                f_names.append(names[i])
                f_images.append(images[i])
        if f_names == []:
            return None, []
        return self.pick4Random(f_names, f_images)

    


    #A esta función se le pasa una lista de cócteles y, dependiendo de los filtros activos, la reduce
    def applyAlcohol(self, names, photos, alcohol):
        if self.view.isToggledAlcohol() or self.view.isToggledNonAlcohol():
            fnames, fphotos = [], []
            if self.view.isToggledAlcohol():
                for i in range(0, len(names)):
                    if  not alcohol[i] == "Non alcoholic":
                        fnames.append(names[i])
                        fphotos.append(photos[i])
            else:
                for i in range(0, len(names)):
                    if alcohol[i] == "Non alcoholic":
                        fnames.append(names[i])
                        fphotos.append(photos[i])
            if fnames == []:
                return None, []
            return self.pick4Random(fnames, fphotos)
        else:
            return names, photos
        


    # FUNCIONES DE BUSCAR COCKTAILS
    # Funciones que usamos para buscar por Nombre

    def cocktailNoDetalleName(self, name):
            # Recibo el JSON de la capa modelo y lo formateo
        
        fieldList = ["strDrink", "strDrinkThumb", "strAlcoholic"]
        response = Model.searchByName(name)
        if response == "Internet error":
            return ("Internet error", [])
        data_json = response.text
        data = self.parseURL(data_json, True)
        if data == None:
            return None, []
        names, photos, alcohol = self.getAllFields(fieldList, data)
        return self.applyAlcohol(names, photos, alcohol)


    def cocktailDetalleName(self, name):
        
        fieldList = ["strDrink", "strDrinkThumb", "instructions", "ingredients"]
        # Recibo el JSON de la capa modelo y lo formateo
        response = Model.searchByName(name)
        if response == "Internet error":
            return None
        data_json = response.text 
        data = self.parseURL(data_json)
        if data == None:
            return None
        results = self.getFields(fieldList, data)
        #Devolvemos el JSON
        return results
        
        

    ######################################################
    # Funcion para buscar por ingrediente

    def cocktailByIngredient(self, ingName):

        fieldList = ["strDrink", "strDrinkThumb"]
        response = Model.searchByIng(ingName)
        if response == "Internet error":
            return ("Internet error", [])
        data_json = response.text
        data = self.parseURL(data_json, True)
        if data == None:
            return None, []
        names, images = self.getAllFields(fieldList, data)
        return self.addAlcoholFilter(names, images)


    # FUNCIONES PARA BUSCAR INGREDIENTES

    def ingredientByName(self, name):  #Busca un único ingrediente y devuelve nombre, imagen y descripción

        fieldList = ["strIngredient", "ingredientThumb", "strDescription", "strAlcohol", "strABV"]
        response = Model.searchIngByName(name)
        if response == "Internet error":
            return None
        data_json = response.text
        data = self.parseURL(data_json)
        if data == None:
            return None
        results = self.getFields(fieldList, data)
        return results



    def ingredientsByName(self, name): #Busca varios ingredientes y devuelve nombre e imagen
            
        fieldList = ["strIngredient", "ingredientThumb"]
        # Recibo el JSON de la capa modelo y lo formateo
        response = Model.searchIngByName(name)
        if response == "Internet error":
            return ("Internet error", [])
        data_json = response.text
        data = self.parseURL(data_json)
        if data == None:
            return None, []
        results = self.getFields(fieldList, data)
        name, image = [results[0]], [results[1]]
        return name, image

    # FUNCION PARA DAR UN RANDOM

    def randomCocktail(self): #Da información detallada de un cóctel aleatorio de la API
            
        fieldList = ["strDrink", "strDrinkThumb", "strInstructions", "ingredients"]
        # Recibo el JSON de la capa modelo y lo formateo
        response = Model.getRandom()
        if response == "Internet error":
            return None
        data_json = response.text
        data = self.parseURL(data_json)
        if data == None:
            return None
        results = self.getFields(fieldList, data)

        #Devolvemos la lista de JSON
        return results



    def random4Cocktail(self):  
            
            results_name = []
            results_photo = []

            while len(results_name) < 4:
                response = Model.getRandom()
                if response == "Internet error":
                    return None, []
                data_json = response.text
                data = json.loads(data_json)
                if data == None:
                    return None, []
                name = data["drinks"][0]["strDrink"]
                photo = data["drinks"][0]["strDrinkThumb"]
                if name not in results_name:
                    results_name.append(name)
                    results_photo.append(photo)
            
            return results_name,results_photo


    

    def random4Ingredients(self):
        names = []
        photos = []

        while len(names) < 4:
            cocktail = self.randomCocktail()
            if cocktail == None:
                return None, []
            index = random.randint(0, len(cocktail[3]) - 1)
            ingredient = cocktail[3][index]
            if(ingredient not in names):
                names.append(ingredient)
                photos.append(f"https://www.thecocktaildb.com/images/ingredients/{ingredient}-Small.png")

        return names, photos



    #FUNCIONES DE COMUNICACIÓN CON LA VISTA

    #Va a la pantalla de cócteles y muestra nombre e imagen de 4 cócteles aleatorios diferentes
    def on_cocktail_screen_clicked(self):
        def enterCocktailScreen():
            names, images = self.random4Cocktail()
            run_on_main_thread(showCocktailScreen, names, images)

        def showCocktailScreen(names, images):
            if names == None:
                    self.view.cocktailDBError()
            else:
                self.view.displayCocktails(names, images, True)
            self.activeThread = None


        if self.activeThread == None:
            new_thread =threading.Thread(target = enterCocktailScreen, daemon = True)
            self.activeThread = new_thread
            new_thread.start()


    def on_ingredient_screen_clicked(self):
        def getIngredientScreen():
            names, images = self.random4Ingredients()
            run_on_main_thread(showIngredientScreen, names, images)

        def showIngredientScreen(names, images):
            if names == None:
                self.view.ingredientDBError()
            else:
                self.view.displayIngredients(names, images, True)
            self.activeThread = None

        if self.activeThread == None:
            new_thread =threading.Thread(target = getIngredientScreen)
            self.activeThread = new_thread
            new_thread.start()


    def on_cocktail_clicked(self, name):
        def getCocktailInfo():
            data = self.cocktailDetalleName(name)
            run_on_main_thread(showCocktailInfo, data)
       
        def showCocktailInfo(data):
            if data == None:
                self.view.cocktailFetchError(name)
            else:
                self.view.displayCocktailInfo(data)
            self.activeThread = None


        if self.activeThread == None:
            new_thread =threading.Thread(target = getCocktailInfo())
            self.activeThread = new_thread
            new_thread.start()


    def on_ingredient_clicked(self, name):
        def displayIngredientInfo():
            data = self.ingredientByName(name)
            cnames, cimages = self.cocktailByIngredient(name)
            run_on_main_thread(showIngredientInfo, data, cnames, cimages)

        def showIngredientInfo(data, cnames, cimages):
            if data == None or cnames == None:
                self.view.ingredientFetchError(name)
            else:
                self.view.displayIngredientInfo(data, cnames, cimages)   
            self.activeThread = None     

        if self.activeThread == None:
            new_thread =threading.Thread(target = displayIngredientInfo())
            self.activeThread = new_thread
            new_thread.start()
    

    def on_cocktail_searched(self, name):
        def getCocktails():
            names, images = self.cocktailNoDetalleName(name)
            run_on_main_thread(showCocktails, names, images)

        def showCocktails(names, images):
            if names == None: 
                self.view.cocktailSearchError()
            elif names == "Internet error":
                self.view.cocktailDBError()
            else:
                self.view.displayCocktails(names, images)
            self.activeThread = None

        if self.activeThread == None:
            new_thread =threading.Thread(target = getCocktails)
            self.activeThread = new_thread
            new_thread.start()


    def on_ingredient_searched(self, name):
        def getIngredients():
            if name == "":
                names, images = self.random4Ingredients()
            else:
                names, images = self.ingredientsByName(name)

            run_on_main_thread(showIngredients, names, images)
            self.activeThread = None

        def showIngredients(names, images):
            if names == None:
                self.view.ingredientSearchError()
            elif names == "Internet error":
                self.view.ingredientDBError()
            else:
                self.view.displayIngredients(names, images)
            self.activeThread = None

        if self.activeThread == None:
            new_thread =threading.Thread(target = getIngredients)
            self.activeThread = new_thread
            new_thread.start()


    def on_cocktail_by_ingredient(self, ingredient):
        def getCocktailsIng():
            names, images = self.cocktailByIngredient(ingredient)
            run_on_main_thread(showCocktailsIng, names, images)

        def showCocktailsIng(names, images):
            if names == None:
                self.view.cocktailSearchError()
            elif names == "Internet error":
                self.view.cocktailDBError()
            else:
                self.view.displayCocktails(names, images)
            self.activeThread = None

        if self.activeThread == None:
            new_thread =threading.Thread(target = getCocktailsIng)
            self.activeThread = new_thread
            new_thread.start()

    def on_random_cocktail_clicked(self):
        def getRandomCocktail():
            data = self.randomCocktail()
            run_on_main_thread(showRandomCocktail, data)

        def showRandomCocktail(data):
            if data == None:
                self.view.cocktailFetchError(None)
            else:
                self.view.displayCocktailInfo(data)
            self.activeThread = None

        if self.activeThread == None:
            new_thread =threading.Thread(target = getRandomCocktail)
            self.activeThread = new_thread
            new_thread.start()
