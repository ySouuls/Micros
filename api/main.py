from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from ia.detector import detectar
from ia.contador import contar
from database.database import salvar, listar, limpar

import shutil
import os


print("MAIN CARREGADO")
print("Detector importado com sucesso")


app = FastAPI(
    title="Micros API",
    description="API para identificação de fungos micorrízicos e análise",
    version="1.0"
)


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)



@app.get("/status")
def status():

    return {
        "projeto": "Micros",
        "status": "online"
    }



@app.get("/historico")
def historico():

    return listar()



@app.delete("/historico")
def apagar_historico():

    limpar()

    return {"status": "historico apagado"}



@app.post("/predict")
async def predict(file: UploadFile = File(...)):

    print("Imagem recebida:", file.filename)


    pasta_upload = "api/uploads"

    os.makedirs(
        pasta_upload,
        exist_ok=True
    )


    caminho = os.path.join(
        pasta_upload,
        file.filename
    )


    with open(caminho, "wb") as buffer:

        shutil.copyfileobj(
            file.file,
            buffer
        )


    print("Imagem salva em:", caminho)


    objetos = detectar(caminho)


    print("Resultado da IA:")
    print(objetos)



    for objeto in objetos:

        salvar(
            file.filename,
            objeto["classe"],
            objeto["confianca"]
        )



    return {

        "arquivo": file.filename,

        "quantidade_detectada": len(objetos),

        "deteccoes": objetos

    }



@app.post("/contar")
async def contar_fungos(file: UploadFile = File(...)):

    print("Imagem recebida para contagem:", file.filename)

    pasta_upload = "api/uploads"

    os.makedirs(
        pasta_upload,
        exist_ok=True
    )

    caminho = os.path.join(
        pasta_upload,
        file.filename
    )

    with open(caminho, "wb") as buffer:

        shutil.copyfileobj(
            file.file,
            buffer
        )

    resultado = contar(caminho)

    print("Resultado da contagem:", resultado)

    salvar(
        file.filename,
        "Contagem de fungos",
        resultado["quantidade"],
        tipo="contagem"
    )

    return {

        "arquivo": file.filename,

        "quantidade": resultado["quantidade"],

        "deteccoes": resultado["deteccoes"]

    }



# Serve o app Flutter Web (pasta "web", gerada por "flutter build web")
# na raiz do site. Só monta se a pasta existir, pra não quebrar o
# desenvolvimento local quando o site ainda não foi buildado.
if os.path.isdir("web"):
    app.mount("/", StaticFiles(directory="web", html=True), name="web")