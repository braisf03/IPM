import requests


class Model:

    APIUrl = "https://www.thecocktaildb.com/api/json/v1/1"

    @staticmethod
    def getFromAPI (url: str):
            
        try:
            response = requests.get(url)
            if response.status_code == 200:
                return response
                    
            else:
                return None
                
        except requests.exceptions.RequestException as e:
            return None    


    @staticmethod
    def searchById(id: int):

        url = f"{Model.APIUrl}/lookup.php?i={id}"  
        return Model.getFromAPI(url)


    @staticmethod
    def searchByName(name: str):

        url = f"{Model.APIUrl}/search.php?s={name}"  
        return Model.getFromAPI(url)
            

    @staticmethod
    def searchByFirstLetter(letter: chr):
        
        url = f"{Model.APIUrl}/search.php?f={letter}"  
        return Model.getFromAPI(url)    
    

    @staticmethod
    def categoryFilter(category: str):

        url = f"{Model.APIUrl}/lookup.php?c={category}"  
        return Model.getFromAPI(url)
    

    @staticmethod
    def alcoholFilter(hasAlcohol: bool):

        if(hasAlcohol):
            url = f"{Model.APIUrl}/lookup.php?a=Alcoholic"  

        else:
            url = f"{Model.APIUrl}/lookup.php?a=Non_Alcoholic"

        return Model.getFromAPI(url)    


    @staticmethod
    def glassFilter(isCocktailGlass: bool):

        if(isCocktailGlass):
            url = f"{Model.APIUrl}/lookup.php?g=Cocktail_Glass"  

        else:    
            url = f"{Model.APIUrl}/lookup.php?g=Champagne_Flute"

        return Model.getFromAPI(url)
    
    
    @staticmethod
    def getRandom():

        url = f"{Model.APIUrl}/random.php"
        return Model.getFromAPI(url);
    

    @staticmethod
    def searchIngByID(id: int):

        url = f"{Model.APIUrl}/lookup.php?iid={id}"
        return Model.getFromAPI(url);


    @staticmethod
    def searchIngByName(name: str):
        
        url = f"{Model.APIUrl}/search.php?i={name}"
        return Model.getFromAPI(url);

    @staticmethod
    def searchByIng(ingredient: str):
        
        url = f"{Model.APIUrl}/filter.php?i={ingredient}"
        return Model.getFromAPI(url);
