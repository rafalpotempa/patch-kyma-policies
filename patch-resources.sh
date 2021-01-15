#!/bin/bash

function waitfor(){
	resource=$1
	name=$2
	
	print=1
	while [[ "$(kubectl get $resource | grep $name)" == "" ]]
	do
		if [[ $print == 1 ]]
		then
			echo "-> waiting for $2"
			print=0
		fi
		sleep 1
	done
}

function patch(){
	resource=$1
	name=$2
	printf "$(kubectl get $resource $name -o yaml)\n$(cat resources/patch.yaml)" | kubectl apply -f -
	echo "-> $resource $name patched"
}

function restart(){
	resource=$1
	namespace=$2
	name=$3

	if [[ $resource == "job" ]]
	then
		controlleruuid=$(kubectl get job -n $namespace $name -o "jsonpath={.metadata.labels.controller-uid}")
		pod=$(kubectl get pod -n $namespace -l controller-uid=$controlleruuid -o name)
		kubectl delete -n $namespace $pod
	elif [[ $resource == "deployment" ]]
	then
		kubectl scale deployment -n $namespace $name --replicas 0 1&>/dev/null
		kubectl scale deployment -n $namespace $name --replicas 1 1&>/dev/null
	fi
	echo "-> $resource $name restarted"
}

kubectl create -f resources/pod-security-policy.yaml

# kyma-installer
# omit if it doesn't yield CreateContainerConfigError
if [[ 'kubectl get pods -n kyma-installer | grep CreateContainerConfigError' ]]
then
	waitfor clusterrole kyma-installer-reader
	patch clusterrole kyma-installer-reader
	restart deployment kyma-installer kyma-installer
fi

# cluster-essentials
waitfor clusterrole cluster-essentials-crd-install
patch clusterrole cluster-essentials-crd-install
restart job kyma-system cluster-essentials-crd-install

# kyma-ns-label
waitfor clusterrole kyma-ns-label
patch clusterrole kyma-ns-label
restart job istio-system kyma-ns-label

# istio-installer
waitfor clusterrole istio-job
patch clusterrole istio-job
restart job istio-system istio-job

echo "-> done"