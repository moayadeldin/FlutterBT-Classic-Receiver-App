from flask import Flask, jsonify
from flask_cors import CORS
import serial
from serial.serialutil import SerialException

app = Flask(__name__)
CORS(app)
numbers_received = []

# Setup the serial connection with the HC-05 device
try:
    ser = serial.Serial('COM3', 38400)
    ser.flushInput()
except SerialException as e:
    print(f"Failed to connect to the serial port: {e}")
    ser = None

@app.route('/random_number', methods=['GET'])
def read_from_bluetooth():
    if ser:
        try:
            # Read the number sent as string and then convert it to int
            line = ser.readline().decode('utf-8').strip() 
            numbers_received.append(line)
            return jsonify({'random_number': int(line)})
        except SerialException as e:
            return jsonify({'error': 'Error reading from the serial port'})
    else:
        return jsonify({'error': 'Serial port not connected'})

if __name__ == '__main__':
    try:
        app.run(host='0.0.0.0', port=5000, debug=False)
    finally:
        # Close the serial connection at the end
        if ser and ser.is_open:
            ser.close()
