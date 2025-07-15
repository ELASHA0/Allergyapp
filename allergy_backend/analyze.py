
import base64
import os
from dotenv import load_dotenv
from together import Together

load_dotenv()
api_key = os.getenv("TOGETHER_API_KEY")

if not api_key:
    raise Exception("API key not found in .env file!")

client = Together(api_key=api_key)

def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode("utf-8")

def analyze_label(image_path, user_allergies=[]):
    base64_image = encode_image(image_path)
    allergy_info = ", ".join(user_allergies) if user_allergies else "none provided"

    prompt = f"""
You are an AI allergen detector.
Given an image of a food product label, extract the *ingredients* and identify any ingredients that may pose an allergy risk to this user.

User Allergy Profile: {allergy_info}

Return the following format:
1. Extracted Ingredients (as a list)
2. Detected Allergens (with ingredient triggers)
3. Risk Level: Low/Moderate/High
4. Recommendation
"""

    response = client.chat.completions.create(
        model="meta-llama/Llama-Vision-Free",
        messages=[
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": prompt},
                    {"type": "image_url", "image_url": {"url": f"data:image/jpeg;base64,{base64_image}"}}
                ]
            }
        ],
        stream=True
    )

    result = ""
    for token in response:
        if hasattr(token, 'choices') and token.choices and hasattr(token.choices[0].delta, 'content'):
            result += token.choices[0].delta.content or ""
    return result

