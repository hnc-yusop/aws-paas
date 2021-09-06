# PaaS Service using OKD on AWS

![Architecture](./architecture.svg)

1. Install OKD
- Note your access url & kubeadmin password
2. IAC cognito Step 1
3. Connect OKD & cognito
- Issuer address with 'pool ID' : https://cognito-idp.ap-northeast-2.amazonaws.com/{pool ID}
4. install OAuth wrapper 
5. IAC cognito Step 2
6. Connect Cognito & OAuth wrapper

## Creating service-account :
- Reference URL -> http://wiki.rockplace.co.kr/display/OP/1.+Authentication#id-1.Authentication-ServiceAccountToken%EC%9D%84%EC%96%BB%EB%8A%94%EB%B0%A9%EB%B2%95
```
oc create serviceaccount robot
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:default:robot
oc describe serviceaccount robot
oc describe secret robot-token-XXXX // Note your token for the serviceaccount
```

## Constructing an AWS Lambda function
+ Access to AWS Lambda console
+ Click "Create function" button
+ Select "Author from scratch"
	+ Enter Function name
	+ Runtime : Node.js 14.x
	+ Click "Create function" button
+ Copy your Lambda function code (lambda/index.js) and then paste the code into 'index.js' 
	+ You need to activate some of variables - token and baseDomain
	+ The token value is a service-account's token for the OKD
	+ The baseDomain value is a base domain name for the OKD
+ File > Save & Deploy
+ Access to AWS Cognito console
+ Manage User Pools > Select your pool > Select 'General settings > Triggers'
+ Select your lambda function in drop-down list of the 'Post authentication' & 'Post Confirmation'

## Disabling the self provisioning :
- Reference URL -> https://rcarrata.com/openshift/disabling-self-provisioning-ocp4/
```
oc patch clusterrolebinding.rbac self-provisioners -p '{"subjects": null}'
oc patch clusterrolebinding.rbac self-provisioners -p '{ "metadata": { "annotations": { "rbac.authorization.kubernetes.io/autoupdate": "false" } } }'
oc get clusterrolebinding.rbac self-provisioners -o yaml
```

## Removing the kubeadmin user :
- Reference URL -> https://access.redhat.com/documentation/en-us/openshift_container_platform/4.1/html/authentication/removing-kubeadmin
```
oc adm policy add-cluster-role-to-user cluster-admin {USER-ID}
oc delete secrets kubeadmin -n kube-system
```

## Installing a KubeCost application
+ Add a kubecost helm repository using OC tool

```
cat <<EOF | oc apply -f -
apiVersion: helm.openshift.io/v1beta1
kind: HelmChartRepository
metadata:
  name: cost-analyzer
spec:
 # optional name that might be used by console
 # name: <chart-display-name>
  connectionConfig:
    url: https://kubecost.github.io/cost-analyzer/
EOF
```

+ Install a kubecost application on your OKD web console
	+ Move to menu item as 'Developer > +Add > Helm Chart'
	+ Select 'Project: default'
	+ Click 'Cost Analyzer'
	+ Click 'Install Helm Chart'
	+ Edit yaml
	```
	service:
	  type: LoadBalancer
	prometheus:
	  pushgateway:
	    enabled: false
	    persistentVolume:
	      enabled: false
	```
	+ Click 'Install'
	+ Move to menu item as 'Developer > Topology'
	+ Select a circle - 'cost-analyzer'
	+ Move to menu item as 'Resources Tab > Services'
	+ Click 'cost-analyzer-cost-analyzer'
	+ Check out {Location} information
	+ Access 'http://{Location}:9090'
	+ Adjust filter options
	```
	- Idle costs : Hide
	- Chart : Proportional Cost
	- namespace : prj*
	```
