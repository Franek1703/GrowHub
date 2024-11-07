from flask import Blueprint, jsonify, request
from models import db, Alert, Device, User, Sensor, FertilizingDevice, SensorReading
from datetime import datetime, timedelta
from alert_enum import AlertMessages

# Tworzenie blueprinta
api = Blueprint('api', __name__)

# Routes

@api.route('/add_reading', methods=['POST'])
def add_reading():
    """
    Add a new sensor reading
    ---
    tags:
        - Sensor Readings
    description: Add a new sensor reading to the database and check if fertilization is needed.
    parameters:
      - name: sensor_id
        in: body
        type: integer
        required: true
        description: ID of the sensor
      - name: value
        in: body
        type: float
        required: true
        description: Value of the sensor reading
      - name: recorded_at
        in: body
        type: string
        required: true
        description: Timestamp when the reading was recorded (ISO format)
      - name: sensor_type
        in: body
        type: string
        required: true
        description: Type of the sensor (e.g., PH, TNS, Temperature)
    responses:
        200:
            description: Successful response with fertilization status and frequency
            schema:
                type: object
                properties:
                    needs_fertilization:
                        type: boolean
                        description: Indicates if fertilization is needed
                    frequency:
                        type: integer
                        description: Frequency of the sensor readings
                    activation_time:
                        type: integer
                        description: Duration of fertilization (if needed)
            examples:
                application/json: {
                    "needs_fertilization": true,
                    "frequency": 60,
                    "activation_time": 120
                }
        400:
            description: Missing or invalid parameters
            examples:
                application/json: {
                    "error": "sensor_id, value, recorded_at, and sensor_type are required"
                }
        404:
            description: Sensor not found or sensor_type mismatch
            examples:
                application/json: {
                    "error": "Sensor not found or sensor_type mismatch"
                }
        406:
            description: No fertilizing device found for this sensor
            examples:
                application/json: {
                    "error": "No fertilizing device found for this sensor"
                }
    """
    data = request.get_json()
    sensor_id = data.get('sensor_id')
    value = data.get('value')
    recorded_at = data.get('recorded_at')
    sensor_type = data.get('sensor_type')

    if not sensor_id or value is None or not recorded_at or not sensor_type:
        return jsonify({'error': 'sensor_id, value, recorded_at, and sensor_type are required'}), 400

    sensor = Sensor.query.filter_by(sensor_id=sensor_id, sensor_type=sensor_type).first()
    if not sensor:
        return jsonify({'error': 'Sensor not found or sensor_type mismatch'}), 404

    new_reading = SensorReading(
        sensor_id=sensor_id,
        value=value,
        recorded_at=recorded_at,
        sensor_type=sensor_type
    )
    db.session.add(new_reading)

    alert_message = None
    needs_fertilization = False
    resolved = False
    resolved_at = None

    if value < sensor.min_value:
        if sensor_type.lower() == "PH".lower():
            alert_message = AlertMessages.PH_LOW.value
            needs_fertilization = True
            resolved = True
            resolved_at = datetime.utcnow()
            
        elif sensor_type.lower() == "TNS".lower():
            alert_message = AlertMessages.TNS_LOW.value
            needs_fertilization = True
            resolved = True
            resolved_at = datetime.utcnow()
            
        elif sensor_type.lower() == "Temperature".lower():
            alert_message = AlertMessages.TEMP_LOW.value
            
    elif value > sensor.max_value:
        if sensor_type.lower() == "PH".lower():
            alert_message = AlertMessages.PH_HIGH.value
            
        elif sensor_type.lower() == "TNS".lower():
            alert_message = AlertMessages.TNS_HIGH.value
            
        elif sensor_type.lower() == "Temperature".lower():
            alert_message = AlertMessages.TEMP_HIGH.value

    if alert_message:
        alert = Alert(
            sensor_id=sensor_id,
            value=value,
            alert_time=datetime.utcnow(),
            message=alert_message,
            resolved=resolved,
            resolved_at=resolved_at
        )
        db.session.add(alert)

    db.session.commit()

    response = {
        'needs_fertilization': needs_fertilization,
        'frequency': sensor.measurement_frequency
    }
    
    fertilizing_device = FertilizingDevice.query.filter_by(device_id=sensor.device_id).first()

    if needs_fertilization:
        if fertilizing_device:
            response['activation_time'] = fertilizing_device.activation_time
        else:
            return jsonify({'error': 'No fertilizing device found for this sensor'}), 406
        
    return jsonify(response)