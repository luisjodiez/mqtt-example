# Use the official Python 3.12 image as the base image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy the consumer.py file to the working directory
COPY consumer.py .

# Install the required Python modules
RUN pip install --no-cache-dir boto3 paho-mqtt==1.5.1 python-dotenv

# Set the entrypoint to run the consumer.py file
ENTRYPOINT ["python", "consumer.py"]
