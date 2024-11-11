from flask import Flask, render_template, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from models import db
from config import Config
from urls.auth import auth
from urls.api import api
from flask_jwt_extended import JWTManager
from flasgger import Swagger

app = Flask(__name__)

app.config.from_object(Config)
db.init_app(app)

jwt = JWTManager(app)

swagger = Swagger(app, template={
    "info": {
        "title": "User API - monitoring smart devices",
        "description": "API for user management, checking sensor readings and managing alerts in a device network.",
        "version": "1.0.0"
    }
})


app.register_blueprint(auth, url_prefix="/auth")
app.register_blueprint(api, url_prefix="/api")

with app.app_context():
    db.create_all() 

if __name__ == '__main__': 
    app.run(port=5000, debug=True)