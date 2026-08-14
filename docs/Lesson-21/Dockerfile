FROM python:3.11-slim

WORKDIR /app

# Dependency install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Main app copy
COPY app.py .

EXPOSE 5000

ENV PYTHONUNBUFFERED=1

CMD ["python", "app.py"]