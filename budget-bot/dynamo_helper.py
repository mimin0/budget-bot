from __future__ import print_function # Python 2/3 compatibility
import boto3
import json
import decimal
import secrets


# Helper class to convert a DynamoDB item to JSON.
class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            if abs(o) % 1 > 0:
                return float(o)
            else:
                return int(o)
        return super(DecimalEncoder, self).default(o)

def db_connector():
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('budgetBot')
    return table

def put_record(datestamp="", exp_category=None, exp_summ='15', exp_description=None):
    table = db_connector()
    recordId = secrets.token_urlsafe(8)
    response = table.put_item(
    Item={
            'recordId': recordId,
            'operationDate': datestamp,
            'operationCatigory': exp_category,
            'operationSumm': exp_summ,
            'operationDescription': exp_description
        }
    )
    print("PutItem succeeded:")
    print(json.dumps(response, indent=4, cls=DecimalEncoder))

def get_records(datestamp):
    responce_data = []
    table = db_connector()
    response = table.scan()
    for item in response['Items']:
        if item['operationDate'] >= datestamp:
            responce_data.append(item)
    
    return responce_data

    print("GetItem succeeded:")