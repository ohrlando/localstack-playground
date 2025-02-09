import time
import logging


logger = logging.getLogger("test-lambda")
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    time.sleep(.6)

    logger.info(f"start event", extra={"event": event, "context": context})
    
    return {
        "statusCode": 200,
        "body": "Sucesso"
    }   
