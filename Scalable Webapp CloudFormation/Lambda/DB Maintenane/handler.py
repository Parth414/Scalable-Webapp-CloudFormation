import boto3

def lambda_handler(event, context):
    rds_client = boto3.client('rds')
    db_instance_id = 'mydb-instance'

    # Snapshot database
    snapshot_id = f"{db_instance_id}-snapshot"
    response = rds_client.create_db_snapshot(
        DBSnapshotIdentifier=snapshot_id,
        DBInstanceIdentifier=db_instance_id
    )

    return {
        "statusCode": 200,
        "body": f"Snapshot {snapshot_id} created successfully."
    }
