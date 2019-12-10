from flask import Flask, render_template
import random

app = Flask(__name__)

# list of cat images
images = [
    "https://media.giphy.com/media/YQitE4YNQNahy/giphy.gif",
    "https://media.giphy.com/media/YQitE4YNQNahy/giphy.gif",
    "https://media.giphy.com/media/115BJle6N2Av0A/giphy.gif",
    "https://media.giphy.com/media/pOKrXLf9N5g76/giphy.gif",
    "https://media.giphy.com/media/26tPnAAJxXTvpLwJy/giphy.gif",
    "https://media.giphy.com/media/d31wIu3HgY048MKs/giphy.gif",
    "https://media.giphy.com/media/xULW8rv9NSbHaEe9Ak/giphy.gif",
    "https://media.giphy.com/media/lo5HLcAPFSgTZNTpAn/giphy.gif",
    "https://media.giphy.com/media/P5wPrhzZDdeJW/giphy.gif",
    "https://media.giphy.com/media/XEYDdISQybWq4/giphy.gif"
]

@app.route('/hacker')
def index():
    url = random.choice(images)
    return render_template('index.html', url=url)

@app.route('/health')
def health():
    return "OK"	

@app.route("/")
def cft_sympla():
    return app.send_static_file('sympla.html')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=6000)