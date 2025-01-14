from flask import Flask, request, jsonify
app = Flask(__name__)

@app.route('/')

def print_hi():
    return "<p>Hi, my name is HarmonyOS</p>"

if __name__ == '__main__':
    app.run(debug=True)