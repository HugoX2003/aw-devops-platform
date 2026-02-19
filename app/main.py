from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Hello from FastAPI on EKS via Argo CD! pequeño cambio para disparar el workflow de github actions"}