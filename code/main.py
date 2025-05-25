from flask import Flask, jsonify
import requests

def create_app():
    app = Flask(__name__)

    @app.route("/", methods=["GET"])
    def home():
        return jsonify(message="Hello World Test123"), 200

    @app.route("/healthz", methods=["GET"])
    def health_check():
        """Health check endpoint for monitoring"""
        return jsonify(status="OK"), 200

    return app

# Entry point
if __name__ == "__main__":
    app = create_app()
    app.run(host="0.0.0.0", port=3000)
