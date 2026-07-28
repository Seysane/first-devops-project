FROM python:3.11-slim

WORKDIR /app

# Instalacja zależności
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Kopiowanie kodu źródłowego
COPY app.py .

EXPOSE 5000

ENV PYTHONUNBUFFERED=1

CMD ["python", "app.py"]