#!/bin/bash

TOKEN=$(oc whoami -t)
ENDPOINT=api.okd.okd-newworld.ml:6443
NAMESPACE=$(oc config current-context | cut -d/ -f1)

curl -k \
    -X POST \
    -d @- \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    https://$ENDPOINT/apis/project.openshift.io/v1/projectrequests <<'EOF'
{
  "kind": "ProjectRequest",
  "metadata": {"name":"test-project"}
}
EOF
