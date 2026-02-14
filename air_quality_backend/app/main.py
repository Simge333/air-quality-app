from fastapi import FastAPI, HTTPException
from app.services.air_quality_service import get_air_quality, interpret_aqi
from app.services.geocoding_service import get_coordinates_by_city

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Air Quality API is running"}

@app.get("/air-quality/by-city")
def air_quality_by_city(city: str):
    coords = get_coordinates_by_city(city)

    if not coords:
        raise HTTPException(status_code=404, detail="Şehir bulunamadı")

    return get_air_quality(coords["lat"], coords["lon"])

@app.get("/air-quality")
def air_quality(lat: float, lon: float):
    return get_air_quality(lat, lon)

##çalıştırıken  uvicorn app.main:app --reload