from datetime import datetime, timedelta
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from pydantic.functional_validators import field_validator
import re

app = FastAPI()

class Deployment(BaseModel):
    event_timestamp: datetime = None # should look like 2024-03-12T14:29:46-0700
    hashes: list = None # each should match an sha1 hash format regex(\b[0-9a-f]{5,40}\b)
    timestamp_oldest_commit: datetime = None # should look like 2024-03-12T14:29:46-0700
    deploy_return_status: str = None # should be "Success", "Failure", or "Invalid"

    @field_validator("event_timestamp","timestamp_oldest_commit")
    def validate_datetime(cls, d):
        # oh lord jesus datetime validation
        date_text = str(d)
        iso8601_regex = r"^([\+-]?\d{4}(?!\d{2}\b))((-?)((0[1-9]|1[0-2])(\3([12]\d|0[1-9]|3[01]))?|W([0-4]\d|5[0-2])(-?[1-7])?|(00[1-9]|0[1-9]\d|[12]\d{2}|3([0-5]\d|6[1-6])))([T\s]((([01]\d|2[0-3])((:?)[0-5]\d)?|24\:?00)([\.,]\d+(?!:))?)?(\17[0-5]\d([\.,]\d+)?)?([zZ]|([\+-])([01]\d|2[0-3]):?([0-5]\d)?)?)?)?$"
        if re.match(iso8601_regex, date_text):
            return d
        else:
            raise ValueError(f"date must be in ISO-8601 format: {d}") 

    @field_validator("hashes")
    def validate_hashes(cls, hashes):
        if not len(hashes) > 0:
            raise ValueError(f"commit hash list cannot be empty")
        for h in hashes:
            if not re.match(r"\b[0-9a-f]{5,40}\b", h):
                raise ValueError(f"hash not valid sha1: {h}")
            else:
                return hashes

    @field_validator("deploy_return_status")
    def validate_return_status(cls, status):
        if status not in ["Success", "Failure", "Invalid"]:
            raise ValueError(f"return_status must be one of \"Success\", \"Failure\", or \"Invalid\": {status}")
        else:
            return status

class ServiceAvailabilityChange(BaseModel):
    event_timestamp: datetime # should look like 2024-03-12T14:29:46-0700
    service_id: str # practically arbitrary, but maybe useful for later
    event_type: str # should be "outage" or "restoration"

    @field_validator("event_type")
    def validate_balanced_events(cls,event_type):
        # since all inputs are validated one at a time, we can simplify the balancing logic
        # we can use a naive algorithm (count outages, count restorations) here because we validate each input one at a time
        
        stack = []
        for event in service_events:
            if event.event_type == "outage":
                stack.append(event)
            else:
                if not stack or (\
                    event.event_type == 'restoration' and \
                    stack[-1] != 'outage'\
                    ):
                    raise ValueError("no preceding outage for restoration event")
                stack.pop()

# please replace "store the dataset in an array in memory" before deploying
deployments = [] 
service_events = []

@app.post("/api/events/deployment")
def append_deployment(deployment: Deployment):
    deployments.append(deployment)
    return deployment

@app.post("/api/events/service_availability")
def append_service_availability(service_event: ServiceAvailabilityChange):
    service_events.append(service_event)
    return service_event

@app.get("/api/metrics/deployment_frequency")
def get_deployment_frequency():
    deploys_in_day = {}
    for deployment in deployments:
        if deployment.event_timestamp.date() in deploys_in_day:
            deploys_in_day[deployment.event_timestamp.date()] += 1
        else:
            deploys_in_day[deployment.event_timestamp.date()] = 1
    return len(deployments) / len(deploys_in_day)

@app.get("/api/metrics/lead_time_for_changes")
def get_lead_time_for_changes():
    time_deltas = []
    for deployment in deployments:
        time_delta = deployment.event_timestamp - deployment.timestamp_oldest_commit
        time_deltas.append(time_delta.seconds)
    lead_time_for_changes = sum(time_deltas) / len(time_deltas)
    return str(timedelta(seconds=lead_time_for_changes)) # standardize output format?

@app.get("/api/metrics/time_to_restore_service")
def get_time_to_restore_service():
    # check for balanced events (a preceding outage for each restoration)
    # for each balanced root-level event, get the time delta from first outage to final restoration
    # append time delta to array of time deltas
    # return average of time deltas array 
    
    

@app.get("/api/metrics/change_failure_rate")
def get_change_failure_rate():
    success_counter = 0
    failure_counter = 0
    for deployment in deployments:
        if deployment.deploy_return_status == "Invalid":
            pass
        elif deployment.deploy_return_status == "Success":
            success_counter += 1
        else:
            failure_counter += 1
    return failure_counter / (success_counter + failure_counter)
    
# @app.get("/api/metrics/vanity")
# def get_vanity():
