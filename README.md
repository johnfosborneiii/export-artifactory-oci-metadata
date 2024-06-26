# Artifactory Repository Metadata Retrieval

This repository contains scripts to export Docker/OCI image metadata from JFrog Artifactory

## Prerequisites

**API Token**: Obtain an API token with appropriate permissions to access Artifactory resources.

## Setup

```bash
# Clone the repository
git clone https://github.com/johnfosborneiii/export-jfrog-images
cd export-jfrog-images
```

### Generate repo list to query

#### Edit the fetch-oci-and-docker-repos.sh file with your API Token and Artifactory URL
```bash
token="YOUR_AUTH_TOKEN_HERE"
artifactory_url="https://foo.jfrog.io/artifactory"
```

#### Save the file and give the script execute permissions and then run it
```bash
chmod +x fetch-oci-and-docker-repos.sh
./fetch_repositories.sh repositories.txt
```
#### Manually inspect repo list and remove any repositories that you do not wish to query

### Generate CSV

#### Edit the generate-repo-csv.sh file with your API Token and Artifactory URL
```bash
token="YOUR_AUTH_TOKEN_HERE"
artifactory_url="https://foo.jfrog.io/artifactory"
```
#### Save the file and give the script execute permissions and then run it
```bash
chmod +x generate-repo-csv.sh
./generate-repo-csv.sh
```


