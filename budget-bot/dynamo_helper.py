from __future__ import print_function # Python 2/3 compatibility
import boto3
import json
import decimal

# Helper class to convert a DynamoDB item to JSON.
class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            if abs(o) % 1 > 0:
                return float(o)
            else:
                return int(o)
        return super(DecimalEncoder, self).default(o)

dynamodb = boto3.resource('dynamodb')

table = dynamodb.Table('budgetBot')

recordId = "rf34r4tg6dt7"
datestamp = "22/01/2018"

response = table.put_item(
   Item={
        'recordId': recordId,
        'operationDate': datestamp,
        'operationCatigory': "Fun",
        'operationSumm': 10
    }
)

def put_record(datestamp="23/01/2018", exp_category=None, exp_summ=15, exp_description=None):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('budgetBot')

    recordId = "mf3rjh6g6dt34"

    response = table.put_item(
    Item={
            'recordId': recordId,
            'operationDate': datestamp,
            'operationCatigory': "Fun",
            'operationSumm': exp_summ
        }
    )
    print("PutItem succeeded:")
    print(json.dumps(response, indent=4, cls=DecimalEncoder))