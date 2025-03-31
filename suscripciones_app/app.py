from flask import Flask, render_template, request, redirect, url_for, session
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from models import db, Suscripcion
from google_calendar import crear_evento, eliminar_evento
import smtplib
from email.mime.text import MIMEText

app = Flask(__name__)
app.secret_key = 'tu_clave_secreta_segura'

# ✅ Configuración base de datos PostgreSQL con contraseña 1234
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:1234@localhost:5432/suscripciones_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

# ✅ Lista de usuarios válidos
usuarios_validos = {
    "Compras": "Compras",
    "Finanzas": "Finanzas",
    "IT": "IT"
}

# ✅ Función para enviar correo
def enviar_correo(nombre, proveedor, fecha, creado_por):
    asunto = "📅 Nueva suscripción registrada"
    mensaje = f"""Se ha registrado una nueva suscripción:

🔹 Nombre: {nombre}
🔹 Proveedor: {proveedor}
🔹 Fecha de expiración: {fecha}
🔹 Departamento: {creado_por}

📅 Puedes ver la cita en el calendario:
https://calendar.google.com/calendar/u/0/r?cid=c_612589ad6a405f90210e7409e88c3a7091c96728065eb88b007c382c1cacaade@group.calendar.google.com
"""

    msg = MIMEText(mensaje)
    msg['Subject'] = asunto
    msg['From'] = "mario.villaverde@marco.agency"
    msg['To'] = "mario.villaverde@marco.agency"

    try:
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
            smtp.login("mario.villaverde@marco.agency", "gqtc gfqt unno ksyy")
            smtp.send_message(msg)
    except Exception as e:
        print(f"Error al enviar el correo: {e}")

# ✅ Página principal con formulario + tabla
@app.route('/', methods=['GET', 'POST'])
def formulario():
    if request.method == 'POST':
        nombre = request.form['nombre']
        proveedor = request.form['proveedor']
        fecha_expiracion = datetime.strptime(request.form['fecha'], '%Y-%m-%d').date()
        departamento = request.form['departamento']
        comentarios = request.form.get('comentarios', '')

        creado_por = session.get('usuario') if 'usuario' in session else departamento

        nueva_suscripcion = Suscripcion(
            nombre=nombre,
            proveedor=proveedor,
            fecha_expiracion=fecha_expiracion,
            departamento=departamento,
            comentarios=comentarios,
            creado_por=creado_por
        )

        db.session.add(nueva_suscripcion)
        db.session.commit()

        # Crear evento en Google Calendar
        event_id = crear_evento(nueva_suscripcion)
        nueva_suscripcion.calendar_event_id = event_id
        db.session.commit()

        # Enviar correo
        enviar_correo(nombre, proveedor, fecha_expiracion, creado_por)

        return redirect(url_for('formulario'))

    suscripciones = Suscripcion.query.order_by(Suscripcion.fecha_expiracion).all()
    return render_template('formulario.html', suscripciones=suscripciones, usuario=session.get('usuario'))

# ✅ Ruta para eliminar suscripción
@app.route('/eliminar/<int:id>', methods=['GET'])
def eliminar(id):
    suscripcion = Suscripcion.query.get_or_404(id)

    if 'usuario' not in session or session['usuario'] != suscripcion.creado_por or session['usuario'] != "Compras":
        return redirect(url_for('formulario'))

    # Eliminar evento de Google Calendar
    if suscripcion.calendar_event_id:
        eliminar_evento(suscripcion.calendar_event_id)

    db.session.delete(suscripcion)
    db.session.commit()
    return redirect(url_for('formulario'))

# ✅ Login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        usuario = request.form['usuario']
        clave = request.form['clave']

        if usuario in usuarios_validos and usuarios_validos[usuario] == clave:
            session['usuario'] = usuario
            return redirect(url_for('formulario'))
        else:
            return render_template('login.html', error='Credenciales inválidas')

    return render_template('login.html')

# ✅ Logout
@app.route('/logout')
def logout():
    session.pop('usuario', None)
    return redirect(url_for('formulario'))

# ✅ Página de calendario pública
@app.route('/calendario')
def calendario():
    return render_template('calendario.html')

# ✅ Inicializar BD
with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run()
