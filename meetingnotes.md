Akshaya was invited to the meeting.

 
docker volume create deploymentdevagent
 
docker run -d \

  -e AZP_URL="https://dev.azure.com/YOURORG" \

  -e AZP_TOKEN="YOUR_PAT" \

  -e AZP_POOL="deploymentdevagent" \

  -v deploymentdevagent:/azp \

  --name deploymentdevagent \

  mcr.microsoft.com/azure-pipelines/vsts-agent:ubuntu-22.04
 
https://copilot.microsoft.com/conversations/join/vtwqQDKwtTwVRB2UY845E
Join "Undoing a Git Commit and Unstaging Changes" group with Copilot
Join group conversation with Copilot
 
docker compose -f docker-compose.yml up -d
 
docker compose up -d
 
docker login -u itsupportsingamtech
 
password removed
 
LABEL version="1.0"

LABEL release-notes="docker image for running azure devops deployment agent inside a container"

LABEL maintainer="itsupportsingamtech"
LABEL lastupdated="Akshaya Thirisangu"
 
Singam Tech Inc
 
Singam Tech Inc
Singam Tech Inc
Singam Tech Inc has 21 repositories available. Follow their code on GitHub.
 
 
https://github.com/Singam-Tech-Inc/
 
just download and extract the file content, change config.sh content to remove "sudo" context and save it in the image file; run config and persistence during container runtime
 
todolists folder-> todo.1.0.spec.md (from yesterday)
todo.2.0.md
: docker, volume, secrets, image, container, builds, models;
docker extensions;
extension1: docker compose: 
 docker compose build, run, exec, up, down, services, docker-compose yaml key words
docker hub: docker pull , docker push
 
 
also remove "sudo" in the config.sh or run.sh file
 
change Dockerfile to Dockerfile.ARM64, and create Dockerfile for x86 
 
so basically using ubuntu image has removed lib compatibility naming issue, and just replacing only the download file name is the only change, can this be merged to one single file, detect the host OS ENV and download it accordingly
 
args:

        TARGETARCH: ${TARGETARCH}

 
${VERSION}-${TARGETARCH}
 
export TARGETARCH=arm64

export VERSION=1.0

docker compose build
 
export TARGETARCH=arm64

export VERSION=1.0

docker compose build
 
export TARGETARCH=amd64

export VERSION=1.0

docker compose build
 
create a shell script to run build script for both architecture, and optionally to push both images, docker-compose up -d should pickup the correct architecture based on the host and if the image is available 
 
what is the docker push command to explicitly push to docker hub org itsupportsingamtech?
 
 
https://hub.docker.com/r/itsupportsingamtech/azdevopsdeploymentagent
itsupportsingamtech/azdevopsdeploymentagent - Docker Image
 
https://github.com/Singam-Tech-Inc/azuredevopsdeployagent/
GitHub - Singam-Tech-Inc/azuredevopsdeployagent: Azure DevOps Deployment Agent for Environments to Run inside a  linux container does not exists publicly. This repo fills that gap. It can run in bo...
Azure DevOps Deployment Agent for Environments to Run inside a  linux container does not exists publicly. This repo fills that gap. It can run in both ARM and AMD - Singam-Tech-Inc/azuredevopsdeplo...
 
todolists folder-> todo.1.0.spec.md (from yesterday)
todo.2.0.md
: docker, volume, secrets, image, container, builds, models;
docker extensions;
extension1: docker compose: 
 docker compose build, run, exec, up, down, services, docker-compose yaml key words
docker hub: docker pull , docker push
 
fork the repo azuredevopsdeployagent, create a new branch, and add the sh files, docker compose, Dockerfile only;
and send a Pull Request to the source repo (aka from where you cloned)
 
Install Python latest build 3.13 or above available from brew or where available to install on your mac
 
