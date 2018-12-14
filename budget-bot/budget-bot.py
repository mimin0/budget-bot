import json
from botocore.vendored import requests
import datetime
import dynamo_helper

TOKEN = 'XXX'
URL = "https://api.telegram.org/bot{}/".format(TOKEN)
date_format = "%Y-%m-%d"

def send_message(text, chat_id):
    url = URL + "sendMessage?text={}&chat_id={}".format(text, chat_id)
    requests.get(url)

def lambda_handler(event, context):
    print(event)
    reply_message = ''
    chat_id = event['message']['chat']['id']
    message_data = event['message']['text']
    message_data_split = message_data.rsplit()
    now = datetime.datetime.now()
    if message_data_split[0] == '/add':
        ## /add Fun 50 Beer
        dynamo_helper.put_record(exp_category=message_data_split[1], exp_summ=message_data_split[2],
                                datestamp=now.strftime(date_format), exp_description=message_data_split[3])
        
        reply_message = "[DONE]\nCategory: {}\nSumm: {}\nDescription: {}\n".format(message_data_split[1],
                                message_data_split[2],message_data_split[3])

    elif message_data_split[0] == '/show_today':
        ## /show_today
        get_data = dynamo_helper.get_records(datestamp=now.strftime(date_format))
        for record in get_data:
            reply_message += "{} \t {} \t {} \t {}\n".format(record["operationDate"], record["operationSumm"],
                                        record["operationCatigory"], record["operationDescription"])
    elif message_data_split[0] == '/show_week':
        ## /show_week
        records_from_time = datetime.datetime.now() - datetime.timedelta(days=7)
        get_data = dynamo_helper.get_records(datestamp=records_from_time.strftime(date_format))
        for record in get_data:
            reply_message += "{} \t {} \t {} \t {}\n".format(record["operationDate"], record["operationSumm"],
                                        record["operationCatigory"], record["operationDescription"])

    else:
        reply_message = "bad command or format...\n use\n \t/add [Fun] [50] [Beer]\nor\n \t/show_today\n \t/show_week"

    send_message(reply_message, chat_id)
    return {
        'statusCode': 200
    }