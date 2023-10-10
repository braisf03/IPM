#import Model
#import View
import requests
import json

# Yo recibo las peticiones del View y llamo al Model para que me busque esas peticiones que luego le formateo y devuelvo al View

def separar_json(url):
    try:
        # Obtener el JSON desde la URL
        response = requests.get(url)

        # Verificar si la solicitud fue exitosa
        if response.status_code == 200:
            # Analizar el JSON
            data = response.json()
            
            # Convertir el JSON en una cadena JSON formateada
            json_string = json.dumps(data, indent=4)
            
            # Separar la cadena en líneas
            lineas = json_string.split('\n')

            # Pasar las líneas como desees
            for linea in lineas:
                print(linea)
        else:
            print(f"Error: No se pudo obtener el JSON (Código de estado: {response.status_code})")
    except Exception as e:
        print(f"Error: {e}")


def cocktail_no_detalle(url):
    try:
        results = []
        # Analizar el JSON
        response = requests.get(url)

        if response.status_code == 200:
            response = requests.get(url).text
            # Obtener el contenido JSON de la respuesta 
            json_data = json.loads(response)

            json_data1 = json_data["drinks"][0]

            for i in range(0,len(json_data["drinks"])):
                json_data1 = json_data["drinks"][i]
                results.append(json_data1["strDrink"] + " " + json_data1["strDrinkThumb"])
            print(results)
            return results
            
        else:
            print(f"Error: No se pudo obtener el JSON (Código de estado: {response.status_code})")
    except Exception as e:
        print(f"Error: {e}")


def cocktail_detalle(url):
    try:
        results = []
        # Analizar el JSON
        response = requests.get(url)

        if response.status_code == 200:
            response = requests.get(url).text
            # Obtener el contenido JSON de la respuesta 
            json_data = json.loads(response)

            json_data1 = json_data["drinks"][0]

            #Esto recorre el json guardando los cocktails en una lista
            for i in range(0,len(json_data["drinks"])):
                json_data1 = json_data["drinks"][i]
                results.append(json_data1)

            #Esto imprime los resultados
            print(results)

            return results
        else:
            print(f"Error: No se pudo obtener el JSON (Código de estado: {response.status_code})")
    except Exception as e:
        print(f"Error: {e}")

url="http://www.thecocktaildb.com/api/json/v1/1/search.php?s=lemon"  

#cocktail_detalle(url)
cocktail_no_detalle(url)
