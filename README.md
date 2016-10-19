# How Does One Use This?

Please note that the master branch is generally *unstable*. If you are looking for something
"tested", please consume one of our [releases](https://github.com/pivotal-cf/terraforming-gcp/releases).

## What Does This Do?

You will get a booted ops-manager VM plus some networking, just the bare bones basically.

## Looking to setup a different IAAS

We have have other terraform templates to help you!

- [aws](https://github.com/pivotal-cf/terraforming-aws)
- [azure](https://github.com/pivotal-cf/terraforming-azure)

This list will be updated when more infrastructures come along.

## Prerequisites

Your system needs the `gcloud` cli, as well as `terraform`:

```bash
brew install Caskroom/cask/google-cloud-sdk
go get -u github.com/hashicorp/terraform
```

You will also want to setup a "project-wide" SSH key to allow SSH access to the VMs in your deployment.
You can follow the directions [here](https://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys#sshkeys) to set up a key.

## Notes

This repository requires at least v0.7.7 of terraform

You will need to have copied the ops-manager image to your GCS.

The command will look something like this:

```bash
gcloud compute images create my-ops-manager-image-name --source-uri https://remote.location.of.ops-manager
```

You will also need a key file for your [service account](https://cloud.google.com/iam/docs/service-accounts) to allow terraform to deploy resources. If you don't have one, you can create a service account and a key for it:

```bash
gcloud iam service-accounts create some-account-name
gcloud iam service-accounts keys create "terraform.key.json" --iam-account "some-account-name@yourproject.iam.gserviceaccount.com"
gcloud projects add-iam-policy-binding PROJECT_ID --member 'serviceAccount:some-account-name@PROJECT_ID.iam.gserviceaccount.com' --role 'roles/editor'
```

You will need to enable the [Google Cloud Resource Manager API] (https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/) on your GCP account.  The Google Cloud Resource Manager API provides methods for creating, reading, and updating project metadata.

You will also need to enable the [Google Cloud DNS API] (https://console.developers.google.com/apis/api/dns/overview) on your GCP account.  The Google Cloud DNS API provides methods for creating, reading, and updating project DNS entries.

## Variables

- project: **(required)** ID for your GCP project
- env_name: **(required)** An arbitrary unique name for namespacing resources
- region: **(default: us-central1)** Region in which to create resources
- zones: **(default: [us-central1-a, us-central1-b, us-central1-c])** Zones in which to create resources. Must be within the given region.
- opsman_image_name: **(required)** Name of image created by `gcloud compute images create`.
- service_account_key: **(required)** Contents of your service account key file generated using the `gcloud iam service-accounts keys create` command.
- dns_suffix: **(required)** Domain to add environment subdomain to (e.g. foo.example.com)
- ssl_cert: **(required)** SSL certificate for HTTP load balancer configuration. Can be either trusted or self-signed.
- ssl_cert_private_key:  **(required)** Private key for above SSL certificate.

### Cloud SQL Configuration (optional)

- sql_region: Region to place your Cloud SQL instance in
- google_sql_db_tier: DB tier
- google_sql_db_host: The host the user can connect from. Can be an IP address. Changing this forces a new resource to be created 
- google_sql_db_username: Username for database
- google_sql_db_password: Password for database
- google_sql_instance_count: Number of instances


## Running

### Standing up environment

```bash
terraform apply \
  -var "project=your-gcp-project-name" \
  -var "env_name=banana" \
  -var "region=us-west1" \
  -var 'zones=["us-west1-a", "us-west1-b"]' \
  -var "opsman_image_name=gcp-opsman-image-name" \
  -var "service_account_key=$(cat /full/path/to/terraform.key.json)" \
  -var "dns_suffix=foo.example.com" \
  -var 'ssl_cert=$(cat /path/to/ssl/cert.pem)' \
  -var 'ssl_cert_private_key=$(cat /path/to/ssl/key.pem)'
```

### Tearing down environment

```bash
terraform destroy \
  -var "project=your-gcp-project-name" \
  -var "env_name=banana" \
  -var "region=us-west1" \
  -var 'zones=["us-west1-a", "us-west1-b"]' \
  -var "opsman_image_name=gcp-opsman-image-name" \
  -var "service_account_key=$(cat /full/path/to/terraform.key.json)" \
  -var "dns_suffix=foo.example.com" \
  -var 'ssl_cert=$(cat /path/to/ssl/cert.pem)' \
  -var 'ssl_cert_private_key=$(cat /path/to/ssl/key.pem)'
```
