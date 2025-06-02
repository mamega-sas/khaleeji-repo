#!/bin/bash

SAS_HOST=sfdnp.khaleeji.bank
SAS_USERNAME=fraudsvc
SAS_PASSWORD='DAI)(*&09872025'
SAS_SCHEME=https
SAS_PORT=443
SAS_OUTPUT_CONFIG=/home/ds-fraud/config_export.zip

TOKEN=$(curl -skX POST https://sfdnp.khaleeji.bank/SASLogon/oauth/token \
-H "Content-Type: application/x-www-form-urlencoded" \
-H "Authorization: Basic c2FzLmNsaTo=" \
-H "Accept: application/json" \
-H "Content-Type: application/x-www-form-urlencoded" \
--data-urlencode "grant_type=password" \
--data-urlencode "username=fraudsvc" \
--data-urlencode "password=DAI)(*&09872025" | jq -r '.access_token')
	
curl -skX GET --url ${SAS_SCHEME}://${SAS_HOST}/alerts/config -H 'Content-type: application/zip' -H "Authorization: Bearer ${TOKEN}" -o ${SAS_OUTPUT_CONFIG}