from flask import Blueprint, jsonify, request
from models import db, Alert, Device, DosageHistory, Sensor, FertilizingDevice, SensorReading
from datetime import datetime
from alert_enum import AlertMessages
from device_default_values import DefaultValues
from flasgger import swag_from

# Tworzenie blueprinta
api = Blueprint('api', __name__)

# Routes

@api.route('/add_reading', methods=['POST'])
@swag_from('swagger_templates/add_reading.yml')
def add_reading():
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

@api.route('/add_new/device', methods=['POST'])
@swag_from('swagger_templates/add_device.yml')
def add_device():
    
    data = request.get_json()
    ssid = data.get('ssid')
    device_name = data.get('device_name')
    location = data.get('location', '')

    # Check if device exists
    existing_device = Device.query.filter_by(ssid=ssid).first()
    if existing_device:
        return jsonify({"message": "Device with this SSID already exists.", "device_id": existing_device.device_id}), 400

    # Add new device
    new_device = Device(device_name=device_name, location=location, ssid=ssid)
    db.session.add(new_device)
    db.session.commit()

    return jsonify({"message": "Device added successfully.", "device_id": new_device.device_id}), 201

# Endpoint to add a new sensor
@api.route('/add_new/sensor', methods=['POST'])
@swag_from('swagger_templates/add_sensor.yml')
def add_sensor():
    data = request.get_json()
    device_id = data.get('device_id')
    sensor_type = data.get('sensor_type')

    # Check if the specified type of sensor already exists for the given device
    existing_sensor = Sensor.query.filter_by(device_id=device_id, sensor_type=sensor_type).first()
    if existing_sensor:
        return jsonify({"message": f"Sensor of type '{sensor_type}' already exists for device_id '{device_id}'."}), 400

    new_sensor = Sensor(device_id=device_id, sensor_type=sensor_type, min_value=DefaultValues.get_min(sensor_type.lower()), max_value=DefaultValues.get_max(sensor_type.lower()), frequency=DefaultValues.SENSOR_FREQUENCY)
    db.session.add(new_sensor)
    db.session.commit()
    return jsonify({"message": "Sensor added successfully.", "sensor_id": new_sensor.sensor_id}), 201

# Endpoint to add a new fertilizing device
@api.route('/add_new/fertilizing_device', methods=['POST'])
@swag_from('swagger_templates/add_fertilizing_device.yml')
def add_fertilizing_device():
    data = request.get_json()
    device_id = data.get('device_id')
    device_type = data.get('device_type', 'Pump')  # Default device type is 'Pump'

    # Check if a fertilizing device of this type already exists for the specified device
    existing_fertilizing_device = FertilizingDevice.query.filter_by(device_id=device_id, device_type=device_type).first()
    if existing_fertilizing_device:
        return jsonify({"message": f"Fertilizing device of type '{device_type}' already exists for device_id '{device_id}'."}), 400

    new_fertilizing_device = FertilizingDevice(device_id=device_id, device_type=device_type, activation_time=DefaultValues.ACTIVATION_TIME)
    db.session.add(new_fertilizing_device)
    db.session.commit()
    return jsonify({"message": "Fertilizing device added successfully.", "fertilizing_device_id": new_fertilizing_device.fertilizing_device_id}), 201

@api.route('/add_dosage', methods=['POST'])
@swag_from('swagger_templates/add_dosage.yml')
def add_dosage():
    data = request.get_json()
    device_id = data.get('device_id')
    dose = data.get('dose')

    if not device_id or dose is None:
        return jsonify({"message": "Both 'device_id' and 'dose' are required."}), 400

    new_dosage = DosageHistory(device_id=device_id, dose=dose, dosed_at=datetime.utcnow())
    db.session.add(new_dosage)
    db.session.commit()

    return jsonify({
        "message": "Dosage history record added successfully."}), 201