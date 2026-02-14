import requests
import os

OPENWEATHER_API_KEY = os.getenv("OPENWEATHER_API_KEY")

def get_coordinates_by_city(city: str):
    url = "http://api.openweathermap.org/geo/1.0/direct"
    params = {
        "q": city,
        "limit": 1,
        "appid": OPENWEATHER_API_KEY
    }

    response = requests.get(url, params=params)
    data = response.json()

    if not data:
        return None

    return {
        "lat": data[0]["lat"],
        "lon": data[0]["lon"]
    }
def get_air_quality(lat: float, lon: float):
    url = "http://api.openweathermap.org/data/2.5/air_pollution"
    params = {
        "lat": lat,
        "lon": lon,
        "appid": OPENWEATHER_API_KEY
    }

    response = requests.get(url, params=params)
    data = response.json()

    aqi = data["list"][0]["main"]["aqi"]

    levels = {
        1: ("İyi", "Hava kalitesi çok iyi"),
        2: ("Orta", "Hassas kişiler dikkat etmeli"),
        3: ("Hassas", "Uzun süre dışarıda kalmayın"),
        4: ("Kötü", "Maske önerilir"),
        5: ("Çok Kötü", "Dışarı çıkmayın")
    }

    level, description = levels[aqi]

    return {
        "aqi": aqi,
        "level": level,
        "description": description
    }