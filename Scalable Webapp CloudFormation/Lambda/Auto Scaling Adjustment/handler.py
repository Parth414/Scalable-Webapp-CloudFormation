import boto3

def lambda_handler(event, context):
    asg_client = boto3.client('autoscaling')
    asg_name = 'my-auto-scaling-group'

    response = asg_client.update_auto_scaling_group(
        AutoScalingGroupName=asg_name,
        MinSize=2,
        MaxSize=5,
        DesiredCapacity=3
    )

    return {
        "statusCode": 200,
        "body": f"Auto-scaling group {asg_name} updated successfully."
    }
