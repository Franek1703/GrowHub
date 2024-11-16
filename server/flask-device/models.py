from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()


class Device(db.Model):
    __tablename__ = 'devices'
    device_id = db.Column(db.Integer, primary_key=True)
    ssid = db.Column(db.String, nullable=False)
    name = db.Column(db.String, nullable=False)
    location = db.Column(db.String, nullable=True)
    created_at = db.Column(db.DateTime(), default=datetime.utcnow, index=True)
    users = db.relationship('User', secondary='user_device', back_populates='devices')
    
class User(db.Model):
    __tablename__ = 'users'
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable=False)
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
    device_type = db.Column(db.String, default="Pump") 
    activation_time = db.Column(db.Integer, nullable=False) 
    
class SensorReading(db.Model):
    __tablename__ = 'sensors_readings'
    reading_id = db.Column(db.Integer, primary_key=True)
    sensor_id = db.Column(db.Integer, db.ForeignKey('sensors.sensor_id'), nullable=False)
    value = db.Column(db.Float, nullable=False)
    recorded_at = db.Column(db.DateTime(), default=datetime.utcnow, index=True)
    sensor_type = db.Column(db.String)
    
class Alert(db.Model):
    __tablename__ = 'alerts'
    alert_id = db.Column(db.Integer, primary_key=True)
    sensor_id = db.Column(db.Integer, db.ForeignKey('sensors.sensor_id'), nullable=False)
    value = db.Column(db.Float, nullable=True)
    alert_time = db.Column(db.DateTime(), default=datetime.utcnow, index=True)
    message = db.Column(db.String, nullable=False)
    resolved = db.Column(db.Boolean, default=False)
    resolved_at = db.Column(db.DateTime(), index=True)

class DosageHistory(db.Model):
    __tablename__ = 'dosage_history'
    dosage_history_id = db.Column(db.Integer, primary_key=True)
    device_id = db.Column(db.Integer, db.ForeignKey('devices.device_id'), nullable=False)
    dose = db.Column(db.Float, nullable=False)
    dosed_at = db.Column(db.DateTime(), default=datetime.utcnow, index=True)

