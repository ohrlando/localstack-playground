import boto3
import json

state_machine_arn = "arn:aws:states:us-east-1:000000000000:stateMachine:sf-do-something"


def lambda_handler(event, context):
    stepfunctions_client = boto3.client('stepfunctions',
                                         aws_access_key_id='test',
                                         aws_secret_access_key='test',
                                         endpoint_url='http://localhost:4566',
                                         region="us-east-1")
    
    
    try:
        response = stepfunctions_client.start_sync_execution(
            stateMachineArn=state_machine_arn,
            input=json.dumps(event.get({"input"}) or {})
        )
        
        return {
            "statusCode": 200,
            "body": {
                "executionArn": response["executionArn"],
                "status": response["status"],
                "output": json.loads(response["output"]) if "output" in response else None
            }
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": {
                "error": str(e)
            }
        }
