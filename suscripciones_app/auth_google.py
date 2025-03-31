from __future__ import print_function
import os.path
from google_auth_oauthlib.flow import InstalledAppFlow
from google.oauth2.credentials import Credentials

SCOPES = ['https://www.googleapis.com/auth/calendar']

def autorizar_google_calendar():
    flow = InstalledAppFlow.from_client_secrets_file(
        'credentials.json', SCOPES)
    creds = flow.run_local_server(port=0)

    with open('token.json', 'w') as token:
        token.write(creds.to_json())

    print("✅ Autorización completada. Se ha creado 'token.json'")

if __name__ == '__main__':
    autorizar_google_calendar()