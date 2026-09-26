import sqlite3
import os

os.makedirs("database", exist_ok=True)

conexao = sqlite3.connect("database/micros.db", check_same_thread=False)

cursor = conexao.cursor()

cursor.execute("""
CREATE TABLE IF NOT EXISTS analises(

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    arquivo TEXT,

    classe TEXT,

    confianca REAL,

    tipo TEXT DEFAULT 'especie',

    data_hora TEXT
)
""")

conexao.commit()


# Migração leve para bancos criados antes das colunas "tipo" e "data_hora"
for coluna, definicao in [("tipo", "TEXT DEFAULT 'especie'"), ("data_hora", "TEXT")]:

    try:
        cursor.execute(f"ALTER TABLE analises ADD COLUMN {coluna} {definicao}")
        conexao.commit()
    except sqlite3.OperationalError:
        pass  # coluna já existe


def salvar(arquivo, classe, confianca, tipo="especie"):

    cursor.execute("""

        INSERT INTO analises
        (arquivo, classe, confianca, tipo, data_hora)

        VALUES (?, ?, ?, ?, datetime('now', 'localtime'))

    """, (arquivo, classe, confianca, tipo))

    conexao.commit()


def listar():

    cursor.execute("""

        SELECT *

        FROM analises

        ORDER BY id DESC

    """)

    return cursor.fetchall()


def limpar():

    cursor.execute("DELETE FROM analises")

    conexao.commit()
