import requests


class Model:

    APIUrl = "https://www.thecocktaildb.com/api/json/v1/1"

    def getFromAPI (self, url: str):
            
        try:
            response = requests.get(url)
            if response.status_code == 200:
                return response
                    
            else:
                return None
                
        except requests.exceptions.RequestException as e:
            return None    



    def searchById(self, id: int):

        url = f"{self.APIUrl}/lookup.php?i={id}"  
        return self.getFromAPI(url)



    def searchByName(self, name: str):

        url = f"h{self.APIUrl}/search.php?s={name}"  
        return self.getFromAPI(url)
            


    def searchByFirstLetter(self, letter: chr):
        
        url = f"{self.APIUrl}/search.php?f={letter}"  
        return self.getFromAPI(url)    
    


    def categoryFilter(self, isCocktail: bool):

        if(isCocktail):
            url = f"{self.APIUrl}/lookup.php?c=Cocktail"  

        else:
            url = f"{self.APIUrl}/lookup.php?c=Ordinary_Drink"

        return self.getFromAPI(url)
    


    def alcoholFilter(self, hasAlcohol: bool):

        if(hasAlcohol):
            url = f"{self.APIUrl}/lookup.php?a=Alcoholic"  

        else:
            url = f"{self.APIUrl}/lookup.php?a=Non_Alcoholic"

        return self.getFromAPI(url)    



    def glassFilter(self, isCocktailGlass: bool):

        if(isCocktailGlass):
            url = f"{self.APIUrl}/lookup.php?g=Cocktail_Glass"  

        else:    
            url = f"{self.APIUrl}/lookup.php?g=Champagne_Flute"

        return self.getFromAPI(url)
    
    

    def getRandom(self):

        url = f"{self.APIUrl}/random.php"
        return self.getFromAPI(url);
    


    def searchIngByID(self, id: int):

        url = f"{self.APIUrl}/lookup.php?iid={id}"
        return self.getFromAPI(url);



    def searchIngByName(self, name: str):
        
        url = f"{self.APIUrl}/search.php?i={name}"
        return self.getFromAPI(url);

    def searchByIng(self, ingredient: str):
        
        url = f"{self.APIUrl}/filter.php?i={ingredient}"
        return self.getFromAPI(url);
