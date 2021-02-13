import os

def lambda_handler(event, context):
    return "{} World".format(os.environ['sayworld'])