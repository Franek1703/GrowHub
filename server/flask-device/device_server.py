from flask import Flask, render_template, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from datetime import datetime

app = Flask(__name__)


db_name = 'admin:admin@localhost:5432/pbl5DB'

# DB Connection
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://' + db_name
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True

db = SQLAlchemy(app)
migrate = Migrate(app,db)

class Device(db.Model):
    __tablename__ = 'devices'
    device_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    location = db.Column(db.String, nullable=True)
    created_at = db.Column(db.DateTime(), default=datetime.utcnow, index=True)
    users = db.relationship('User', secondary='user_device', back_populates='devices')
    
class User(db.Model):
    __tablename__ = 'users'
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, unique=True, nullable=False)
    email = db.Column(db.String, unique=True, nullable=False)
    password_hash = db.Column(db.String, nullable=False)
    created_at = db.Column(db.DateTime(), default=datetime.utcnow, index=True)
    devices = db.relationship('Device', secondary='user_device', back_populates='users')
# Association table for the many-to-many relationship between Users and Devices
user_device = db.Table('user_device',
    db.Column('user_id', db.Integer, db.ForeignKey('users.user_id'), primary_key=True),
    db.Column('device_id', db.Integer, db.ForeignKey('devices.device_id'), primary_key=True)
)

class Sensor(db.Model):
    __tablename__ = 'sensors'
    sensor_id = db.Column(db.Integer, primary_key=True)
    device_id = db.Column(db.Integer, db.ForeignKey('devices.device_id'), nullable=False)
    sensor_type = db.Column(db.String, nullable=False)
    unit = db.Column(db.String, nullable=True)
    created_at = db.Column(db.DateTime(), default=datetime.utcnow, index=True)
    min_value = db.Column(db.Float, nullable=True)
    max_value = db.Column(db.Float, nullable=True)
    measurement_frequency = db.Column(db.Integer, nullable=True)

class FertilizingDevice(db.Model):
    __tablename__ = 'fertilizing_devices'
    fertilizing_device_id = db.Column(db.Integer, primary_key=True)
    device_id = db.Column(db.Integer, db.ForeignKey('devices.device_id'), nullable=False)
    device_type = db.Column(db.String, default="pompa") 
    activation_time = db.Column(db.Integer, nullable=False) 
    
class SensorReading(db.Model):
    __tablename__ = 'sensors_readings'
    reading_id = db.Column(db.Integer, primary_key=True)
    sensor_id = db.Column(db.Integer, db.ForeignKey('sensors.sensor_id'), nullable=False)
    value = db.Column(db.Float, nullable=False)
    recorded_at = db.Column(db.DateTime(), default=datetime.utcnow, index=True)
    sensor_type = db.Column(db.String, db.ForeignKey('sensors.sensor_type'))
with app.app_context():
        db.create_all()

# Routes

@app.route('/add_reading', methods=['POST'])
def add_reading():
    data = request.get_json()
    sensor_id = data.get('sensor_id')
    value = data.get('value')
    recorded_at = data.get('recorded_at')
    sensor_type = data.get('sensor_type')

    if not sensor_id or value is None or not recorded_at or not sensor_type:
        return jsonify({'error': 'sensor_id, value, recorded_at, and sensor_type are required'}), 400

    sensor = Sensor.query.filter_by(sensor_id=sensor_id).first()
    if not sensor:
        return jsonify({'error': 'Sensor not found'}), 404

    new_reading = SensorReading(
        sensor_id=sensor_id,
        value=value,
        recorded_at=recorded_at,
        sensor_type=sensor_type
    )
    db.session.add(new_reading)
    db.session.commit()

    if sensor_type in ["TNS", "PH"] and (value < sensor.min_value or value > sensor.max_value):
        # Pobierz urządzenie nawożące związane z tym czujnikiem
        fertilizing_device = FertilizingDevice.query.filter_by(device_id=sensor.device_id).first()
        
        if fertilizing_device:
            return jsonify({
                'needs_fertilization': True,
                'activation_time': fertilizing_device.activation_time,
                'frequency': sensor.measurement_frequency
            })
        else:
            return jsonify({'error': 'No fertilizing device found for this sensor'}), 404

    return jsonify({
        'needs_fertilization': False,
        'frequency': sensor.measurement_frequency
    })

@app.route('/get_sensor_thresholds/<int:sensor_id>', methods=['GET'])
def get_sensor_thresholds(sensor_id):
    sensor = Sensor.query.get(sensor_id)
    if sensor:
        return jsonify({
            "min_value": sensor.min_value,
            "max_value": sensor.max_value
        })
    return jsonify({"error": "Sensor not found"}), 404

if __name__ == '__main__':  
    app.run(port=5001, debug=True)