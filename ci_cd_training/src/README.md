# CI/CD Training API

A simple FastAPI application designed for CI/CD training and demonstration purposes.

## Overview

This project is a lightweight REST API built with FastAPI that provides basic endpoints for testing CI/CD pipelines, health monitoring, and versioning.

## Features

- **FastAPI Framework**: Modern, fast web framework for building APIs
- **Auto-generated API Documentation**: Interactive API docs at `/docs`
- **Health Check Endpoint**: For monitoring and load balancer configuration
- **Version Management**: Dynamic version reading from `version.txt`
- **CORS Support**: Configured for cross-origin requests
- **Comprehensive Logging**: Structured logging for debugging and monitoring

## Requirements

- Python 3.8 or higher
- pip (Python package manager)

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd ci_cd_training/src
```

2. Create a virtual environment (recommended):
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

## Running the Application

### Development Mode

Run the application using uvicorn:

```bash
uvicorn main:app --reload
```

Or run directly with Python:

```bash
python main.py
```

The API will be available at `http://localhost:8000`

### Production Mode

For production, use environment variables to configure the application:

```bash
# Set environment variables
export API_HOST=0.0.0.0  # For container/cloud deployments
export API_PORT=8000
export ALLOWED_ORIGINS=https://yourdomain.com,https://api.yourdomain.com
export ALLOWED_HOSTS=yourdomain.com,api.yourdomain.com

# Run with uvicorn
uvicorn main:app --host $API_HOST --port $API_PORT --workers 4
```

Or run directly with Python (it will use the environment variables):

```bash
python main.py
```

## API Endpoints

### 1. Root Endpoint
- **URL**: `/`
- **Method**: GET
- **Description**: Welcome message
- **Response**:
```json
{
  "message": "Welcome to CI/CD Training API"
}
```

### 2. Hello World
- **URL**: `/hello`
- **Method**: GET
- **Description**: Classic Hello World endpoint
- **Response**:
```json
{
  "message": "Hello, World!"
}
```

### 3. Health Check
- **URL**: `/health`
- **Method**: GET
- **Description**: Health status for monitoring
- **Response**:
```json
{
  "status": "healthy",
  "service": "ci-cd-training-api"
}
```

### 4. Version
- **URL**: `/version`
- **Method**: GET
- **Description**: Returns the API version from `version.txt`
- **Response**:
```json
{
  "version": "1.0.0"
}
```

## API Documentation

FastAPI automatically generates interactive API documentation:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Project Structure

```
ci_cd_training/
└── src/
    ├── main.py           # Main application file
    ├── requirements.txt  # Python dependencies
    ├── version.txt      # Version information
    └── README.md        # This file
```

## Development

### Adding New Endpoints

To add a new endpoint, simply add a new function with the appropriate decorator in `main.py`:

```python
@app.get("/your-endpoint")
async def your_function():
    return {"message": "Your response"}
```

### Updating Version

To update the API version, modify the `version.txt` file:

```bash
echo "1.1.0" > version.txt
```

## CI/CD Integration

This application is designed to work with CI/CD pipelines. Key features for CI/CD:

1. **Health Check**: Use `/health` for container/service health monitoring
2. **Version Endpoint**: Track deployed versions using `/version`
3. **Logging**: Structured logging for debugging in different environments
4. **Docker Ready**: Can be easily containerized with the following Dockerfile:

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Use environment variables for configuration
ENV API_HOST=0.0.0.0
ENV API_PORT=8000

# Run the application using the Python script which respects env vars
CMD ["python", "main.py"]
```

## Testing

To test the API endpoints:

```bash
# Test root endpoint
curl http://localhost:8000/

# Test hello endpoint
curl http://localhost:8000/hello

# Test health check
curl http://localhost:8000/health

# Test version
curl http://localhost:8000/version
```

## Environment Variables

The application supports the following environment variables for configuration:

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `API_HOST` | Host address to bind the server | `127.0.0.1` | `0.0.0.0` (for containers) |
| `API_PORT` | Port number for the server | `8000` | `8080` |
| `ALLOWED_ORIGINS` | Comma-separated list of allowed CORS origins | `http://localhost:3000` | `https://app.example.com,https://www.example.com` |
| `ALLOWED_HOSTS` | Comma-separated list of allowed host headers | `localhost,127.0.0.1` | `example.com,www.example.com` |

### Docker Configuration Example

```bash
docker run -d \
  -e API_HOST=0.0.0.0 \
  -e API_PORT=8000 \
  -e ALLOWED_ORIGINS=https://myapp.com \
  -e ALLOWED_HOSTS=myapp.com,api.myapp.com \
  -p 8000:8000 \
  myapp:latest
```

## Security Notes

✅ **Security Improvements**: The application now uses secure defaults:

1. **Host Binding**: Defaults to `127.0.0.1` (localhost only) instead of `0.0.0.0`
2. **CORS Origins**: Configurable via `ALLOWED_ORIGINS` environment variable
3. **Trusted Hosts**: Configurable via `ALLOWED_HOSTS` environment variable
4. **No Wildcards**: No more wildcard (`*`) configurations by default

⚠️ **For Production**:
1. Always use HTTPS
2. Set specific allowed origins and hosts
3. Use strong authentication if needed
4. Keep dependencies updated

## License

This project is created for training purposes.
