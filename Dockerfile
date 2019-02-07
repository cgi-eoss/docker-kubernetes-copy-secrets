FROM alpine:3.9

ENV SOURCE_NAMESPACE_LABEL=copy-secrets-source-namespace \
    SOURCE_NAME_LABEL=copy-secrets-source-name \
    KUBECTL_VERSION=v1.11.7

RUN apk update && \
        apk add bash && \
        apk add jq

ADD https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN chmod +x /usr/local/bin/kubectl

ADD copy-secrets.bash /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
