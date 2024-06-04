# Design doc for API

Stuff we're gonna need:

- GET for each of the four metrics, plus most recent "rating".
- POST for data-generating events: deployment, outage/restoration. 

Given that this service relies on having data *pushed* to it, we can only ever return metrics based on the most recent deployment or outage/restoration event. 

So with that in mind, we have the following design for each of our endpoints:

| Method | Description | Endpoint | Request Payload | Response Payload |
|:------:|:-----------:|:--------:|:---------------:|:----------------:|
|    GET | Get deployment frequency | /api/metrics/deployment_frequency | - | {"TIMESTAMP", "COUNT", "UNIT"} |
|    GET | Get lead time for changes | /api/metrics/lead_time_for_changes | - | {"TIMESTAMP", "COMPUTED_TIME"} |
|    GET | Get time to restore service | /api/metrics/time_to_restore_service | - | {"TIMESTAMP", "COMPUTED_TIME"} | 
|    GET | Get change failure rate | /api/metrics/change_failure_rate | - | {"TIMESTAMP", "RATE"} |
|    GET | Get current rating | /api/metrics/vanity | - | {"TIMESTAMP", "RATING"} |
|   POST | Post new deployment event | /api/events/deployment | {"TIMESTAMP", "{INCLUDED_GIT_HASHES}", "OLDEST_COMMIT_TIMESTAMP", "DEPLOY_RETURN_STATUS"} | OK |
|   POST | Post new service availability change event | /api/events/service_availability | {"TIMESTAMP", "SERVICE_ID", "EVENT_TYPE"} |

### Notes
- As-is, this API leaves no room for versioning, publisher IDs, or meaningful correlation between deployments and service availability changes.
- As-is, we have no identification, authentication, or authorization systems. 
- As-is, we have no way to view the dataset from which the values are calculated. 