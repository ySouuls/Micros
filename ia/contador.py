from ultralytics import YOLO
from ia.config import MODELO_CONTAGEM, CONFIANCA_MINIMA_CONTAGEM


# Carrega o modelo de contagem de esporos apenas uma vez
model_contagem = YOLO(MODELO_CONTAGEM)


def contar(imagem):

    resultados = model_contagem.predict(
        source=imagem,
        conf=CONFIANCA_MINIMA_CONTAGEM,
        save=True,
        project="resultados",
        name="contagens",
        exist_ok=True
    )

    caixas = resultados[0].boxes

    deteccoes = []

    for caixa in caixas:

        confianca = float(caixa.conf[0])
        xyxy = caixa.xyxy[0].tolist()

        deteccoes.append({
            "confianca": round(confianca * 100, 2),
            "x1": round(xyxy[0], 2),
            "y1": round(xyxy[1], 2),
            "x2": round(xyxy[2], 2),
            "y2": round(xyxy[3], 2),
        })

    return {
        "quantidade": len(deteccoes),
        "deteccoes": deteccoes,
    }
