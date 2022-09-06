#!/bin/bash

# Exit if any of the intermediate steps fail
#set -e

# Extract "foo" and "baz" arguments from the input into
# FOO and BAZ shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
#eval "$(jq -r '@sh "FOO=\(.foo) BAZ=\(.baz)"')"

# Placeholder for whatever data-fetching logic your script implements
az rest --method get --uri '/subscriptions/2ca65474-3b7b-40f2-b242-0d2fba4bde6e/resourceGroups/example-rg/providers/Microsoft.ContainerRegistry/registries/asfkhsafkasdfsda?api-version=2022-02-01-preview'
#SUCCESS=$?
#echo $SUCCESS

if [ $SUCCESS -eq 0 ]; then
  query_success=1;
else
  query_success=0;
fi

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg query_success "$query_success" '{"query_success":$query_success}'