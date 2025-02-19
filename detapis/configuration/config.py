from pydantic_settings import BaseSettings
from typing import List

class Settings(BaseSettings):
    ROOT_PATH: str
    APP_NAME: str
    CLIENT_IP: str

    OPENAI_CHAT_API_KEY: str
    BACKEND_CORS_ORIGINS: List[str] = []

    class Config:
        case_sensitive = True
        from_attributes = True
        env_file = ".env"


settings = Settings()
