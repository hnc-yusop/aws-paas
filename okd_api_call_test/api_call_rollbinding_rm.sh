#!/bin/bash

TOKEN=$(oc whoami -t)
ENDPOINT=api.okd.okd-newworld.ml:6443
NAMESPACE=$(oc config current-context | cut -d/ -f1)
PROJECTNAME=test-project

curl -k \
    -X DELETE \
    -d @- \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    https://$ENDPOINT/apis/authorization.openshift.io/v1/namespaces/$PROJECTNAME/rolebindings/admin <<'EOF'
EOF
