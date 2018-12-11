import json
from botocore.vendored import requests

TOKEN = 'XXX'
URL = "https://api.telegram.org/bot{}/".format(TOKEN)

def send_message(text, chat_id):
    final_text = "You said: " + text
    url = URL + "sendMessage?text={}&chat_id={}".format(final_text, chat_id)
    requests.get(url)

def db_connector():
    exit

def add_record(record):
    

def lambda_handler(event, context):
    chat_id = event['message']['chat']['id']
    reply = event['message']['text']
    send_message(reply, chat_id)
    return {
        'statusCode': 200
    }