from flask import Flask, render_template, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from datetime import datetime, timedelta
from alert_enum import AlertMessages

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
    
class Alert(db.Model):
    __tablename__ = 'alerts'
    alert_id = db.Column(db.Integer, primary_key=True)
    sensor_id = db.Column(db.Integer, db.ForeignKey('sensors.sensor_id'), nullable=False)
    value = db.Column(db.Float, nullable=False)
    alert_time = db.Column(db.DateTime(), default=datetime.utcnow, index=True)
    message = db.Column(db.String, nullable=False)
    resolved = db.Column(db.Boolean, default=False)
    resolved_at = db.Column(db.DateTime(), index=True)
    
    
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
            resolved_at = datetime.utcnow() + timedelta(seconds=sensor.activation_time)
            
        elif sensor_type.lower() == "TNS".lower():
            alert_message = AlertMessages.TNS_LOW.value
            needs_fertilization = True
            resolved = True
            resolved_at = datetime.utcnow() + timedelta(seconds=sensor.activation_time)
            
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
            response['activation_time'] = sensor.activation_time
        else:
            return jsonify({'error': 'No fertilizing device found for this sensor'}), 404
        
    return jsonify(response)

if __name__ == '__main__':  
    app.run(port=5001, debug=True)