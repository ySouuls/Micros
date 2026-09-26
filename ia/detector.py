from ultralytics import YOLO
from ia.config import MODELO, CONFIANCA_MINIMA


# Carrega o modelo apenas uma vez
model = YOLO(MODELO)


def detectar(imagem):

    resultados = model.predict(
        source=imagem,
        save=False,
        verbose=False,
    )

    probs = resultados[0].probs

    classe_idx = int(probs.top1)
    confianca = float(probs.top1conf)

    especie = model.names[classe_idx]

    if confianca < CONFIANCA_MINIMA:
        return []

    return [{
        "classe": especie,
        "confianca": round(confianca * 100, 2),
    }]
