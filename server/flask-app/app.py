from flask import Flask, render_template, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

app = Flask(__name__)


db_name = 'admin:admin@localhost:5432/pbl5DB'

# DB Connection
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://' + db_name
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True

db = SQLAlchemy(app)

class User(db.Model):
    __tablename__ = 'users'
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, unique=True, nullable=False)
    email = db.Column(db.String, unique=True, nullable=False)
    password_hash = db.Column(db.String, nullable=False)
    created_at = db.Column(db.DateTime(), default=datetime.utcnow, index=True)

class Alert(db.Model):
    __tablename__ = 'alerts'
    alert_id = db.Column(db.Integer, primary_key=True)
    sensor_id = db.Column(db.Integer, db.ForeignKey('sensors.sensor_id'), nullable=False)
    value = db.Column(db.Float, nullable=False)
    alert_time = db.Column(db.DateTime(), default=datetime.utcnow, index=True)
    message = db.Column(db.String, nullable=False)
    resolved = db.Column(db.Boolean, default=False)
    resolved_at = db.Column(db.DateTime(), index=True)
    
class DosageHistory(db.Model):
    __tablename__ = 'dosage_history'
    device_id = db.Column(db.Integer, db.ForeignKey('devices.device_id'), primary_key=True)
    dose = db.Column(db.Float, nullable=False)
    dosed_at = db.Column(db.DateTime(), default=datetime.utcnow, index=True)

class Device(db.Model):
    __tablename__ = 'devices'
    device_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    location = db.Column(db.String, nullable=True)
    created_at = db.Column(db.DateTime(), default=datetime.utcnow, index=True)
class Sensor(db.Model):
    __tablename__ = 'sensors'
    sensor_id = db.Column(db.Integer, primary_key=True)
    device_id = db.Column(db.Integer, db.ForeignKey('devices.device_id'), nullable=False)
    sensor_type = db.Column(db.String, nullable=False)
    unit = db.Column(db.String, nullable=True)
    created_at = db.Column(db.DateTime(), default=datetime.utcnow, index=True)
    min_value = db.Column(db.Float, nullable=True)
    max_value = db.Column(db.Float, nullable=True)
# Create the database and tables if they don't exist
with app.app_context():
    db.create_all() 
@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__': 
    app.run(debug=True)