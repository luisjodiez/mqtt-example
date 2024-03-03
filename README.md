# mqtt-example
This repository contains 3 main pieces:
- Reader logic (terraform code, python code, bundle zip)
- Consumer logic (python code, intended to run locally)
- Server logic (terraform code, python code, bundle zip)

## Workflow

The intention of this example is to feed the reader with a file. \
This file is to be ingested into a MQTT broker. \
For this purpose, I recommend creating a free account in **HiveMQ**. \
When the broker receives the data, a local consumer subscribed to the topic reads it. \
The consumer persists the data for further analysis into dynamodb. \
Then a aws lambda function with it's own url exposes two endpoints (/ and /metrics). \
Metrics endpoint shows error metrics, root endpoint shows a summary of the data consumed.

## Setup

The github actions workflow triggers a terraform apply on changes to main branch. \
To set up this project you would need a .env file containing the following vars:
- For HiveMQ
  - USERNAME
  - PASSWORD
  - BROKER
- For AWS
  - APIKEY
  - SECRETKEY
  - REGION

You will also need to define the following secrets in a github repo for the actions to work:
- TF_VAR_mqtt_username
- TF_VAR_mqtt_password
- TF_VAR_mqtt_broker
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

## Update

In order to change the code from the aws lambda, you need to update the zip bundle. \
The zip contains the python code, additional files and dependencies. \
Once the zip is prepared, you have to run this oneliner to get the hash:

```bash
sha256sum bundle.zip | cut -d ' ' -f 1 | xxd -r -p | base64
```

Then, update it in the terraform code and commit the changes. \
On push, the actions will update the lambda code.