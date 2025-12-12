# congenial-garbanzo – Live DevOps Exercise

## Overview

This repository contains a very small example application and some supporting configuration that resemble parts of our real stack.

You’ll find:

- A simple **Golang microservice** in `app/`
- A **Dockerfile** for containerizing the service
- **Kubernetes manifests** in `k8s/` for deploying the service
- An **ArgoCD Application** definition in `argocd/`
- **Azure Terraform** configuration in `terraform/` for provisioning an Azure Storage Account the service might use in the future

---

## What we’ll be looking for

During the call, we’re less interested in you memorizing exact syntax and more interested in:

- How you **understand and describe** what’s already here
- The kinds of improvements you naturally prioritize
- How you **reason about** containerization, Kubernetes deployments, GitOps with ArgoCD, and infrastructure as code on Azure
- Your ability to explain trade-offs and think out loud as you make changes

Feel free to make reasonable assumptions and mention them as you go.

---

## 1. Golang microservice (`app/`)

The `app` directory contains a small HTTP service written in Go.

As you look at it, be ready to answer:

- What does this microservice actually do?
- What endpoints does it expose, and what responses should we expect?
- How would you run it locally to verify behavior?

---

## 2. Dockerfile

The root of the repo contains a `Dockerfile` used to build a container image for the service.

You can assume that:

- A container registry already exists and is reachable at `myregistry`
- An image is built from this `Dockerfile` and pushed to that registry

As you review it, think about:

- What do you notice about how this image is being built?
- Is this suitable for a production deployment of a Go service?
- What would you modify in the Dockerfile to improve things?

We’ll likely ask you to talk through and implement some of those improvements in the Dockerfile during our call.

---

## 3. Kubernetes manifests (`k8s/`)

The `k8s` directory contains YAML manifests intended to deploy this service onto a Kubernetes cluster.

You can assume:

- A Kubernetes cluster already exists
- The image built from this repo is available in the `myregistry` registry
- These manifests are what ArgoCD (see below) would use to deploy the service

As you review the manifests, consider:

- Are there any obvious improvements you’d make to those?
- How would you validate the deployment of those manifests before deploying them in the live K8S cluster?

We may ask you to explain what the current manifests do and have you adjust them to be closer to what you’d want in a real environment.

---

## 4. ArgoCD Application (`argocd/`)

The `argocd` directory contains an ArgoCD `Application` definition intended to deploy the Kubernetes manifests from this repo.

You can assume:

- ArgoCD is already installed and running inside the Kubernetes cluster
- This `Application` is meant to point at this repo and the `k8s` directory to manage the deployment of the microservice

As you review the ArgoCD YAML, think about:

- How does this `Application` know **what** to deploy and **where** to deploy it?
- Are there any fields or settings you would add or change?

We’ll likely ask you to describe how this Application works and what you would adjust to make it production ready.

---

## 5. Azure Terraform (`terraform/`)

In the future, this microservice may be updated to store data in an **Azure Blob Storage** account. The `terraform` directory contains configuration for provisioning Azure resources associated with that future requirement.

You can assume:

- This Terraform is intended to run before or alongside application deployment
- The storage account and related resources should be created and managed by this Terraform code

As you look through the Terraform files, consider:

- What Azure resources are being created right now?
- What would you change or add to make those Azure resources more production ready?
- How would you update the Kubernetes deployment (and the Go service inside it) to obtain the information and credentials required to talk to this storage account?
- How would you ensure the storage account is created before the microservice deployment?

