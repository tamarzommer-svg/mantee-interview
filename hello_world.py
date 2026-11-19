from pathlib import Path

from flask import Flask, jsonify

app = Flask(__name__)
VERSION = (Path(__file__).parent / "VERSION").read_text().strip()


@app.get("/")
def hello():
    return "Hello, world!"


@app.get("/version")
def version():
    return jsonify(version=VERSION)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
