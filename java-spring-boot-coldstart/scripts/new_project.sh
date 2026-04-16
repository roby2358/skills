#!/usr/bin/env bash
# Generate a Spring Boot project via start.spring.io with team defaults baked in.
# Usage: new_project.sh <artifact-id> [group-id] [output-dir]
#   artifact-id  required, e.g. "orders-api"
#   group-id     optional, defaults to "com.example"
#   output-dir   optional, defaults to current directory
set -euo pipefail

ARTIFACT="${1:?artifact-id required, e.g. 'orders-api'}"
GROUP="${2:-com.example}"
OUT="${3:-.}"

# Pinned Spring Boot version. Bump deliberately — verify dependency compatibility.
BOOT_VERSION="3.3.5"

# Starters: web (REST), validation (Bean Validation), security (auth/authz),
# oauth2-resource-server (JWT), actuator (health/metrics), configuration-processor
# (IDE hints for @ConfigurationProperties), testcontainers (integration tests).
# SQS comes from spring-cloud-aws — added after generation, see SKILL.md.
DEPS="web,validation,security,oauth2-resource-server,actuator,configuration-processor,testcontainers"

ZIP="$(mktemp --suffix=.zip)"
trap 'rm -f "$ZIP"' EXIT

curl -fsSL "https://start.spring.io/starter.zip" \
    -d "type=maven-project" \
    -d "language=java" \
    -d "javaVersion=21" \
    -d "bootVersion=${BOOT_VERSION}" \
    -d "groupId=${GROUP}" \
    -d "artifactId=${ARTIFACT}" \
    -d "name=${ARTIFACT}" \
    -d "packageName=${GROUP}.${ARTIFACT//-/}" \
    -d "packaging=jar" \
    -d "dependencies=${DEPS}" \
    -o "$ZIP"

mkdir -p "${OUT}/${ARTIFACT}"
unzip -q "$ZIP" -d "${OUT}/${ARTIFACT}"

echo "Generated ${OUT}/${ARTIFACT} (Spring Boot ${BOOT_VERSION}, Java 21)"
echo "Next: add spring-cloud-aws-starter-sqs to pom.xml — see references/sqs.md"
