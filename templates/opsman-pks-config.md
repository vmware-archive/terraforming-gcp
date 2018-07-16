# Operations Manager - Pivotal Container Service Tile Config

## Assign AZs and Network

Place singleton jobs in: ${singleton_az}
Balance other jobs in: ${azs}
Network: ${subnet_pks_name}
Service Network: ${subnet_pks_svc_name}

## PKS API

Generate RSA Certificate:  ${pks_wildcard}
API Hostname (FQDN): ${pks_hostname}

## Plan 1

_feel free to modify the plan to meet your needs_

Plan: Active
Name: small
Description: This plan will configure a lightweight kubernetes cluster. Not recommended for production workloads.

Master/ETCD Node Instances: 1
Master/ETCD VM Type: medium
Master Persistent Disk Type: 100GB
Master/ETCD Availability Zones: ${singleton_az}

Worker Node Instances: 3
Worker VM Type: medium
Worker Persistent Disk Type: 100GB
Worker Availability Zones: ${azs}

Errand VM Type: micro

(Optional) Add-ons - Use with caution: <leave empty>
[ ] Enable Privileged Containers - Use with caution
[ ] Disable DenyEscalatingExec


## Plan 2

_feel free to modify the plan to meet your needs_

Plan: Active
Name: medium
Description: This plan will configure a medium sized kubernetes cluster, suitable for more pods.

Master/ETCD Node Instances: 3
Master/ETCD VM Type: large
Master Persistent Disk Type: 100GB
Master/ETCD Availability Zones: ${azs}

Worker Node Instances: 6
Worker VM Type: medium
Worker Persistent Disk Type: 100GB
Worker Availability Zones: ${azs}

Errand VM Type: micro

(Optional) Add-ons - Use with caution: __leave empty__
[ ] Enable Privileged Containers - Use with caution
[ ] Disable DenyEscalatingExec

## Plan 3

_feel free to modify the plan to meet your needs_

Plan: Inactive

## Kubernetes Cloud Provider

Choose your IaaS: GCP
GCP Project ID: ${project}
VPC Network: ${network_name}
GCP Master Service Account ID: ${pks_master_node_service_account_email}
GCP Worker Service Account ID: ${pks_worker_node_service_account_email}

## Logging

## Networking

## UAA

## Monitoring

## Usage Data

## Errands

## Resource Config