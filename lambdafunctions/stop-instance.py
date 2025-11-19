import boto3
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    
    tag_key = os.getenv('TAG_KEY', 'AutoSchedule')
    tag_value = os.getenv('TAG_VALUE', 'true')
    
    try:
        response = ec2.describe_instances(
            Filters=[
                {'Name': f'tag:{tag_key}', 'Values': [tag_value]},
                {'Name': 'instance-state-name', 'Values': ['running']}
            ]
        )
        
        instances_to_stop = []
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                instances_to_stop.append(instance['InstanceId'])
        
        if instances_to_stop:
            ec2.stop_instances(InstanceIds=instances_to_stop)
            logger.info(f"Stopped {len(instances_to_stop)} instances: {instances_to_stop}")
            
        return {
            'statusCode': 200,
            'body': f'Successfully stopped {len(instances_to_stop)} instances'
        }
            
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': f'Error: {str(e)}'
        }