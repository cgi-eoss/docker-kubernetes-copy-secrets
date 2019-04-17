#!/usr/bin/env bash

set -x

SOURCE_NAMESPACE_LABEL=copy-secrets-source-namespace
SOURCE_NAME_LABEL=copy-secrets-source-name

for namespace in $(kubectl get namespaces --no-headers -o custom-columns=':metadata.name'); do
    # Filter by those secrets which already have our labels
    for name in $(kubectl get secrets --namespace=${namespace} --selector copy-secrets-source-name --no-headers -o custom-columns=':metadata.name'); do
        # Extract the source secret name and namespace from this secret's labels
        JSON=$(kubectl get secrets --namespace=${namespace} ${name} --output=json)
        SOURCE_SECRET_NAMESPACE=$(echo $JSON | jq -r .metadata.labels.\"${SOURCE_NAMESPACE_LABEL}\")
        SOURCE_SECRET_NAME=$(echo $JSON | jq -r .metadata.labels.\"${SOURCE_NAME_LABEL}\")
        # Copy over the source secret
        kubectl get secret --namespace=${SOURCE_SECRET_NAMESPACE} ${SOURCE_SECRET_NAME} --output=json | jq "del(.metadata.creationTimestamp, .metadata.namespace, .metadata.resourceVersion, .metadata.uid) | .metadata.name = \"${name}\" | del(.data[\"ca.crt\"] | select(. == null))" | kubectl apply --namespace=${namespace} -f - || true
    done
done
