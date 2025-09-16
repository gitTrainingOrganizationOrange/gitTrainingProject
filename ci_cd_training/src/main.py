from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
import logging
import sys
import os

# Configure comprehensive logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[
        logging.StreamHandler(sys.stdout),
    ],
)

logger = logging.getLogger(__name__)

# Create FastAPI app
app = FastAPI(
    title="CI/CD Training API",
    description="A simple FastAPI application for CI/CD training",
    version="1.0.0",
)

# Configure CORS
allowed_origins = os.getenv("ALLOWED_ORIGINS", "http://localhost:3000").split(",")
app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,  # Configurable via ALLOWED_ORIGINS env var
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["*"],
)

# Add trusted host middleware for security
allowed_hosts = os.getenv("ALLOWED_HOSTS", "localhost,127.0.0.1").split(",")
app.add_middleware(
    TrustedHostMiddleware,
    allowed_hosts=allowed_hosts,  # Configurable via ALLOWED_HOSTS env var
)


# Root endpoint
@app.get("/")
async def root():
    """Root endpoint that returns a welcome message."""
    logger.info("Root endpoint accessed")
    return {"message": "Welcome to CI/CD Training API"}


# Hello World endpoint
@app.get("/hello")
async def hello_world():
    """Hello World endpoint."""
    logger.info("Hello World endpoint accessed")
    return {"message": "Hello, World!"}


# Health check endpoint
@app.get("/health")
async def health_check():
    """Health check endpoint for monitoring."""
    return {"status": "healthy", "service": "ci-cd-training-api"}


# Version endpoint
@app.get("/version")
async def get_version():
    """Get API version from version.txt file."""
    try:
        version_file = os.path.join(os.path.dirname(__file__), "version.txt")
        with open(version_file, "r") as f:
            version = f.read().strip()
        return {"version": version}
    except Exception as e:
        logger.error(f"Error reading version file: {e}")
        return {"version": "unknown", "error": str(e)}


if __name__ == "__main__":
    import uvicorn

    # Get host and port from environment variables with secure defaults
    host = os.getenv("API_HOST", "127.0.0.1")  # Default to localhost for security
    port = int(os.getenv("API_PORT", "8000"))

    logger.info(f"Starting server on {host}:{port}")
    uvicorn.run(app, host=host, port=port)
