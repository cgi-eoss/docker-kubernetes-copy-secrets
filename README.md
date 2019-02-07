# Copy Secrets

## Summary
A Dockerfile which copies (conventionally TLS) kubernetes secrets from one or more source secrets to one or more destination secrets.

## Use-case
The design use-case is the automatic propagation of updated ACME TLS secrets across many namespaces.

## Usage
Run this docker container as a kube-cronjob with a service account that has write permissions for the desired namespaces.
