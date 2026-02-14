import os
import requests
from dotenv import load_dotenv

load_dotenv()

OPENWEATHER_API_KEY = os.getenv("OPENWEATHER_API_KEY")
BASE_URL = "http://api.openweathermap.org/data/2.5/air_pollution"

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
    level, description = interpret_aqi(aqi)

    return {
        "aqi": aqi,
        "level": level,
        "description": description,
        "components": data["list"][0]["components"]
    }

def interpret_aqi(aqi: int):
    if aqi == 1:
        return "İyi", "Hava kalitesi iyi, dışarı çıkmak için uygun."
    elif aqi == 2:
        return "Orta", "Hava kalitesi orta."
    elif aqi == 3:
        return "Hassas", "Hassas gruplar dikkat etmeli."
    elif aqi == 4:
        return "Kötü", "Dışarı çıkılması önerilmez."
    else:
        return "Çok Kötü", "Sağlık açısından tehlikeli."
