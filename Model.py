import requests


class Model:
        def actualizar_Api(self):
            self.resultado = None

            try:
                url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=11000"  
                response = requests.get(url)

                if response.status_code == 200:
                    return response
                    

                else:
                    return None
    
            except requests.exceptions.RequestException as e:
                return None
        
        def searchById(self, id: int):

            try:
                url = f"https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i={id}"  
                response = requests.get(url)

                if response.status_code == 200:
                    return response
                    

                else:
                    return None
    
            except requests.exceptions.RequestException as e:
                return None


        def searchByName(self, name: str):

            try:
                url = f"https://www.thecocktaildb.com/api/json/v1/1/search.php?s={name}"  
                response = requests.get(url)

                if response.status_code == 200:
                    return response
                    

                else:
                    return None
    
            except requests.exceptions.RequestException as e:
                return None
            


        def searchByFirstLetter(self, letter: chr):
        

            try:
                url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f={letter}"  
                response = requests.get(url)

                if response.status_code == 200:
                    return response
                    

                else:
                    return None
    
            except requests.exceptions.RequestException as e:
                return None    

        def categoryFilter(self, isCocktail: bool):
            resultado = None

            try:
                if(isCocktail):
                    url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?c=Cocktail"  
                    response = requests.get(url)

                else:
                    url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?c=Ordinary_Drink"
                    response = requests.get(url)

                if response.status_code == 200:
                    return response   

                else:
                    return None
    
            except requests.exceptions.RequestException as e:
                print(f"Error de solicitud: { str(e)}")
                return None 

        def alcoholFilter(self, hasAlcohol: bool):
            resultado = None

            try:
                if(hasAlcohol):
                    url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?a=Alcoholic"  
                    response = requests.get(url)

                else:
                    url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?a=Non_Alcoholic"
                    response = requests.get(url)


                if response.status_code == 200:
                    return response                    

                else:
                    print(f"Error en la solicitud: {response.status_code}")
                    return None
    
            except requests.exceptions.RequestException as e:
                print(f"Error de solicitud: { str(e)}")
                return None    

        
        def glassFilter(isCocktailGlass):
            resultado = None

            try:
                if(isCocktailGlass):
                    url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?g=Cocktail_Glass"  
                    response = requests.get(url)

                else:
                    url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?g=Champagne_Flute"
                    response = requests.get(url)

                if response.status_code == 200:
                    return response
                    
                else:
                    return None
    
            except requests.exceptions.RequestException as e:
                return None 
ç
                
