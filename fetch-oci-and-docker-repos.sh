#!/bin/bash


output_file=${1:-repositories.txt}

# Step 1: Fetch repository names
reponames=$(curl -s -X POST -H "Authorization: Bearer $token" -H "Content-Type: text/plain" "https://cgrdemo.jfrog.io/artifactory/api/search/aql" --data 'items.find().include("repo")' | jq -r '.results[].repo')

echo ""
echo "The following repo names have been save to $output_file:"
echo ""
echo "$reponames" > $output_file
echo "$reponames"
