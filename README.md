# patch-kyma-policies

## Description

This script allows patching of Kyma installation for purpose of investigation and debugging of `allowPrivilegedContainers: false` global policy introduction.

It patches the installation by adding PodSecurityPolicy `kyma.privileged` to the cluster and patching  `ClusterRoles` and `Roles` to be able to use that policy. Thanks to that the installation of other components is possible to be initialized (one-by-one).

Patching concerns following components:
- `kyma-installer`
- `cluster-essentials`
- `istio`
- `istio-kyma-patch`

## Prerequisites

- `kubeconfig` file for desired SKR

## Usage

### Istio installation
When provisioning of SKR with `allowPrivilegedContainers: false` starts, wait for `kyma-installer` pod in `kyma-installation` namespace reach `CreateContainerConfigError`.

Run patching procedure with

```bash
./patch-resources.sh
```

> NOTE: You may encounter `kubectl` errors related to non-existence of pod `cluster-essentials` or no resources in namespace `istio-system` - this does not affect the script.

### Post-istio installation steps

After the script installs `istio-kyma-patch` the `kyma-installer` will try to install other components. In case if fails in creating a deployment with some number of retires it fails, thus it is recommended to scale the deployments to `--replicas=0` to trick the `kyma-installer`.

## Watch

You may want to watch pods that encounter similar creation error with

```bash
watch 'kubectl get pods -A | grep CreateContainerConfigError'
```

You may want to watch the deployments since some components are not allowed to create pod, thus will no be seen with `CreateContainerConfigError`.

```bash
kubectl get deployments -A
```