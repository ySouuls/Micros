from ultralytics import YOLO

# Treina um classificador de espécies de fungos micorrízicos (FMA)
# a partir das fotos organizadas em ia/dataset_especies/train|val/<especie>/

modelo = YOLO("yolo11n-cls.pt")

resultados = modelo.train(
    data="ia/dataset_especies",
    epochs=60,
    patience=15,
    imgsz=224,
    dropout=0.3,
    project="ia/results",
    name="especies_fma",
    exist_ok=True,
)

print("Treinamento finalizado!")
print("Melhor modelo salvo em: runs/classify/ia/results/especies_fma/weights/best.pt")
print("Copie esse arquivo para ia/models/best.pt para o app usar o modelo novo.")
