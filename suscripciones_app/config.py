import os

class Config:
    SQLALCHEMY_DATABASE_URI = os.getenv("DATABASE_URL", "postgresql://postgres:Postgres123@localhost/suscripciones")
    SQLALCHEMY_TRACK_MODIFICATIONS = False
