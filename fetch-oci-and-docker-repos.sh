#!/bin/bash

echo ""
echo "artifactory_url=$artifactory_url"
echo ""

output_file=${1:-repositories.txt}

# Step 1: Fetch repository names
curl -G -H "Authorization: Bearer $token" "$artifactory_url/api/repositories/" | \
jq '.[] | select(.packageType == "Docker" or .packageType == "OCI") | .key' > "$output_file"

echo "Repository names fetched and saved to $output_file"
