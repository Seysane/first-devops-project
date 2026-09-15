from flask import Flask
import psycopg2

app = Flask(__name__)


@app.route("/")
def home():
    return "Hello from Docker!"


@app.route("/db")
def database():
    try:
        connection = psycopg2.connect(
            host="postgres",
            port=5432,
            database="appdb",
            user="appuser",
            password="apppassword",
        )
        connection.close()
        return "Database connection: OK"
    except Exception as e:
        return f"Database connection failed: {e}", 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)