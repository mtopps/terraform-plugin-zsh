# Terraform Zsh Plugin

Zsh functions and aliases for common Terraform workflows.

## Requirements

- Zsh for loading the plugin
- [Terraform](https://www.terraform.io/) in `PATH`
- Bash 4 or newer in `PATH` for `tfinit`
- Backend credentials available to Terraform
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli), logged in with the correct subscription selected, when using an AzureRM backend

## Installation

Clone this repository, then add its absolute path to the [antidote](https://github.com/mattmc3/antidote) plugin list at `~/.zsh_plugins.txt`:

```text
/path/to/terraform-plugin-zsh
```

Start a new shell to load the plugin.

## Commands

| Command                            | Description                                             |
| ---------------------------------- | ------------------------------------------------------- |
| `tfinit <environment>`             | Initialize Terraform with the configured remote state  |
| `tfinit-create <backend> <env>...` | Create a `.tfinit` configuration interactively          |
| `tfvars-create <folder> <env>...`  | Create a variable-file directory and `.tfvars` files    |
| `tfa <environment>`                | Apply with the environment's `.tfvars` file             |
| `tfc <environment>`                | Open a console with the environment's `.tfvars` file    |
| `tfi <environment> <address> <id>` | Import a resource into Terraform state                  |
| `tpv <environment>`                | Plan with the environment's `.tfvars` file              |
| `tfu <environment>`                | Detect and force-unlock a stuck state lock              |
| `tflist`                           | List all commands provided by this plugin               |

Run these commands from the Terraform root module. The environment name maps
to a matching `.tfvars` filename. For example:

```console
tfvars-create environments dev prod
tfinit-create gcp dev prod
tfinit dev
tpv dev
tfa dev
tfc dev
tfi dev 'google_storage_bucket.assets' 'assets-bucket-id'
tfu dev
```

## Terraform Project Structure

The root module must contain the Terraform configuration and one supported
variable-file directory. Only one of `environments/`, `env/`, or `envs/` is
needed:

```text
terraform-project/
├── .tfinit
├── backend.tf
├── main.tf
└── environments/       # Alternatively: env/ or envs/
	├── dev.tfvars
	└── prod.tfvars
```

The variable-file commands search in this order:

1. `environments/<environment>.tfvars`
2. `env/<environment>.tfvars`
3. `envs/<environment>.tfvars`

Create one of these layouts and its empty environment files with:

```console
tfvars-create environments dev nprd prod
tfvars-create env dev prod
tfvars-create envs sand
```

The first argument must be `environments`, `env`, or `envs`. Existing `.tfvars`
files are left unchanged. Run `tfvars-create --help` for command usage.

The `.tfinit` file and a Terraform backend block are required only by
`tfinit`. The backend block may be in any `.tf` file below the current
directory, but all discovered backend blocks must use the same supported type:
`azurerm` or `gcs`.

## Aliases

| Alias    | Command                                 |
| -------- | --------------------------------------- |
| `tf`     | `terraform`                             |
| `tfaa`    | `terraform apply -auto-approve`         |
| `tff`    | `terraform fmt -recursive`              |
| `tfp`    | `terraform plan`                        |
| `tfsl`   | `terraform state list`                  |
| `tfss`   | `terraform state show`                  |
| `tfv`    | `terraform validate`                    |
| `tfrm`   | `rm -rf .terraform .terraform.lock.hcl` |

## `tfinit`

Create a `.tfinit` file in the directory where Terraform is initialized. The
backend is detected from the Terraform `backend` block. Define state locations
in the `state_location` associative array:

```bash
state_location["prod"]="my-terraform-state/tfstate/${folder_name}/${env}"
state_location["nprd"]="my-terraform-state/tfstate/${folder_name}/${env}"
state_location["sand"]="my-terraform-state/tfstate/${folder_name}/${env}"
```

For AzureRM, use
`resource-group/storage-account/container` as the state location:

```bash
state_location[dev]="rg-terraform/terraformstate/tfstate"
state_location[prod]="rg-terraform/terraformstate/tfstate"
```

Initialize an environment with:

```console
tfinit dev
```

Use `tfinit -d dev` to enable shell tracing while troubleshooting.

### Creating `.tfinit`

Run `tfinit-create` from the Terraform root module. Pass the cloud name and one
or more environments; the command prompts for the backend storage details and
writes `.tfinit` in the current directory.

Run `tfinit-create --help` to display command usage and examples.

For a GCP project:

```console
tfinit-create gcp dev nprd prod
GCS bucket: my-terraform-state
State prefix [tfstate]:
```

This creates a GCS state location for each environment using
`<bucket>/<prefix>/${folder_name}/${env}`.

For an Azure project:

```console
tfinit-create azure dev prod
Azure resource group: rg-terraform
Azure storage account: terraformstate
Azure blob container: tfstate
```

All Azure environments use the entered resource group, storage account, and
container. `tfinit` creates a distinct state key from the Terraform folder and
environment.

The generator uses friendly cloud names, but the Terraform backend blocks keep
their Terraform names:

| Generator argument | Terraform backend block |
| ------------------ | ----------------------- |
| `gcp`              | `backend "gcs"`         |
| `azure`            | `backend "azurerm"`     |

If `.tfinit` already exists, the command asks before replacing it.

## Notes

- Use `tfu` only when you are certain the state lock is stale.
- Configure `TF_PLUGIN_CACHE_DIR` outside this plugin if you use it.
