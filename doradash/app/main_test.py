from datetime import datetime
import json
import requests

valid_deployment = {
    "event_timestamp": str(datetime.now()),
    "hashes": ["d7d8937e8f169727852dea77bae30a8749fe21fc"],
    "oldest_commit_timestamp": str(datetime.now()),
    "deploy_return_status": "Success"
}

def test_valid_deployment():
    #payload = 
    endpoint = "http://127.0.0.1:8000/api/events/deployment"
    response = requests.post(endpoint, json=json.dumps(valid_deployment))
    print(response)
    print(valid_deployment)
    #assert response.status_code == 200