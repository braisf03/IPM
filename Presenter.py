from Model import Model
import json
import random

# Funcion auxiliar que usamos para que no se repita tanto código que parsea el JSON

class Presenter:

    def parseUrlDetalle(response):
        results = []

        json_data = json.loads(response)

        #Esto recorre el json guardando los cocktails en una lista
        for i in range(0,len(json_data["drinks"])):
            json_data1 = json_data["drinks"][i]
            results.append(json_data1)

        #Devuelve el JSON como string
        return results

    def parseUrlNoDetalle(response):
        results = []

        json_data = json.loads(response)

        #Esto recorre el json guardando los cocktails en una lista
        for i in range(0,len(json_data["drinks"])):
            json_data1 = json_data["drinks"][i]
            results.append(json_data1["strDrink"] + " " + json_data1["strDrinkThumb"])

        #Devuelve el JSON como string
        return results

    # Funcion para los ingredientes

    def parseUrlIng(response):
        results = []

        json_data = json.loads(response)

        json_data1 = json_data["ingredients"][0]

        #Esto recorre el json guardando los cocktails en una lista
        for i in range(0,len(json_data["ingredients"])):
            json_data1 = json_data["ingredients"][i]
            results.append(json_data1)

        #Devuelve el JSON como string
        return results

    # FUNCIONES DE BUSCAR COCKTAILS
    # Funciones que usamos para buscar por Nombre

    def cocktailNoDetalleName(identificador):
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.searchByName(identificador).text
            results = Presenter.parseUrlNoDetalle(response)

            #Devolvemos la lista de JSON
            print(results)
            return results
        except Exception as e:
            print(f"Error: {e}")

    def cocktailDetalleName(identificador):
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.searchByName(identificador).text
            results = Presenter.parseUrlDetalle(response)

            #Devolvemos la lista de JSON
            #print(results)
            return results
        except Exception as e:
            print(f"Error: {e}")

    # Funciones que usamos para buscar por Id

    def cocktailNoDetalleId(identificador):
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.searchById(identificador).text
            results = Presenter.parseUrlNoDetalle(response)

            #Devolvemos la lista de JSON
            #print(results)
            return results
        except Exception as e:
            print(f"Error: {e}")

    def cocktailDetalleId(identificador):
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.searchById(identificador).text
            results = Presenter.parseUrlDetalle(response)

            #Devolvemos la lista de JSON
            #print(results)
            return results
        except Exception as e:
            print(f"Error: {e}")

    # Funciones que usamos para buscar por primera letra

    def cocktailNoDetalleFirstLetter(identificador):
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.searchByFirstLetter(identificador).text
            results = Presenter.parseUrlNoDetalle(response)

            #Devolvemos la lista de JSON
            #print(results)
            return results
        except Exception as e:
            print(f"Error: {e}")

    def cocktailDetalleFirstLetter(identificador):
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.searchByFirstLetter(identificador).text
            results = Presenter.parseUrlDetalle(response)

            #Devolvemos la lista de JSON
            #print(results)
            return results
        except Exception as e:
            print(f"Error: {e}")
    ######################################################
    # Funcion para buscar por ingrediente

    def cocktailByIngredient(identificador):
        try:
        
            response = Model.searchByIng(identificador).text
            results = Presenter.parseUrlDetalle(response)
        
            #Devuelve el JSON como string
            return results
        except Exception as e:
            print(f"Error: {e}")

    # FUNCIONES PARA BUSCAR INGREDIENTES

    def ingredientByName(identificador):
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.searchIngByName(identificador).text
            results = Presenter.parseUrlIng(response)
        
            return results
        except Exception as e:
            print(f"Error: {e}")

    def ingredientById(identificador):
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.searchIngByID(identificador).text
            results = Presenter.parseUrlIng(response)
            #Devuelve el JSON como string
            return results
        except Exception as e:
            print(f"Error: {e}")

    # FUNCION PARA DAR UN RANDOM

    def randomCocktail():
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.getRandom().text
            results = Presenter.parseUrlDetalle(response)

            #Devolvemos la lista de JSON
            #print(results)
            return results
        except Exception as e:
            print(f"Error: {e}")

    # FILTROS DE BÚSQUEDA
    # Filtro de alcohol

    def filterByAlcohol(identificador):
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.alcoholFilter(identificador).text
            results = Presenter.parseUrlDetalle(response)

            #Devolvemos la lista de JSON
            #print(results)
            return results
        except Exception as e:
            print(f"Error: {e}")

    # Filtro de categoría

    def filterByCategory(identificador):
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.categoryFilter(identificador).text
            results = Presenter.parseUrlDetalle(response)

            #Devolvemos la lista de JSON
            #print(results)
            return results
        except Exception as e:
            print(f"Error: {e}")

    # Filtro de Vaso

    def filterByGlass(identificador):
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.glassFilter(identificador).text
            results = Presenter.parseUrlDetalle(response)

            #Devolvemos la lista de JSON
            #print(results)
            return results
        except Exception as e:
            print(f"Error: {e}")


    # Hacer una funcion 4 cocktails
    def XcocktailNoDetalleName(identificador):
        try:
            # Recibo el JSON de la capa modelo y lo formateo
            response = Model.searchByName(identificador).text
            results_name = []
            results_photo = []

            json_data = json.loads(response)

            if len(json_data["drinks"])>4:
                numeros = random.sample(range(0,len(json_data["drinks"])),4)
                print(numeros)
                for i in range(0,4):
                    json_data1 = json_data["drinks"][numeros[i]]["strDrink"]
                    json_data2 = json_data["drinks"][numeros[i]]["strDrinkThumb"]
                    results_name.append(json_data1)
                    results_photo.append(json_data2)
            else:
                #Esto recorre el json guardando los cocktails en una lista
                for i in range(0,len(json_data["drinks"])):
                    json_data1 = json_data["drinks"][i]["strDrink"]
                    json_data2 = json_data["drinks"][i]["strDrinkThumb"]
                    results_name.append(json_data1)
                    results_photo.append(json_data2)

            #Devuelve el JSON como string
            print(results_name)
            print(results_photo)
            return results_name,results_photo
        except Exception as e:
            print(f"Error: {e}")


    def get4Random():
        results_name = []
        restults_photo = []

        #Esto recorre el json guardando los cocktails en una lista
        for i in range(0,3):
            response = Model.getRandom()
            json_data = json.loads(response)

            json_data1 = json_data["drinks"][0]["strDrink"]
            json_data2 = json_data["drinks"][0]["strDrinkThumb"]
            results_name.append(json_data1)
            restults_photo.append(json_data2)

        #Devuelve el JSON como string
        return results_name,restults_photo
    


    def random4Cocktail():
        try:
            results_name = []
            results_photo = []

            while len(results_name) < 4:
                response = Model.getRandom().text
                json_data = json.loads(response)

                json_data1 = json_data["drinks"][0]["strDrink"]
                json_data2 = json_data["drinks"][0]["strDrinkThumb"]
                if json_data1 not in results_name:
                    results_name.append(json_data1)
                    results_photo.append(json_data2)

            return results_name,results_photo
        except Exception as e:
            print(f"Error: {e}")


# PRUEBAS DE CÓDIGO

url = "margarita"

#numeros = random.sample(range(0,5),4)
#print(numeros)

#(l1,l2) = Presenter.XcocktailNoDetalleName(url)

(l1,l2) = Presenter.random4Cocktail()

print(l1)
print(l2)


