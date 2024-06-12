from flask import Flask, jsonify
from datetime import datetime
import pytz

app = Flask(__name__)


@app.route('/')
def home():
    dt_mask = '%Y-%m-%d %H:%M:%S'

    ny_tz = pytz.timezone('America/New_York')
    berlin_tz = pytz.timezone('Europe/Berlin')
    tokyo_tz = pytz.timezone('Asia/Tokyo')

    current_time_utc = datetime.now(pytz.utc)
    ny_time = current_time_utc.astimezone(ny_tz).strftime(dt_mask)
    berlin_time = current_time_utc.astimezone(berlin_tz).strftime(dt_mask)
    tokyo_time = current_time_utc.astimezone(tokyo_tz).strftime(dt_mask)

    html_response = f"""
    <html>
    <head><title>World Clock</title></head>
    <body>
        <h1>Current Local Times</h1>
        <p>New York: {ny_time}</p>
        <p>Berlin: {berlin_time}</p>
        <p>Tokyo: {tokyo_time}</p>
    </body>
    </html>
    """
    return html_response


@app.route('/health')
def health():
    return jsonify(status="OK"), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
