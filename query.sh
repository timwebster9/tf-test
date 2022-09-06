#!/bin/bash

# Exit if any of the intermediate steps fail
#set -e

# Extract arguments from the input into shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "RESOURCE_ID=\(.resource_id)"')"

# store the result of the query in a variable so it doesn't get added to stdout,
# or else it will be included in the JSON output for the data source
RESULT=$(az rest --method get --uri $RESOURCE_ID)

if [ $? -eq 0 ]; then
  query_success=1;
else
  query_success=0;
fi

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.

# TODO: ensure no other output is included (is there a way to 'clear' stdout?)
jq -n --arg query_success "$query_success" '{"query_success":$query_success}'