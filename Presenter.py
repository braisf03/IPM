from Model import Model
import json

# Funcion auxiliar que usamos para que no se repita tanto código que parsea el JSON

def parseUrlDetalle(response):
    results = []

    json_data = json.loads(response)

    json_data1 = json_data["drinks"][0]

    #Esto recorre el json guardando los cocktails en una lista
    for i in range(0,len(json_data["drinks"])):
        json_data1 = json_data["drinks"][i]
        results.append(json_data1)

    #Devuelve el JSON como string
    return results

def parseUrlNoDetalle(response):
    results = []

    json_data = json.loads(response)

    json_data1 = json_data["drinks"][0]

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
        results = parseUrlNoDetalle(response)

        #Devolvemos la lista de JSON
        #print(results)
        return results
    except Exception as e:
        print(f"Error: {e}")

def cocktailDetalleName(identificador):
    try:
        # Recibo el JSON de la capa modelo y lo formateo
        response = Model.searchByName(identificador).text
        results = parseUrlDetalle(response)

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
        results = parseUrlNoDetalle(response)

        #Devolvemos la lista de JSON
        #print(results)
        return results
    except Exception as e:
        print(f"Error: {e}")

def cocktailDetalleId(identificador):
    try:
        # Recibo el JSON de la capa modelo y lo formateo
        response = Model.searchById(identificador).text
        results = parseUrlDetalle(response)

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
        results = parseUrlNoDetalle(response)

        #Devolvemos la lista de JSON
        #print(results)
        return results
    except Exception as e:
        print(f"Error: {e}")

def cocktailDetalleFirstLetter(identificador):
    try:
        # Recibo el JSON de la capa modelo y lo formateo
        response = Model.searchByFirstLetter(identificador).text
        results = parseUrlDetalle(response)

        #Devolvemos la lista de JSON
        #print(results)
        return results
    except Exception as e:
        print(f"Error: {e}")

# Funcion para buscar por ingrediente

def cocktailByIngredient(identificador):
    try:
        
        response = Model.searchByIng(identificador).text
        results = parseUrlDetalle(response)
        
        #Devuelve el JSON como string
        return results
    except Exception as e:
        print(f"Error: {e}")

# FUNCIONES PARA BUSCAR INGREDIENTES

def ingredientByName(identificador):
    try:
        # Recibo el JSON de la capa modelo y lo formateo
        response = Model.searchIngByName(identificador).text
        results = parseUrlIng(response)
        
        return results
    except Exception as e:
        print(f"Error: {e}")

def ingredientById(identificador):
    try:
        # Recibo el JSON de la capa modelo y lo formateo
        response = Model.searchIngByID(identificador).text
        results = parseUrlIng(response)
        #Devuelve el JSON como string
        return results
    except Exception as e:
        print(f"Error: {e}")

# FUNCION PARA DAR UN RANDOM

def randomCocktail():
    try:
        # Recibo el JSON de la capa modelo y lo formateo
        response = Model.getRandom().text
        results = parseUrlDetalle(response)

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
        results = parseUrlDetalle(response)

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
        results = parseUrlDetalle(response)

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
        results = parseUrlDetalle(response)

        #Devolvemos la lista de JSON
        #print(results)
        return results
    except Exception as e:
        print(f"Error: {e}")
