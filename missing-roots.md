| area                      | name                             | ClusterRole / Role                       |
| ------------------------- | -------------------------------- | ---------------------------------------- |
| -                         | kyma-installer                   | kyma-installer-reader                    |
| -                         | cluster-essentials               | cluster-essentials-crd-install           |
| istio                     | kyma-ns-label                    | kyma-ns-label                            |
| istio                     | install-job                      | istio-job                                |
| isito                     | sidecar-injector                 | istio-sidecar-injector-istio-system      |
| istio                     | citadel                          | istio-citadel-istio-system               |
| istio                     | policy                           | istio-policy                             |
| istio                     | galley                           | istio-galley-istio-system                |
| istio                     | pilot                            | istio-pilot-istio-system                 |
| istio                     | ingressgateway                   | -n istio-system istio-ingressgateway-sds |
| istio                     | telemetry                        | istio-mixer-istio-system                 |
| istio                     | kyma-patch                       | istio-kyma-patch                         |
| knative-serving           | networking-istio                 | knative-serving-istio                    |
| knative-serving           | activator                        | none                                     |
| knative-eventing          | eventing-controller              | ?                                        |
| knative-eventing          | eventing-webhook                 | ?                                        |
| knative-eventing          | sources-controller               | ?                                        |
| dex                       | dex                              | ?                                        |
| ory                       | ory-mechanism-migration          | ?                                        |
| api-gateway               | api-gateway                      | ?                                        |
| service-catalog           | controller-manager               | ?                                        |
| service-catalog           | webhook                          | ?                                        |
| rafter                    | asyncapi-svc                     | ?                                        |
| rafter                    | ctrl-mngr                        | ?                                        |
| rafter                    | front-matter                     | ?                                        |
| rafter                    | upload-svc                       | ?                                        |
| rafter                    | minio                            | ?                                        |
| helm-broker               | addons-ui                        | ?                                        |
| helm-broker               | helm-broker                      | ?                                        |
| service-catalog-addons    | service-binding-usage-controller | ?                                        |
| service-catalog-addons    | service-catalog-ui               | ?                                        |
| permission-controller     | permission-controller            | ?                                        |
| iam                       | iam-kubeconfig-service           | ?                                        |
| apiserver-proxy           | apiserver-proxy                  | ?                                        |
| apiserver-proxy           | ssl-helper-job                   | ?                                        |
| core                      | core-content-ui                  | ?                                        |
| event-sources             | controller-manager               | ?                                        |
| knative-provisioner-natss | cr-delete                        | ?                                        |
| application-connector     | application-broker-migration     | ?                                        |
| compass                   | runtime-agent                    | ?                                        |

watch 'kubectl get pods -A | grep CreateContainerConfigError'