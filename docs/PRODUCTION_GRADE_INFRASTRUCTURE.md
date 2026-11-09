# Production-grade multi-cloud Terraform architecture

**Repository:** `Ravi-kumar532/terraform-iac`  
**Working branch:** `work/infra-foundation-audit`  
**Status:** Composition and pipeline foundations are in progress. No cloud apply has been run.

## Architecture

Each cloud has an independently deployable Terraform root. The root `main.tf` composes every provider module and accepts repeatable input arrays. The same root can be deployed to `dev`, `qa`, `staging`, and `prod`; each environment receives a separate backend state key/prefix and protected deployment boundary.

| Root | Modules wired | Remote state | Authentication |
| --- | ---: | --- | --- |
| `providers/azure` | 19 (17 existing + managed identity + private endpoint) | Azure Blob Storage | Entra OIDC |
| `providers/aws` | 16 | S3 with native lock file | GitHub OIDC role assumption |
| `providers/gcp` | 16 | GCS | Workload Identity Federation |
| **Total** | **51** | | |

Every module has a corresponding `module` block in its provider root `main.tf`. The input arrays use stable `key` fields and are converted to Terraform `for_each` maps, so adding or removing one item does not shift resource addresses as list-index-based `count` often does. The Azure Web App module and Service Bus module retain their native multi-instance input structures.

## Array-based examples

The following is illustrative input structure, not a deploy-ready configuration. Replace names, IDs, regions, plans, networks, and other required values with values from the target environment.

### Multiple Azure Web Apps, identities, Key Vault and SQL databases

```hcl
azure_app_service = [
  {
    key                 = "web-plan"
    name                = "REPLACE_WITH_PLAN_NAME"
    resource_group_name = "REPLACE_WITH_RESOURCE_GROUP"
    location            = "REPLACE_WITH_REGION"
    os_type             = "Linux"
    sku_name            = "P1v3"
  }
]

azure_managed_identity = [
  {
    key                 = "web-mi"
    name                = "REPLACE_WITH_IDENTITY_NAME"
    resource_group_name = "REPLACE_WITH_RESOURCE_GROUP"
    location            = "REPLACE_WITH_REGION"
    key_vaults          = ["app-secrets"]
  }
]

azure_key_vault = [
  {
    key                 = "app-secrets"
    name                = "REPLACE_WITH_GLOBALLY_UNIQUE_VAULT_NAME"
    resource_group_name = "REPLACE_WITH_RESOURCE_GROUP"
    location            = "REPLACE_WITH_REGION"
  }
]

azure_web_apps = [
  {
    key                         = "web-one"
    name                        = "REPLACE_WITH_WEB_APP_ONE"
    resource_group_name         = "REPLACE_WITH_RESOURCE_GROUP"
    location                    = "REPLACE_WITH_REGION"
    service_plan_key            = "web-plan"
    user_assigned_identity_keys = ["web-mi"]
    key_vaults                  = ["app-secrets"]
    runtime                     = { node_version = "20-lts" }
    app_settings = {
      DATABASE_PASSWORD = "@Microsoft.KeyVault(SecretUri=REPLACE_WITH_SECRET_URI)"
    }
  },
  {
    key                         = "web-two"
    name                        = "REPLACE_WITH_WEB_APP_TWO"
    resource_group_name         = "REPLACE_WITH_RESOURCE_GROUP"
    location                    = "REPLACE_WITH_REGION"
    service_plan_key            = "web-plan"
    user_assigned_identity_keys = ["web-mi"]
    key_vaults                  = ["app-secrets"]
    runtime                     = { python_version = "3.12" }
  }
]

azure_sql_server = [
  {
    key                   = "sql-primary"
    name                  = "REPLACE_WITH_SQL_SERVER"
    resource_group_name   = "REPLACE_WITH_RESOURCE_GROUP"
    location              = "REPLACE_WITH_REGION"
    azuread_admin_login   = "REPLACE_WITH_ENTRA_ADMIN_DISPLAY_NAME"
    azuread_admin_object_id = "REPLACE_WITH_ENTRA_ADMIN_OBJECT_ID"
  }
]

azure_sql_database = [
  {
    key         = "orders-db"
    name        = "orders"
    server_key  = "sql-primary"
    sku_name    = "GP_S_Gen5_2"
  },
  {
    key         = "billing-db"
    name        = "billing"
    server_key  = "sql-primary"
    sku_name    = "GP_S_Gen5_2"
  }
]
```

- Each Web App receives a system-assigned identity. Optional user-assigned identities are created from `azure_managed_identity` and attached through `user_assigned_identity_keys`. Use a stable `key` (Terraform address identity) distinct from the Azure `name`; this lets you change resource naming without changing the `for_each` key. Add one object per app—20 or more app objects are supported without additional module blocks.
- List each Key Vault input key in an app's `key_vaults` to grant its system identity the `Key Vault Secrets User` role. Identities can also list `key_vaults` in their own definition. Override the role only when a stronger permission is justified.
- Key Vault uses Azure RBAC by default, purge protection, 90-day soft-delete retention, and public network access disabled by default. Private endpoint and private DNS zone IDs are supplied through `azure_private_endpoint`.
- SQL database entries reference a SQL server by `server_key`; the root wires the server ID. Add one object per database; a single server can host many databases and the same database name may be reused on different servers when the stable keys differ. SQL administrator credentials are stored in a Key Vault secret as a JSON map keyed by SQL server Terraform key, for example `{"sql-primary":{"administrator_login":"...","administrator_login_password":"..."}}`, and injected into the sensitive `azure_sql_server_credentials` variable at runtime. Do not add this map to the environment tfvars file: `-var-file` values take precedence over `TF_VAR_*` environment variables.
- App settings should contain Key Vault reference URIs, never literal secret values.

### Bulk name arrays for large estates

When many apps share the same baseline configuration, use the concise names-array interface. This creates one Web App per name and applies the shared defaults. The same pattern supports 20, 50, or more names without adding more module blocks.

```hcl
azure_web_app_names = [
  "web-01", "web-02", "web-03", "web-04", "web-05",
  "web-06", "web-07", "web-08", "web-09", "web-10",
  "web-11", "web-12", "web-13", "web-14", "web-15",
  "web-16", "web-17", "web-18", "web-19", "web-20"
]

azure_web_app_defaults = {
  resource_group_name         = "REPLACE_WITH_RESOURCE_GROUP"
  location                    = "REPLACE_WITH_REGION"
  service_plan_key            = "web-plan"
  user_assigned_identity_keys = ["web-mi"]
  key_vaults                  = ["app-secrets"]
  runtime                     = { node_version = "20-lts" }
  app_settings                = { APP_ENV = "prod" }
}

azure_sql_database_names = [
  "orders", "billing", "inventory", "customers", "reporting"
]

azure_sql_database_defaults = {
  server_key            = "sql-primary"
  sku_name              = "GP_S_Gen5_2"
  zone_redundant        = true
  backup_retention_days = 35
}
```

The names-array shorthand intentionally uses each resource name as its Terraform key. If resource names may change, or if individual apps/databases need different plans, servers, SKUs, networks, identities, or settings, use the object-array form above with an explicit immutable `key` separate from the cloud resource `name`. Do not configure both shorthand and object arrays with overlapping names/keys; input validation rejects collisions.

### AWS and Google Cloud

All AWS and GCP modules are also configured in their provider root `main.tf`. Each input variable is a list of objects with a stable `key`; use one item per independent resource. Dependencies can be supplied explicitly by IDs or through the supported `vpc_key`, `subnet_keys`, `instance_key`, and related reference fields in the root compositions. Database credentials are managed by AWS RDS Secrets Manager integration where supported. GCP monitoring credentials are supplied separately through the sensitive `gcp_monitoring_credentials` input.

## Environment isolation

Example variable files are provided under:

- `providers/azure/environment/{dev,qa,staging,prod}.tfvars.example`
- `providers/aws/environment/{dev,qa,staging,prod}.tfvars.example`
- `providers/gcp/environment/{dev,qa,staging,prod}.tfvars.example`

Copy the appropriate example to a local `.tfvars` file and populate it. Real `.tfvars` and `.tfvars.json` files are ignored by Git. Keep provider IDs and infrastructure values in environment-specific configuration; keep credentials in the cloud secret manager or protected pipeline variables.

Remote state is isolated by environment:

- Azure: `<environment>/terraform.tfstate`
- AWS: `<environment>/terraform.tfstate`, with S3 native lock files enabled
- GCP: `terraform/<environment>` GCS prefix

Bootstrap the remote-state resources first using the provider's `bootstrap/` root and an explicitly secured bootstrap state. Migrate local state with `terraform init -migrate-state` after backend access is verified. Do not delete bootstrap state resources while workload states depend on them.

### Backend security

- **Azure:** Storage account blob versioning, OAuth by default, shared-key authentication disabled, deny-by-default network rules, and public access disabled by default. Use a self-hosted runner with private network connectivity when the backend is private. The OIDC principal needs least-privilege Blob Data access to the state container.
- **AWS:** Versioned S3 state bucket, KMS encryption, public access block, and S3 native lock files. The deployment role needs only the backend and workload permissions it requires.
- **GCP:** Versioned GCS bucket, uniform bucket-level access, public access prevention, and retention controls. The federated service account needs least-privilege object access.

Terraform sensitive variables redact CLI output but **do not remove values from Terraform state**. Restrict state access, enable provider-side encryption and versioning, and keep state retention and recovery procedures.

## CI/CD and OIDC

### GitHub Actions

- `.github/workflows/terraform-ci.yml` runs format checks and initializes/validates every child module, bootstrap root, and provider composition root.
- `.github/workflows/terraform-deploy.yml` supports Azure, AWS and GCP OIDC authentication, remote-state initialization, plan, apply, and a separately confirmed destroy operation.
- Configure GitHub Environments named `dev`, `qa`, `staging`, and `prod`. Require reviewers for staging/production according to release policy.
- Configure environment variables for provider identity and backend details, and an environment secret `TERRAFORM_INPUTS_JSON` containing non-secret resource arrays. Do not include SQL/Grafana passwords in this JSON.
- Azure SQL credentials are read from the configured Azure Key Vault secret; GCP monitoring credentials are read from Google Secret Manager. AWS RDS manages master credentials in Secrets Manager where the module enables it.

### Azure DevOps

`azure-pipelines.yml` provides the Azure deployment path using an Azure Resource Manager service connection configured with Workload Identity Federation. Configure variable groups `terraform-shared` and `terraform-dev`, `terraform-qa`, `terraform-staging`, `terraform-prod`, and protected Azure DevOps environments named `terraform-dev`, `terraform-qa`, `terraform-staging`, and `terraform-prod`.

The Azure DevOps pipeline currently targets the Azure root. The GitHub Actions workflow is the multi-cloud deployment entry point; AWS/GCP Azure DevOps service-connection variants are not yet implemented.

### Secret inputs

- Store `TERRAFORM_INPUTS_JSON` as a protected environment/variable-group value containing only non-secret infrastructure inputs.
- Store Azure SQL server credential JSON in Azure Key Vault under the configured secret name. It is mapped to the sensitive Terraform variable at runtime.
- Store GCP Grafana credential JSON in Google Secret Manager under the configured secret name.
- Never commit service-principal secrets, cloud access keys, passwords, state files, plan files, or real variable files.
- Key Vault references in application settings avoid placing application secret values in app configuration. Resource arguments that require a secret can still persist in Terraform state.

## Validation and release gates

The CI workflow must pass `terraform fmt -check -recursive`, `terraform init -backend=false`, and `terraform validate` for every module and composition root. Then complete:

1. Static security and policy checks (misconfiguration, insecure defaults, secret scanning, policy-as-code).
2. Module contract tests for required inputs, outputs, uniqueness, invalid values, and dependency wiring.
3. Provider-specific plans in disposable, approved sandboxes.
4. Apply, connectivity, identity-to-Key-Vault, database, backup/restore, and destroy/recovery tests.
5. Cost estimation, quota checks, policy compliance, drift detection, and rollback/runbook exercises.
6. Protected production deployment with reviewed plan and approval.

**No cloud resources have been deployed by this change.** A successful format/validate run does not prove that a provider plan or a real cloud deployment will succeed. Production readiness is not declared until the above gates pass.

## Next phase

After the Infra product passes its independent acceptance matrix, integrate it into the Engineering Products Platform as a deployable, testable and marketplace-manageable product. Do not register it as complete based only on the module count or catalogue entry.

## Environment-specific resource definitions

Keep the environment-specific resource inventory in `providers/<cloud>/environment/{dev,qa,staging,prod}.tfvars`. The checked-in `.tfvars.example` files are templates only. Create real `.tfvars` files locally (they are gitignored) and pass them with `-var-file=environment/dev.tfvars`. For CI/CD, store the HCL file contents in the protected `TERRAFORM_TFVARS` environment secret/variable and materialize it only in the ephemeral runner workspace.

For Azure, define one object per Web App in `azure_web_apps` and one object per database in `azure_sql_database`. Each item has a stable `key` independent from the Azure resource `name`. Use `service_plan_key` to share or select an App Service Plan, `user_assigned_identity_keys` to attach multiple managed identities, `key_vaults` to grant the app identity Key Vault Secrets User access, and `server_key` to associate each database with its SQL server. This scales to dozens of apps/databases while preserving predictable Terraform addresses. Use a separate plan/approval for production changes and retain the database/server deletion safeguards.
