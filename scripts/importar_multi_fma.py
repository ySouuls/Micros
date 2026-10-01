"""
Importa as fotos da pasta "Desktop/FMA MICROS/Imagens Novas/MULTI FMA"
(formato .tif, separadas por especie pelo prefixo do nome do arquivo)
para o dataset de classificacao, convertendo para .jpg e separando
train/val (~80/20).

Nao usa a subpasta "Bioma Pampa" (amostras de solo, sem separacao por
especie) nem a pasta "Coleta 2" (amostras de campo sem identificacao).
"""

import re
from pathlib import Path

from PIL import Image

ORIGEM = Path(r"C:\Users\gabri\Desktop\FMA MICROS\Imagens Novas\MULTI FMA")
DESTINO = Path(r"C:\Users\gabri\Desktop\Micros\ia\dataset_especies")

MAPA_PREFIXO = {
    "a_morrowiae": "Acaulospora_morrowiae",
    "e_etunicata": "Entrophospora_etunicata",
    "f_mosseae": "Funneliformis_mosseae",
    "g_gigantea": "Gigaspora_gigantea",
    "gigantea": "Gigaspora_gigantea",
    "r_clarus": "Rhizophagus_clarus",
}


def especie_do_arquivo(caminho: Path):
    nome = caminho.stem.lower()
    nome = re.sub(r"_\d+$", "", nome)
    return MAPA_PREFIXO.get(nome)


def main():
    grupos: dict[str, list[Path]] = {}

    for arquivo in sorted(ORIGEM.glob("*.tif")):
        especie = especie_do_arquivo(arquivo)
        if especie is None:
            print(f"Ignorado (nao reconhecido): {arquivo.name}")
            continue
        grupos.setdefault(especie, []).append(arquivo)

    for especie, arquivos in grupos.items():
        train_dir = DESTINO / "train" / especie
        val_dir = DESTINO / "val" / especie
        train_dir.mkdir(parents=True, exist_ok=True)
        val_dir.mkdir(parents=True, exist_ok=True)

        n_val = max(1, len(arquivos) // 5)
        val_arquivos = arquivos[:n_val]
        train_arquivos = arquivos[n_val:]

        for destino_dir, lista in (
            (train_dir, train_arquivos),
            (val_dir, val_arquivos),
        ):
            for arquivo in lista:
                imagem = Image.open(arquivo).convert("RGB")
                nome_novo = f"multi_fma_{arquivo.stem}.jpg"
                imagem.save(destino_dir / nome_novo, "JPEG", quality=90)

        print(
            f"{especie}: {len(arquivos)} novas -> "
            f"{len(train_arquivos)} treino, {len(val_arquivos)} val"
        )


if __name__ == "__main__":
    main()
