# fluxCD
This is a demonstration of GitOps on kubernetes cluster using Flux

## 1. Prerequisites
* [aws-access-key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [flux](https://fluxcd.io/flux/installation/)
### 1. Manager repo

```
* ./clusters
  * staging
    * flux-system
      * gotk-components.yaml
      * gotk-sync.yaml
      * kustomization.yaml
    * podinfor-source.yaml
    * podinfor-kustomization.yaml
  * production
    * flux-system
      * gotk-components.yaml
      * gotk-sync.yaml
      * kustomization.yaml
```
### 2. Worker repo

```
* deployment.yaml
* kustomization.yaml
```

