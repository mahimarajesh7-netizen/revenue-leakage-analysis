 import os
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

def get_engine():
    """
    Returns a SQLAlchemy engine using credentials from .env file.
    
    Usage in any notebook:
        import sys
        sys.path.append("../src")
        from db_connection import get_engine
        engine = get_engine()
    """
    user     = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    host     = os.getenv("DB_HOST")
    port     = os.getenv("DB_PORT")
    db       = os.getenv("DB_NAME")

    print(f"✓ Connecting to: {host}:{port}/{db}")
    return create_engine(f"postgresql://{user}:{password}@{host}:{port}/{db}")
