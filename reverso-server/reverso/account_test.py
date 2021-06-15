from reverso_context_api import Client

client = Client("fr", "it", credentials=("f.mattiussi2004@gmail.com", "Francesco10"))
favorites = list(client.get_history())
print(favorites[10])