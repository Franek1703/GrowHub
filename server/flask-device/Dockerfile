# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy the entire project into the container at /app
COPY . /app


# Change to the specific folder containing your Flask app
WORKDIR /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that the Flask app will run on
EXPOSE 5001

# Define environment variables
ENV FLASK_APP=device_server.py
ENV FLASK_RUN_PORT=5001

# Run the Flask app
CMD ["python", "device_server.py"]
