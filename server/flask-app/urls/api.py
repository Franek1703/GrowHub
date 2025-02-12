from flask import Blueprint, jsonify, request, redirect
from flask_jwt_extended import jwt_required, get_jwt_identity
from flasgger import swag_from
from sqlalchemy import desc, and_, asc
from datetime import datetime

from models import User, DosageHistory, SensorReading, Sensor, db, Device, FertilizingDevice, Alert

api = Blueprint('api', __name__)

 # Get the user ID from the JWT token
def get_user_by_jwt():
    user_id = get_jwt_identity()
    user = User.query.get(user_id)
    return user

#Redirect from homepage to docs
@api.route('/')
def docs_redirect():
    return redirect('/apidocs')

@api.errorhandler(404)
def page_not_found(e):
    return jsonify({"error": "Page not found"}), 404

@api.route('/configuration', methods = ['GET'])
@jwt_required()
@swag_from('../swagger_templates/get_configuration.yml')
def get_app_configuration():
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found'}), 400
    
    devices = [device.to_dict() for device in user.devices]

    fertilizing_devices = []
    device_sensors_map = {}

    for device in devices:
        # Query sensors for the current device
        device_sensors = Sensor.query.filter_by(device_id=device["device_id"]).all()
        
        device_sensors_dict = []


        # Add last sensor reading to sensor, {} if null
        for sensor in device_sensors:
            sensor_dict = sensor.to_dict() 
            sensor_reading = SensorReading.query.filter(
            and_(
                SensorReading.sensor_id == sensor_dict["sensor_id"],
                SensorReading.recorded_at.isnot(None)
            )
            ).order_by(desc(SensorReading.recorded_at)).first()
            

            if not sensor_reading:
                sensor_reading = {}
            else:
                sensor_reading = sensor_reading.to_dict()

            sensor_dict.update({"last_reading": sensor_reading})

            device_sensors_dict.append(sensor_dict)


        
        device_sensors_map[device["device_id"]] = [sensor for sensor in device_sensors_dict]
        
        # Also query fertilizing devices
        fertilizing_devices.extend(FertilizingDevice.query.filter_by(device_id=device["device_id"]).all())

    # Add the sensors to the devices by updating the devices list
    for device in devices:
        device["sensors"] = device_sensors_map.get(device["device_id"], [])

    # Prepare fertilizing devices (as before)
    fertilizing_devices = [fertilizing_device.to_dict() for fertilizing_device in fertilizing_devices]

    # Remove devices from user_dict to avoid duplication
    user_dict = user.to_dict()
    user_dict.pop("devices", None)

    return jsonify({
        "user": user_dict,
        "devices": devices,
        "fertilizing_devices": fertilizing_devices,
    }), 200


# Get user's owned devices
@api.route('/user-devices', methods=['GET'])
@jwt_required()
@swag_from('../swagger_templates/get_user_devices.yml')
def get_user_devices():
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 400

    devices = [{'device_id': d.device_id, 'name': d.name} for d in user.devices]
    return jsonify(devices=devices), 200

# Add new user-device relation, which means add new user's device 
@api.route('/user-devices', methods=['POST'])
@jwt_required()
@swag_from('../swagger_templates/add_user_device.yml')
def add_user_device():
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 400

    data = request.get_json()

    device_id = data.get('device_id')
    
    if not device_id:
        return jsonify({"message", "Field device_id has to be provided."}), 400
    
    device = Device.query.filter_by(device_id=device_id).first()

    if not device:
        return jsonify({"message": f"There is no device with id = {device_id}"}), 400

    
    if device in user.devices:
        return jsonify({"message": "Device is already associated with the user."}), 400
    
    user.devices.append(device)
    db.session.commit()

    return jsonify({"message":"Device added successfully"}), 200

# Add new user-device relation using ssid
@api.route('/user-devices/ssid', methods=['POST'])
@jwt_required()
@swag_from('../swagger_templates/add_user_device_ssid.yml')
def add_user_device_by_ssid():
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 400

    data = request.get_json()

    ssid = data.get('ssid')
    
    if not ssid:
        return jsonify({"message": "Field ssid has to be provided."}), 400
    
    device = Device.query.filter_by(ssid=ssid).first()

    if not device:
        return jsonify({"message": f"There is no device with ssid = {ssid}"}), 400

    if device in user.devices:
        return jsonify({"message": "Device is already associated with the user."}), 400
    
    user.devices.append(device)
    db.session.commit()

    return jsonify({"message": "Device added successfully"}), 200

# Remove user-device relation using JSON payload
@api.route('/user-devices', methods=['DELETE'])
@jwt_required()
@swag_from('../swagger_templates/remove_user_device.yml')
def remove_user_device():
    # Pobranie użytkownika na podstawie JWT
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404

    # Pobranie danych z żądania JSON
    data = request.get_json()
    device_id = data.get('device_id')

    # Walidacja obecności pola device_id
    if not device_id:
        return jsonify({"message": "Field device_id has to be provided."}), 400

    # Pobranie urządzenia na podstawie podanego device_id
    device = Device.query.filter_by(device_id=device_id).first()
    if not device:
        return jsonify({"message": f"There is no device with id = {device_id}"}), 404

    # Sprawdzenie, czy urządzenie jest przypisane do użytkownika
    if device not in user.devices:
        return jsonify({"message": "Device is not associated with the user."}), 400

    # Usunięcie urządzenia z relacji użytkownika
    user.devices.remove(device)
    db.session.commit()

    return jsonify({"message": "Device removed successfully."}), 200

@api.route('/user/change-profile', methods=['PATCH'])
@jwt_required()
@swag_from('../swagger_templates/change_user_profile.yml')
def change_profile():
    # Get current user's identity from the JWT
    user = get_user_by_jwt()
    if not user:
        return jsonify({"message": "User not found."}), 404
    
    data = request.get_json()

    # Extract the new data (email and password)
    new_email = data.get('email')
    new_password = data.get('password')

    # Check if the email or password is provided, or both
    if not new_email and not new_password:
        return jsonify({"message": "Either email or password must be provided."}), 400
    

    if new_email == user.email:
        return jsonify({"message": "New email can't be the same as the previous one."}), 400

    if user.check_password(new_password):
        return jsonify({"message": "New password can't be the same as the previous one."}), 400

    # Check if the new email is already taken
    if new_email:
        existing_user = User.query.filter_by(email=new_email).first()
        if existing_user:
            return jsonify({"message": "Email is already in use."}), 400
        user.email = new_email  # Update the email
    
    # If password is provided, hash and update it
    if new_password:
        user.set_password(new_password)

    # Commit the changes to the database
    db.session.commit()

    return jsonify({"message": "Profile updated successfully."}), 200

@api.route('user/info', methods=['GET'])
@jwt_required()
@swag_from('../swagger_templates/user_info.yml')
def get_user_info():
    user = get_user_by_jwt()

    if not user:
        return jsonify({"message": "User not found."}), 404
    
    return jsonify(user.to_dict()), 200
    


# User's sensors that are connected with the particular device
@api.route('/sensors/<int:device_id>', methods=['GET'])
@jwt_required()
@swag_from('../swagger_templates/get_user_sensors.yml')
def get_user_sensors(device_id):
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404

    sensors = Sensor.query.filter_by(device_id=device_id).all()

    sensors_list = [s.to_dict() for s in sensors]
    return jsonify(sensors=sensors_list), 200

# Dosage history that is connected with the particular device user owns
@api.route('/dosage-history/<int:device_id>', methods=['GET'])
@jwt_required()
@swag_from('../swagger_templates/get_dosage_history.yml')
def get_dosage_history(device_id):
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404

    dosages = DosageHistory.query.filter_by(device_id=device_id).all()
    dosage_list= [{"dose": d.dose, "dosed_at": d.dosed_at} for d in dosages]

    return jsonify(dosages=dosage_list), 200

@api.route('sensor-readings/<int:device_id>', methods=['GET'])
@jwt_required()
@swag_from('../swagger_templates/get_sensor_readings.yml')
def get_sensor_reading(device_id):
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404

    is_last_reading = request.args.get('last_reading', 'false').lower() in ['true', '1']
    
    # Get all sensors for the device
    sensors = Sensor.query.filter_by(device_id=device_id).all()

    sensor_readings_grouped = []

    for sensor in sensors:
        if is_last_reading:
            # Fetch the latest reading for the sensor
            sensor_reading = SensorReading.query.filter(
                SensorReading.sensor_id == sensor.sensor_id,
                SensorReading.recorded_at.isnot(None)
            ).order_by(desc(SensorReading.recorded_at)).first()

            # Build the sensor object with the last reading
            sensor_dict = sensor.to_dict()
            sensor_dict["readings"] = [sensor_reading.to_dict()] if sensor_reading else []
        else:
            # Fetch all readings for the sensor
            sensor_readings = SensorReading.query.filter_by(sensor_id=sensor.sensor_id).order_by(asc(SensorReading.recorded_at)).all()

            # Build the sensor object with all readings
            sensor_dict = sensor.to_dict()
            sensor_dict["readings"] = [reading.to_dict() for reading in sensor_readings]

        sensor_readings_grouped.append(sensor_dict)

    return jsonify({"sensor_readings": sensor_readings_grouped}), 200

# Updating values (min, max, measurement frequency) of the user's particular sensor
@api.route('sensor-values/<int:sensor_id>', methods = ["PATCH"])
@jwt_required()
@swag_from('../swagger_templates/set_sensor_values.yml')
def set_sensor_values(sensor_id):
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404
    
    if not request.is_json:
        return jsonify({'message': 'Request body must be JSON.'}), 400
    
    sensor = Sensor.query.get(sensor_id)
    if not sensor:
        return jsonify({'message': 'Sensor not found.'}), 404

    data = request.get_json()

    min_value = data.get('min_value')
    max_value = data.get('max_value')
    measurement_frequency = data.get('measurement_frequency')

    if min_value:
        sensor.min_value = min_value

    if max_value:
        sensor.max_value = max_value

    if measurement_frequency:
        sensor.measurement_frequency = measurement_frequency
    
    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        return jsonify({'message': 'Error saving to the database.', 'error': str(e)}), 500
    
    return jsonify({"sensor_id": sensor_id,
                    "min_value": sensor.min_value,
                    "max_value": sensor.max_value,
                    "measurement_frequency": sensor.measurement_frequency
    }), 200
    
# Endpoint to update device name and location
@api.route('/devices/<int:device_id>', methods=['PATCH'])
@jwt_required()
@swag_from('../swagger_templates/update_devices.yml')
def update_device(device_id):
    
    user = get_user_by_jwt()
    if not user:
        return jsonify({"message": "User not found."}), 404
    
    data = request.get_json()
    
    name = data.get('name')
    location = data.get('location')
    icon = data.get('icon')

    
    if not name and not location and not icon:
        return jsonify({"message": "Name or location or icon must be provided."}), 400
    
    device = Device.query.filter_by(device_id=device_id).first()
    if not device:
        return jsonify({"message": "Device not found."}), 404

    if name:
        device.name = name
    if location:
        device.location = location
    if icon:
        device.icon = icon
    db.session.commit()

    return jsonify({"message": "Device updated successfully."}), 200

@api.route('/alerts', methods=['GET'])
@jwt_required()
def get_user_alerts():
    """
    Get all alerts for the current user, including device and sensor names.
    """
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404

    devices = user.devices
    alerts_list = []

    for device in devices:
        sensors = Sensor.query.filter_by(device_id=device.device_id).all()
        for sensor in sensors:
            alerts = Alert.query.filter_by(sensor_id=sensor.sensor_id).order_by(desc(Alert.created_at)).limit(100).all()
            for alert in alerts:
                alert_dict = alert.to_dict()
                alert_dict['device_name'] = device.name
                alert_dict['sensor_name'] = sensor.sensor_type
                alerts_list.append(alert_dict)

    # Sort the alerts_list by created_at in descending order and limit to 100
    alerts_list = sorted(alerts_list, key=lambda x: x['created_at'], reverse=True)[:100]

    return jsonify(alerts=alerts_list), 200

@api.route('/alerts/<int:alert_id>/resolve', methods=['PATCH'])
@jwt_required()
def resolve_alert(alert_id):
    """
    Mark an alert as resolved by its ID.
    """
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404

    alert = Alert.query.get(alert_id)
    if not alert:
        return jsonify({'message': 'Alert not found.'}), 404

    alert.resolved = True
    alert.resolved_at = datetime.utcnow()
    db.session.commit()

    return jsonify({'message': 'Alert marked as resolved.'}), 200

@api.route('/alerts/<int:alert_id>', methods=['DELETE'])
@jwt_required()
def delete_alert(alert_id):
    """
    Delete an alert by its ID.
    """
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404

    alert = Alert.query.get(alert_id)
    if not alert:
        return jsonify({'message': 'Alert not found.'}), 404

    db.session.delete(alert)
    db.session.commit()

    return jsonify({'message': 'Alert deleted successfully.'}), 200

@api.route('/fertilizing-devices/<int:device_id>', methods = ['PATCH'])
@jwt_required()
def update_fertilizing_device_activation_time(device_id):
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404
    
    if not request.is_json:
        return jsonify({'message': 'Request body must be JSON.'}), 400
    
    data = request.get_json()


    activation_time = data.get('activation_time')


    if activation_time is None:
        return jsonify({"message": "Activation time must provided."}), 400

    fertilizing_device = FertilizingDevice.query.filter_by(device_id = device_id).first()
    if not fertilizing_device:
        return jsonify({'message': 'Device not found.'}), 404
    
    if not isinstance(activation_time, int):
        return jsonify({'message': 'Activation time must be an integer.'}), 400
    
    if activation_time < 1 or activation_time > 5:
        return jsonify({'message': 'Activation time must be between 1-5'}), 400
    
    
    fertilizing_device.activation_time =activation_time

    db.session.commit()

    return jsonify({"message": "Device activation time updated successfully."}), 200
    