import json

def lambda_handler(event, context):
    print("Hello")
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
