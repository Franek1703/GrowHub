from flask import Flask, render_template, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from models import db
from config import Config
from urls.auth import auth
from urls.api import api
from flask_jwt_extended import JWTManager

app = Flask(__name__)

app.config.from_object(Config)
db.init_app(app)

jwt = JWTManager(app)

app.register_blueprint(auth, url_prefix="/auth")
app.register_blueprint(api, url_prefix="/api")

with app.app_context():
    db.create_all() 

if __name__ == '__main__': 
    app.run(port=5000, debug=True)