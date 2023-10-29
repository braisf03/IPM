import requests


class Model:

    APIUrl = "https://www.thecocktaildb.com/api/json/v1/1"

    @staticmethod
    def _getFromAPI (url: str):  
    #Método privado que se encarga de acceder a la base de datos. Todas las otras funciones de esta clase lo llaman        
        try:
            response = requests.get(url) 
            return response
              
        except requests.exceptions.RequestException as e: #Error de acceso a la base de datos
            return "Internet error"


    @staticmethod
    def searchByName(name: str):  #Búsqueda por nombre o por un fragmento de él

        url = f"{Model.APIUrl}/search.php?s={name}"  
        return Model._getFromAPI(url)



    @staticmethod
    def alcoholFilter(hasAlcohol: bool): #Filtro por alcohol

        if(hasAlcohol):
            url = f"{Model.APIUrl}/filter.php?a=Alcoholic"  

        else:
            url = f"{Model.APIUrl}/filter.php?a=Non_Alcoholic"

        return Model._getFromAPI(url)    
    
        
    @staticmethod
    def getRandom(): #Búsqueda de un cóctel aleatorio

        url = f"{Model.APIUrl}/random.php"
        return Model._getFromAPI(url);
    

    @staticmethod
    def searchIngByID(id: int): #Búsqueda de un ingrediente por identificador

        url = f"{Model.APIUrl}/lookup.php?iid={id}"
        return Model._getFromAPI(url);


    @staticmethod
    def searchIngByName(name: str):  #Búsqueda de un ingrediente por nombre
        
        url = f"{Model.APIUrl}/search.php?i={name}"
        return Model._getFromAPI(url);

    @staticmethod
    def searchByIng(ingredient: str): #Búsqueda de cócteles que contengan un ingrediente
        
        url = f"{Model.APIUrl}/filter.php?i={ingredient}"
        return Model._getFromAPI(url);