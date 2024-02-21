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

### 4. Worker repo

Create github repo with the name `worker-flux` with content in `k8s-resources` folder

```
* deployment.yaml
* kustomization.yaml
```
You can replace it with your desire resources

### 5. Manager repo

Example structure:
```
* ./clusters
  * staging
    * flux-system
      * gotk-components.yaml
      * gotk-sync.yaml
      * kustomization.yaml
    * nginx-source.yaml
    * nginx-kustomization.yaml
  * production
    * flux-system
      * gotk-components.yaml
      * gotk-sync.yaml
      * kustomization.yaml
```
Clone `manager repo`
```
git clone git@github.com:$GITHUB_USER/$GITHUB_REPO.git $HOME/$GITHUB_REPO
cd $HOME/$GITHUB_REPO
```

Create resources that point to `worker repo`
```	
cat << EOF | sudo tee -a $PATH/ngin-source.yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: nginx
  namespace: flux-system
spec:
  interval: 1m
  ref:
    branch: $BRANCH
  url: https://github.com/$GITHUB_USER/worker-flux
EOF
```

```
git add -A && git commit -m "Add nginx GitRepository"
git push
```

Create resources that point to `gitrepo` was created:
```	
cat << EOF | sudo tee -a $PATH/ngin-kustomization.yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: nginx
  namespace: flux-system
spec:
  interval: 30m0s
  path: ./
  prune: true
  retryInterval: 2m0s
  sourceRef:
    kind: GitRepository
    name: nginx
  targetNamespace: default
  timeout: 3m0s
  wait: true
```

```
git add -A && git commit -m "Add nginx Kustomization`
git push
```

### 6. Check 
View kustomization resources:
```
flux get kustomizations --watch
```

View deployment resources:
```
kubectl -n default get deployments
```

Update `worker repo`:
* Eg: replica 
* Commit > push

View kustomization resources again:
```
flux get kustomizations --watch
```

View deployment resources again:
```
kubectl -n default get deployments
```

### 7. Destroy cluster

```
aws cloudformation delete-stack --stack-name flux
```
