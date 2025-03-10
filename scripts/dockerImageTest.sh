#!/bin/bash
while getopts t:d: flag; do
    case "${flag}" in
    t) DATE="${OPTARG}" ;;
    d) DRIVER="${OPTARG}" ;;
    *) echo "Invalid option" ;;
    esac
done

echo "Testing latest Open Liberty Docker image"

sed -i "\#<artifactId>liberty-maven-plugin</artifactId>#a<configuration><install><runtimeUrl>https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/$DATE/$DRIVER</runtimeUrl></install></configuration>" inventory/pom.xml system/pom.xml
cat inventory/pom.xml system/pom.xml

sed -i "s;FROM icr.io/appcafe/open-liberty:full-java11-openj9-ubi;FROM openliberty/daily:latest;g" inventory/Dockerfile system/Dockerfile
cat inventory/Dockerfile system/Dockerfile

docker pull "openliberty/daily:latest"

sudo ../scripts/testApp.sh
