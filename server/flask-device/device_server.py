from flask import Flask
from flasgger import Swagger
from config import Config
from models import db
from endpoints import api

app = Flask(__name__)
app.config.from_object(Config)
db.init_app(app)

# Inicjalizacja Swagger
swagger = Swagger(app, template={
    "info": {
        "title": "Device Monitoring API",
        "description": "API for monitoring sensor readings and managing alerts in a device network.",
        "version": "1.0.0"
    }
})

# Rejestracja blueprinta
app.register_blueprint(api, url_prefix='/device-service-api')

# Tworzenie bazy danych przy starcie aplikacji
with app.app_context():
    db.create_all()

if __name__ == '__main__':  
    app.run(port=5001, debug=True)