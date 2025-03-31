from __future__ import print_function
import datetime
import os.path
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

SCOPES = ['https://www.googleapis.com/auth/calendar']

def get_service():
    creds = None
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file('credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        with open('token.json', 'w') as token:
            token.write(creds.to_json())

    return build('calendar', 'v3', credentials=creds)

def crear_evento(suscripcion):
    service = get_service()
    calendar_id = 'c_612589ad6a405f90210e7409e88c3a7091c96728065eb88b007c382c1cacaade@group.calendar.google.com'

    evento = {
        'summary': f"Suscripción: {suscripcion.nombre}",
        'description': f"Proveedor: {suscripcion.proveedor}\nDepartamento: {suscripcion.departamento}\nComentarios: {suscripcion.comentarios}",
        'start': {
            'date': suscripcion.fecha_expiracion.strftime('%Y-%m-%d'),
            'timeZone': 'Europe/Madrid',
        },
        'end': {
            'date': suscripcion.fecha_expiracion.strftime('%Y-%m-%d'),
            'timeZone': 'Europe/Madrid',
        },
        'reminders': {
            'useDefault': False,
            'overrides': [
                {'method': 'email', 'minutes': 60 * 24 * 90},
                {'method': 'email', 'minutes': 60 * 24 * 30},
                {'method': 'email', 'minutes': 60 * 24 * 15},
            ],
        },
    }

    event = service.events().insert(calendarId=calendar_id, body=evento).execute()
    return event['id'], event['htmlLink']

def eliminar_evento(calendar_event_id):
    service = get_service()
    calendar_id = 'c_612589ad6a405f90210e7409e88c3a7091c96728065eb88b007c382c1cacaade@group.calendar.google.com'
    try:
        service.events().delete(calendarId=calendar_id, eventId=calendar_event_id).execute()
    except Exception as e:
        print(f"⚠️ No se pudo eliminar el evento: {e}")
