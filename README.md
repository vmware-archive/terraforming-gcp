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
brew update
brew install Caskroom/cask/google-cloud-sdk
brew install terraform
```

## Notes

This repository currently supports terraform **v0.8.0-rc2** - **v0.8.4**. The latest version of terraform has a bug that could result in the loss of your entire GCP Project.

You will also need a key file for your [service account](https://cloud.google.com/iam/docs/service-accounts)
to allow terraform to deploy resources. If you don't have one, you can create a service account and a key for it:

```bash
gcloud iam service-accounts create some-account-name
gcloud iam service-accounts keys create "terraform.key.json" --iam-account "some-account-name@yourproject.iam.gserviceaccount.com"
gcloud projects add-iam-policy-binding PROJECT_ID --member 'serviceAccount:some-account-name@PROJECT_ID.iam.gserviceaccount.com' --role 'roles/owner'
```

You will need to enable the following Google Cloud APIs:
- [Identity and Access Management](https://console.developers.google.com/apis/api/iam.googleapis.com)
- [Cloud Resource Manager](https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/)
- [Cloud DNS](https://console.developers.google.com/apis/api/dns/overview)

### Var File

Copy the stub content below into a file called `terraform.tfvars` and put it in the root of this project.
These vars will be used when you run `terraform  apply`. You should fill in the stub values with the correct content.

```hcl
env_name = "some-environment-name"
region = "us-central1"
opsman_image_url = "https://storage.googleapis.com/your-opsmanager.tgz"
zones = ["us-central1-a", "us-central1-b", "us-central1-c"]
project = "your-gcp-project"
dns_suffix = "gcp.some-project.cf-app.com"

ssl_cert = <<SSL_CERT
-----BEGIN CERTIFICATE-----
some cert
-----END CERTIFICATE-----
SSL_CERT

ssl_cert_private_key = <<SSL_KEY
-----BEGIN RSA PRIVATE KEY-----
some cert private key
-----END RSA PRIVATE KEY-----
SSL_KEY

service_account_key = <<SERVICE_ACCOUNT_KEY
{
  "type": "service_account",
  "project_id": "your-gcp-project",
  "private_key_id": "another-gcp-private-key",
  "private_key": "-----BEGIN PRIVATE KEY-----another gcp private key-----END PRIVATE KEY-----\n",
  "client_email": "something@example.com",
  "client_id": "11111111111111",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://accounts.google.com/o/oauth2/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/"
}
SERVICE_ACCOUNT_KEY
```

### Var Details

- project: **(required)** ID for your GCP project.
- env_name: **(required)** An arbitrary unique name for namespacing resources.
- region: **(required)** Region in which to create resources (e.g. us-central1)
- zones: **(required)** Zones in which to create resources. Must be within the given region. Currently you must specify exactly 3 Zones for this terraform configuration to work. (e.g. [us-central1-a, us-central1-b, us-central1-c])
- opsman_image_url **(required)** Source URL of the Ops Manager image you want to boot.
- service_account_key: **(required)** Contents of your service account key file generated using the `gcloud iam service-accounts keys create` command.
- dns_suffix: **(required)** Domain to add environment subdomain to (e.g. foo.example.com)
- ssl_cert: **(required)** SSL certificate for HTTP load balancer configuration. Can be either trusted or self-signed.
- ssl_cert_private_key:  **(required)** Private key for above SSL certificate.
- opsman_storage_bucket_count: *(optional)* Google Storage Bucket for BOSH's Blobstore.
- sql_db_tier: *(optional)* DB tier

## DNS Records

- pcf.*$env_name*.*$dns_suffix*: Points at the Ops Manager VM's public IP address.
- \*.sys.*$env_name*.*$dns_suffix*: Points at the HTTP/S load balancer in front of the Router.
- doppler.sys.*$env_name*.*$dns_suffix*: Points at the TCP load balancer in front of the Router. This address is used to send websocket traffic to the Doppler server.
- loggregator.sys.*$env_name*.*$dns_suffix*: Points at the TCP load balancer in front of the Router. This address is used to send websocket traffic to the Loggregator Trafficcontroller.
- \*.apps.*$env_name*.*$dns_suffix*: Points at the HTTP/S load balancer in front of the Router.
- \*.ws.*$env_name*.*$dns_suffix*: Points at the TCP load balancer in front of the Router. This address can be used for application websocket traffic.
- ssh.sys.*$env_name*.*$dns_suffix*: Points at the TCP load balancer in front of the Diego brain.
- tcp.*$env_name*.*$dns_suffix*: Points at the TCP load balancer in front of the TCP router.

## Isolation Segments (optional)
- create_isoseg_resources *(optional)* Set to 1 to create HTTP load-balancer across 3 zones for isolation segments. If set, the following 2 isoseg variables are also required.
- isoseg_ssl_cert: *(optional)* SSL certificate for HTTP load balancer configuration. Can be either trusted or self-signed.
- isoseg_ssl_cert_private_key:  *(optional)* Private key for above SSL certificate.

### Cloud SQL Configuration (optional)

#### Ops Manager
- opsman_sql_db_host: *(optional)* The host the user can connect from. Can be an IP address. Changing this forces a new resource to be created.
- opsman_sql_db_username: *(optional)* Username for database.
- opsman_sql_db_password: *(optional)* Password for database.
- opsman_sql_instance_count: *(optional)* Number of instances, defaults to 0.

#### ERT
- ert_sql_db_host: *(optional)* The host the user can connect from. Can be an IP address. Changing this forces a new resource to be created.
- ert_sql_db_username: *(optional)* Username for database.
- ert_sql_db_password: *(optional)* Password for database.
- ert_sql_instance_count: *(optional)* Number of instances, defaults to 0.

## Running

Note: please make sure you have created the `terraform.tfvars` file above as mentioned.

### Standing up environment

```bash
terraform apply
```

### Tearing down environment

```bash
terraform destroy
```
