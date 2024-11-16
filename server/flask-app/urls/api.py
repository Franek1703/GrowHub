from flask import Blueprint, jsonify, request, redirect
from flask_jwt_extended import jwt_required, get_jwt_identity
from flasgger import swag_from
from sqlalchemy import desc, and_, asc

from models import Alert, User, DosageHistory, SensorReading, Sensor, db

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

# User's owned devices
@api.route('/user-devices', methods=['GET'])
@jwt_required()
@swag_from('../swagger_templates/get_user_devices.yml')
def get_user_devices():
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 400

    devices = [{'device_id': d.device_id, 'name': d.name} for d in user.devices]
    return jsonify(devices=devices), 200

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

# Sensor readings that are connected with the particular sensor user owns
@api.route('sensor-readings/<int:sensor_id>', methods=['GET'])
@jwt_required()
@swag_from('../swagger_templates/get_sensor_readings.yml')

def get_sensor_reading(sensor_id):
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404
    
    is_last_reading = request.args.get('last_reading', 'false').lower() in ['true', '1']
    
    if is_last_reading:
        # Exclude readings where recorded_at is NULL
        sensor_reading = SensorReading.query.filter(
            and_(
                SensorReading.sensor_id == sensor_id,
                SensorReading.recorded_at.isnot(None)
            )
        ).order_by(desc(SensorReading.recorded_at)).first()
        
        if sensor_reading:
            sensor_reading_dict = {
                "value": sensor_reading.value,
                "recorded_at": sensor_reading.recorded_at,
                "sensor_type": sensor_reading.sensor_type
            }
            return jsonify(sensor_reading=sensor_reading_dict), 200
        else:
            return jsonify({"message": "No valid sensor readings found."}), 404
    else:
        # Exclude readings where recorded_at is NULL
        sensor_readings = SensorReading.query.filter_by(sensor_id=sensor_id).order_by(asc(SensorReading.recorded_at)).all()
        
        sensor_readings_list = [{
            "value": s.value,
            "recorded_at": s.recorded_at,
            "sensor_type": s.sensor_type
        } for s in sensor_readings]

        return jsonify(sensor_readings=sensor_readings_list), 200

# Updating values (min, max, measurement frequency) of the user's particular sensor
@api.route('sensor-values/<int:sensor_id>', methods = ["PUT"])
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


    if min_value is not None:
        sensor.min_value = min_value

    if max_value is not None:
        sensor.max_value = max_value

    if measurement_frequency is not None:
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
    

