#!/bin/bash

# Check if the token and artifactory_url variables are set
if [ -z "$token" ] || [ -z "$artifactory_url" ]; then
    echo "Error: Both 'token' and 'artifactory_url' environment variables must be set."
    exit 1
fi

# Check if the repositories file argument is provided, otherwise default to 'repositories.txt'
if [ -n "$1" ]; then
    repositories_file="$1"
else
    repositories_file="repositories.txt"
fi

csvimageslistfile=$(mktemp --suffix=.csv)
echo "repo,path,sha256,created,modified,updated,stat_downloaded,properties" > $csvimageslistfile

echo ""
echo "results will be saved to: $csvimageslistfile"
echo ""

while IFS= read -r repo; do
    echo "Querying repository: $repo"
    output=$(curl -s -X POST -H "Authorization: Bearer $token" -H "Content-Type: text/plain" "$artifactory_url/api/search/aql" --data "items.find({\"repo\":{\"\$match\":\"$repo\"}}).include(\"repo\",\"path\",\"sha256\",\"created\",\"modified\",\"updated\",\"stat.downloaded\",\"property.*\")")
    json_output=$(echo "$output" | jq -c '.results[] | select(.properties != null and (.properties[] | select(.key == "docker.manifest.type" and .value == "application/vnd.oci.image.index.v1+json"))) | 
    {repo, path, sha256, created, modified, updated, stat_downloaded, properties: [.properties[] | select(.key == "docker.manifest") | {(.key): .value}]}')

    # Force remove the double quotes because jq --raw-output does not work when piping to CSV to remove double quotes
    echo "$json_output" | jq -r '[.repo, .path, .sha256, .created, .modified, .updated, .stat_downloaded, (.properties | map(.["docker.manifest"]) | join(";"))] | @csv' | awk '{gsub(/"/,"")};1' >> $csvimageslistfile
    
done < "$repositories_file"

echo "---------------------------------------------"
echo "CSV file with image data saved to: $csvimageslistfile"
