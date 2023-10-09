import requests


class Model:
        def actualizar_Api(self):
            self.resultado = None

            try:
                url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=11000"  
                response = requests.get(url)

                if response.status_code == 200:
                    data = response.json()
                    return data
                    

                else:
                    print(f"Error en la solicitud: {response.status_code}")
                    return None
    
            except requests.exceptions.RequestException as e:
                print(f"Error de solicitud: { str(e)}")
                return None



# Create an instance of the Modelo class
modelo = Model()

# Call the get_data method with some data (you should replace 'data' with the actual data you want to use)
datos = modelo.actualizar_Api()
print(f"{datos}")