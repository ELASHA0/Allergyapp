# allergy_backend/api.py
from flask import Flask, request, jsonify
from analyze import analyze_label
import os

app = Flask(__name__)

@app.route("/analyze", methods=["POST"])
def analyze():
    if 'image' not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    image = request.files['image']
    allergies = request.form.get('allergies', '')
    temp_path = "temp_image.jpg"
    image.save(temp_path)
    allergy_list = [a.strip() for a in allergies.split(',')] if allergies else []

    result = analyze_label(temp_path, allergy_list)
    return jsonify({"result": result}), 200

if __name__ == "__main__":
    app.run(debug=True, port=5000)
