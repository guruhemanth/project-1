FROM python:3.11-slim

WORKDIR /app

# Copy the requirements file
COPY requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the actual Python application file into the container!
COPY hello.py /app/

EXPOSE 8000

CMD ["python", "hello.py"]
