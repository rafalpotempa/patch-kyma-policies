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

When provisioning of SKR with `allowPrivilegedContainers: false` starts, wait for `kyma-installer` pod in `kyma-installation` namespace reach `CreateContainerConfigError`.

Run patching procedure with

```bash
./patch-resources.sh
```

You may want to watch pods that encounter similar creation error with

```bash
watch 'kubectl get pods -A | grep CreateContainerConfigError'
```

