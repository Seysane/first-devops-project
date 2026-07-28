import os
import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)

DB_HOST = os.environ.get("DB_HOST", "postgres-db")
DB_NAME = os.environ.get("DB_NAME", "devops_db")
DB_USER = os.environ.get("DB_USER", "devops_user")
DB_PASS = os.environ.get("DB_PASS", "devops_pass")

def get_db_connection():
    return psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )

@app.route("/")
def index():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("CREATE TABLE IF NOT EXISTS visits (id SERIAL PRIMARY KEY, visited_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);")
        cur.execute("INSERT INTO visits DEFAULT VALUES;")
        conn.commit()
        
        cur.execute("SELECT COUNT(*) FROM visits;")
        count = cur.fetchone()[0]
        
        cur.close()
        conn.close()
        
        return jsonify({
            "status": "success",
            "message": "Połączono pomyślnie z bazą danych PostgreSQL!",
            "total_visits": count
        })
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)