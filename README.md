# fluxCD
This is a demonstration of GitOps on kubernetes cluster using Flux

## 1. Prerequisites
* [aws-access-key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
* [github-access-token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [flux](https://fluxcd.io/flux/installation/)
## 2. Let's start

### 1. Initialize cluster

```
aws cloudformation deploy --stack-name flux --template-file ./cloudformation-resources/k8s.yaml --capabilities CAPABILITY_IAM
```
### 2. get kubeconfig

List clusters:
```
aws eks list-clusters
```

Get kubeconfig file:
```
aws eks update-kubeconfig --name EKSCluster
```

Test cluster:
```
kubectl get nodes
```

### 3. Bootstrap flux

Configure environment variable:
```
export $GITHUB_TOKEN=
```

```
export $GITHUB_USER=
```
eg: manager-flux

```
export $GITHUB_REPO=
```

eg: main
```
export $BRANCH=
```

eg: ./clusters/dev
```
export $PATH=
```

```
flux bootstrap github --owner $GITHUB_USER --repository $GITHUB_REPO --branch $BRANCH --path $PATH --personal
```

### 2. Manager repo

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

### 6. Destroy cluster

```
aws cloudformation delete-stack --stack-name flux
```

