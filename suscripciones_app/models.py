from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

class Suscripcion(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(120), nullable=False)
    proveedor = db.Column(db.String(120), nullable=False)
    fecha_expiracion = db.Column(db.Date, nullable=False)
    departamento = db.Column(db.String(50), nullable=False)
    comentarios = db.Column(db.Text)
    fecha_creacion = db.Column(db.DateTime, default=datetime.utcnow)
    calendar_event_id = db.Column(db.String(256))  # ➜ NUEVA COLUMNA
    creado_por = db.Column(db.String(50))          # ➜ NUEVO CAMPO
