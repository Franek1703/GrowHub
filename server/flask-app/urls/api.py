from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from flasgger import swag_from

from models import Alert, User, DosageHistory, SensorReading

api = Blueprint('api', __name__)

 # Get the user ID from the JWT token
def get_user_by_jwt():
    user_id = get_jwt_identity()
    user = User.query.get(user_id)
    return user

@api.route('/user-devices', methods=['GET'])
@jwt_required()
def get_user_devices():
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404

    devices = [{'device_id': d.device_id, 'name': d.name} for d in user.devices]
    return jsonify(devices=devices), 200


@api.route('/dosage-history/<int:device_id>', methods=['GET'])
@jwt_required()
def get_dosage_history(device_id):
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404

    dosages = DosageHistory.query.filter_by(device_id=device_id).all()
    dosage_list= [{"dose": d.dose, "dosed_at": d.dosed_at} for d in dosages]

    return jsonify(dosages=dosage_list), 200

@api.route('sensor-readings/<int:sensor_id>', methods=['GET'])
@jwt_required()
def get_sensor_reading(sensor_id):
    user = get_user_by_jwt()
    if not user:
        return jsonify({'message': 'User not found.'}), 404
    
    sensor_readings = SensorReading.query.filter_by(sensor_id=sensor_id).all()
    sensor_readings_list = [{"value": s.value, "recorded_at": s.recorded.at, "sensor_type": s.sensor_type} for s in sensor_readings]

    return jsonify(sensor_readings=sensor_readings_list), 200