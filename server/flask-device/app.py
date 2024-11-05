from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)


db_name = 'admin:admin@localhost:5432/pbl5DB'

# DB Connection
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://' + db_name
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True

db = SQLAlchemy(app)

class Device(db.Model):
    __tablename__ = 'devices'
    device_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    location = db.Column(db.String, nullable=True)
    created_at = db.Column(db.String)
    users = db.relationship('User', secondary='user_device', back_populates='devices')
class User(db.Model):
    __tablename__ = 'users'
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, unique=True, nullable=False)
    email = db.Column(db.String, unique=True, nullable=False)
    password_hash = db.Column(db.String, nullable=False)
    created_at = db.Column(db.String)
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
    created_at = db.Column(db.String)
    min_value = db.Column(db.Float, nullable=True)
    max_value = db.Column(db.Float, nullable=True)
with app.app_context():
        db.create_all()

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':  
    app.run(port=5001, debug=True)