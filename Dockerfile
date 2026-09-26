# Estágio 1: compila o app Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS flutter_build

WORKDIR /app/mobile
COPY mobile/pubspec.yaml mobile/pubspec.lock ./
RUN flutter pub get

COPY mobile/. .

# API_BASE_URL vazio = o site usa caminho relativo (mesma origem do
# servidor que o serve). Não precisa saber o domínio final de antemão.
RUN flutter build web --release --dart-define=API_BASE_URL=


# Estágio 2: API em Python, servindo o site já compilado
FROM python:3.11-slim

WORKDIR /app

# Bibliotecas de sistema exigidas pelo opencv-python-headless / ultralytics
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY api ./api
COPY ia ./ia
COPY database ./database
COPY --from=flutter_build /app/mobile/build/web ./web

EXPOSE 8000

CMD ["sh", "-c", "uvicorn api.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
