import json
from botocore.vendored import requests
from datetime import datetime
import dynamo_helper

TOKEN = 'XXX'
URL = "https://api.telegram.org/bot{}/".format(TOKEN)

def send_message(text, chat_id):
    final_text = "You said: " + text
    url = URL + "sendMessage?text={}&chat_id={}".format(final_text, chat_id)
    requests.get(url)

def lambda_handler(event, context):
    chat_id = event['message']['chat']['id']
    reply = event['message']['text']
    now = datetime.now()
    dynamo_helper.put_record(exp_summ=int(reply), datestamp=now.strftime("%d-%b-%Y"))

    send_message(reply, chat_id)
    return {
        'statusCode': 200
    }