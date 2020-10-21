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

kubectl apply -f resources/pod-security-policy.yaml

# kyma-installer
waitfor clusterrole kyma-installer-reader
patch clusterrole kyma-installer-reader
restart deployment kyma-installer kyma-installer

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
restart job istio-system istio-install-job

# istio
waitfor clusterrole istio-sidecar-injector-istio-system
patch clusterrole istio-sidecar-injector-istio-system 
patch clusterrole istio-citadel-istio-system 
patch clusterrole istio-policy
patch clusterrole istio-galley-istio-system
patch clusterrole istio-pilot-istio-system
patch clusterrole istio-mixer-istio-system
patch "role -n istio-system" istio-ingressgateway-sds
restart deployment istio-system istio-citadel
restart deployment istio-system istio-galley
restart deployment istio-system istio-ingressgateway
restart deployment istio-system istio-pilot
restart deployment istio-system istio-policy
restart deployment istio-system istio-sidecar-injector
restart deployment istio-system istio-telemetry

# istio-kyma-patch
waitfor clusterrole istio-kyma-patch
patch clusterrole istio-kyma-patch
restart job istio-system istio-kyma-patch

