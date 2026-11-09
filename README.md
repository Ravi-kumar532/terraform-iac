# Multi-cloud Terraform modules

Reusable Terraform modules for AWS, Microsoft Azure, and Google Cloud. The
repository also includes separate Terraform roots for bootstrapping each cloud's
remote-state storage.

> **Scope:** `providers/<cloud>/module/` contains reusable child modules only.
> It does not contain workload root configurations, environment variable files,
> or workload state backends.
> GitHub Actions and Azure DevOps validate the modules and bootstrap roots;
> they do not deploy infrastructure.

## Repository structure

```text
.
├── .azure/
│   └── pipelines/
│       └── terraform.yml
├── .github/
│   └── workflows/
│       └── terraform-ci-cd.yml
├── providers/
│   ├── aws/
│   │   ├── bootstrap/       # S3 state bucket and DynamoDB lock table
│   │   └── module/          # Reusable AWS service modules
│   ├── azure/
│   │   ├── bootstrap/       # State resource group, Storage account, container
│   │   └── module/          # Reusable Azure service modules
│   └── gcp/
│       ├── bootstrap/       # Versioned Cloud Storage state bucket
│       └── module/          # Reusable Google Cloud service modules
├── scripts/
│   └── terraform-validate.sh
└── README.md
```

Each child module directory has its own inputs, resources, outputs, and provider
constraints. There is only one `module` directory level per cloud; the module
directories sit directly inside it. The module collection is not itself a
Terraform root, so it does not contain root `main.tf`, `parameters.tf`,
`backend.tf`, or provider configuration files.

Module directories use each cloud's native service names rather than a shared
cross-cloud name. Examples include Azure `aks/`, AWS `eks/`, Google Cloud
`gke/`, Azure `app_service/`, AWS `app_runner/`, and Google Cloud `cloud_run/`.
Other equivalents use provider-specific names such as `acr/`, `ecr/`, and
`artifact_registry/`. Azure also has `key_vault/`; each provider has a
`monitoring/` module.

## Module catalog and cloud equivalents

The three providers expose the same service categories using native cloud
resources. These services are functional alternatives, not exact feature-for-
feature matches; review each cloud's quotas, semantics, costs, and operational
requirements before selecting one.

| Category | Azure module / service | AWS module / service | Google Cloud module / service |
| --- | --- | --- | --- |
| Resource grouping | `resource_group` / Resource Groups | `resource_groups` / tag-based resource groups | `project` / Google Cloud project |
| Object storage | `storage_account` / Blob Storage | `s3_bucket` / Amazon S3 | `cloud_storage` / Cloud Storage |
| Network / subnet | `vnet`, `subnet` / VNet | `vpc`, `subnet` / VPC | `vpc`, `subnet` / VPC network |
| Managed application hosting | `app_service` / App Service plan | `app_runner` / App Runner | `cloud_run` / Cloud Run |
| Web application | `web_app` / App Service | `elastic_beanstalk` / Elastic Beanstalk | `app_engine` / App Engine Standard |
| Functions | `function_app` / Azure Functions | `lambda` / AWS Lambda | `cloud_functions` / Cloud Functions (2nd gen) |
| Workflow orchestration | `logic_app` / Logic Apps | `step_functions` / Step Functions | `workflows` / Workflows |
| Kubernetes | `aks` / AKS | `eks` / EKS | `gke` / GKE |
| Container registry | `acr` / ACR | `ecr` / ECR | `artifact_registry` / Artifact Registry |
| Event routing | `event_grid` / Event Grid | `eventbridge` / EventBridge | `eventarc` / Eventarc |
| SQL server / managed SQL | `sql_server` / Azure SQL | `rds_sql_server` / RDS for SQL Server | `cloud_sql` / Cloud SQL |
| SQL database | `sql_database` / Azure SQL Database | `rds_mysql` / RDS MySQL | `cloud_sql_database` / Cloud SQL database |
| Application configuration | `app_configuration` / App Configuration | `appconfig` / AWS AppConfig | `firestore` / Firestore key/value configuration |
| Messaging | `service_bus` / Service Bus queues and topics | `sqs_sns` / SQS and SNS | `pubsub` / Pub/Sub |
| Monitoring | `monitoring` / Azure Monitor and managed Prometheus/Grafana | `monitoring` / CloudWatch and managed Prometheus/Grafana | `monitoring` / Cloud Monitoring, managed Prometheus, Grafana |

AWS Resource Groups only group resources by tags; they do not scope deployment
or provide Azure-style lifecycle boundaries. Google Cloud projects are the
closest grouping and IAM boundary. GCP Firestore is a key/value configuration
alternative, not a direct replacement for App Configuration feature flags.
The Google Cloud `app_engine` module initializes the project's App Engine
application; an App Engine location is selected once per project and cannot be
changed later.
AWS RDS creates its initial MySQL database as part of the database instance; the
AWS `rds_mysql` module therefore provisions an RDS instance and cannot
independently manage arbitrary database schemas. The separate `sql_server`
module provides RDS for SQL Server.

The resource modules apply secure defaults where supported, including encryption
at rest, blocked anonymous/public access, TLS, versioning or backups, and
deletion protection for stateful production resources. Public endpoints and
network access are explicit configuration choices. Private-only defaults may
require the consumer to also configure private endpoints, DNS, routes, and
runtime connectivity. Credentials are supplied through cloud identity or
external secret systems; modules do not generate or return plaintext
credentials. These defaults are a starting point, not a substitute for
environment-specific security review.

Several modules support deliberate multi-resource inputs: web application
modules can create multiple apps, Azure Storage can create multiple blobs, and
Azure Key Vault can grant permission sets to multiple principals. Azure Event
Grid uses Entra ID/RBAC publisher identities rather than access keys. Azure
Service Bus accepts multiple namespace definitions, each with multiple queues
and topics. Inspect each module's variables for its exact input schema; do not
put secrets or credentials in resource collections or Terraform state.

Existing specialized modules remain available for Azure Key Vault and the
provider-specific Prometheus/Grafana monitoring integrations.

Modules are reusable building blocks. A consuming repository or Terraform root
must call them, pass required inputs, configure its provider, and provide its
own state backend. This repository does not compose all child modules into an
environment stack.

## Bootstrap state backends

Bootstrap directories are independent Terraform roots and intentionally retain
their own `main.tf`, `variables.tf`, provider configuration, and version
constraints. Those files are required to provision the backend and are not
duplicated workload root files. Run bootstrap manually with an administrator
identity; the CI pipelines do not apply bootstrap.

Bootstrap uses local state by default. Keep each generated local state file
securely backed up. Do not lose or commit it; it tracks the resources used by
the state backend itself.

### AWS

`providers/aws/bootstrap` creates a versioned, encrypted, public-access-blocked
S3 state bucket and a DynamoDB state-lock table.

```sh
terraform -chdir=providers/aws/bootstrap init
terraform -chdir=providers/aws/bootstrap apply \
  -var="region=<aws-region>" \
  -var="state_bucket_name=<globally-unique-s3-bucket>" \
  -var="lock_table_name=<dynamodb-lock-table>"
```

### Azure

`providers/azure/bootstrap` creates a resource group, private blob container,
and storage account with versioning, retention, TLS, and shared-key access
disabled. Configure Entra ID authentication and network access for the workload
identity that will use this backend.

```sh
terraform -chdir=providers/azure/bootstrap init
terraform -chdir=providers/azure/bootstrap apply \
  -var="resource_group_name=<state-resource-group>" \
  -var="location=<azure-region>" \
  -var="storage_account_name=<globally-unique-storage-account>"
```

### Google Cloud

`providers/gcp/bootstrap` creates a versioned Cloud Storage bucket with uniform
bucket-level access, public access prevention, and a retention policy.

```sh
terraform -chdir=providers/gcp/bootstrap init
terraform -chdir=providers/gcp/bootstrap apply \
  -var="project_id=<gcp-project-id>" \
  -var="region=<gcp-region>" \
  -var="location=<gcs-location>" \
  -var="state_bucket_name=<globally-unique-gcs-bucket>"
```

## Monitoring

- **AWS:** Managed Prometheus and Grafana, a database CPU alarm, and an SNS
  topic. An optional email subscription requires recipient confirmation.
- **Azure:** Azure Monitor managed Prometheus collection associated with AKS
  and Azure Managed Grafana integration.
- **Google Cloud:** GKE managed Prometheus collection and Grafana on private
  Cloud Run with Cloud SQL persistence, Secret Manager credentials, and
  identity-based invocation.

The monitoring modules create managed monitoring infrastructure, not
application instrumentation, dashboards, SLO definitions, or organization-
specific alert routing. Configure workload scraping/remote write and alert
routing in the consuming stack. Prometheus/Grafana and database resources incur
cloud charges.

## CI validation

The GitHub workflow at
`.github/workflows/terraform-ci-cd.yml` and Azure DevOps pipeline at
`.azure/pipelines/terraform.yml` run `scripts/terraform-validate.sh`. The script
validates every bootstrap root and child module from a temporary copy. It does
not configure cloud credentials, access remote state, or create resources.

Run the same validation locally with Terraform 1.5.7 or compatible:

```sh
bash scripts/terraform-validate.sh
```

The validation needs provider-registry access to initialize schemas. Provider
lockfiles are committed in bootstrap roots to make those provider selections
reproducible across supported platforms.

## Consuming modules

In a workload root, reference a provider module by its local path, for example
`../../providers/aws/module/vpc`. The consuming root supplies the module's
required inputs; see that module's `variables.tf` and outputs before composing
it into a stack.

The consuming root owns `terraform {}`, provider configuration, remote backend,
environment inputs, and stack composition. Use separate root directories or
backend keys for `dev`, `stage`, and `prod`. Keep credentials out of tfvars and
source control; use workload identity federation (OIDC) and the CI platform's
protected variables/secrets when the consuming repository deploys.

Review each module's variables and outputs before use. Validate naming limits,
provider permissions, network access, quotas, resource lifecycle, encryption,
and deletion protection against your organization's requirements. Terraform
marks some values sensitive for output redaction, but sensitive values can
still appear in state; protect all state backends accordingly.

## Security notes

- The previous tracked local `Environments/Dev/parameters.tfvars` was removed.
  If it contained live credentials, rotate them because removal does not erase
  Git history.
- Do not commit credentials, tfvars, state files, or plan files.
- Bootstrap identities should be separate from workload identities and have
  only the permissions needed for backend provisioning.
- Review bootstrap retention and deletion behavior before managing state
  containing real workloads.
- No cloud deployment is performed by this repository's CI pipelines.
