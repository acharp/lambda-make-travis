from __future__ import print_function
import json
import base64
import logging
import uuid
import traceback
import boto3


logger = logging.getLogger()
logger.setLevel(logging.INFO)

client = boto3.client('firehose')

print('Loading function')


def lambda_handler(event, context):
        try:
            events = unpack_kinesis_event(
                    event,
                    deserializer=json.loads)
            response = send_to_delivery_stream(
                    events,
                    'firehose-to-es-sandbox')
            print(response)
        except Exception as e:
            traceback.print_exc()


def unpack_kinesis_event(kinesis_event, deserializer=None,
                         embed_timestamp=False):
    """Extracts events (a list of dicts) from a Kinesis event."""
    records = kinesis_event["Records"]
    events = []
    for rec in records:
        payload = base64.decodestring(rec["kinesis"]["data"]).decode()
        if deserializer:
            try:
                payload = deserializer(payload)
            except ValueError:
                logger.error("Error deserializing Kinesis payload: {}".format(
                    payload))
                raise
        if isinstance(payload, dict) and embed_timestamp:
            payload["kinesis_timestamp"] = rec["kinesis"].get(
                "approximateArrivalTimestamp")
        events.append(payload)
    return events


def send_to_delivery_stream(events, stream_name):
    """Sends a list of events to a Firehose delivery stream."""
    records = []
    if stream_name is None:
        msg = "Must provide the name of the Kinesis stream: None provided"
        logger.error(msg)
        raise RequiresStreamNameError(msg)
    for event in events:
        if not isinstance(event, str):
            # csv events already have a newline
            event = json.dumps(event) + "\n"
        records.append({"Data": event})
    firehose = boto3.client("firehose")
    logger.info("Delivering {} records to Firehose stream '{}'".format(
        len(records), stream_name))
    resp = firehose.put_record_batch(
        DeliveryStreamName=stream_name,
        Records=records)
    return resp
