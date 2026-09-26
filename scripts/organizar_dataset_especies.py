"""
Organiza as fotos de esporos de FMA (Downloads/FMA MICROS) em uma estrutura
de dataset de classificacao para o Ultralytics YOLO:

ia/dataset_especies/
    train/<especie>/*.jpg
    val/<especie>/*.jpg

O nome da especie e extraido do nome do arquivo (removendo numeros/sufixos).
Imagens com nome ambiguo ("G. gigaspora") sao ignoradas.
"""

import re
import shutil
from pathlib import Path

ORIGEM = Path(r"C:\Users\gabri\Downloads\FMA MICROS")
DESTINO = Path(r"C:\Users\gabri\Desktop\Micros\ia\dataset_especies")

IGNORAR = {"g. gigaspora"}


def nome_especie(caminho: Path) -> str | None:
    nome = caminho.stem  # sem extensao
    nome = re.sub(r"\s*\d+$", "", nome).strip()  # remove sufixo numerico ("... 2")

    if nome.lower() in IGNORAR:
        return None

    slug = nome.replace(".", "").replace("  ", " ").strip()
    slug = slug[0].upper() + slug[1:] if slug else slug
    partes = slug.split(" ")
    partes = [p.capitalize() if i == 0 else p.lower() for i, p in enumerate(partes)]
    return "_".join(partes)


def main():
    grupos: dict[str, list[Path]] = {}

    for arquivo in sorted(ORIGEM.glob("*.jpg")):
        especie = nome_especie(arquivo)
        if especie is None:
            print(f"Ignorado (nome ambiguo): {arquivo.name}")
            continue
        grupos.setdefault(especie, []).append(arquivo)

    for especie, arquivos in grupos.items():
        train_dir = DESTINO / "train" / especie
        val_dir = DESTINO / "val" / especie
        train_dir.mkdir(parents=True, exist_ok=True)
        val_dir.mkdir(parents=True, exist_ok=True)

        if len(arquivos) == 1:
            # Sem imagem suficiente para separar val: usa a mesma para os dois.
            shutil.copy(arquivos[0], train_dir / arquivos[0].name)
            shutil.copy(arquivos[0], val_dir / arquivos[0].name)
        else:
            *treino, validacao = arquivos
            for a in treino:
                shutil.copy(a, train_dir / a.name)
            shutil.copy(validacao, val_dir / validacao.name)

        print(f"{especie}: {len(arquivos)} imagem(ns) -> "
              f"{len(list(train_dir.iterdir()))} treino, {len(list(val_dir.iterdir()))} val")


if __name__ == "__main__":
    main()
