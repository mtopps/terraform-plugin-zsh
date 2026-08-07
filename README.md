# Terraform Zsh Plugin

Zsh functions and aliases for common Terraform workflows.

## Requirements

- [Terraform](https://www.terraform.io/) in `PATH`

## Installation

Clone this repository, then add its absolute path to the [antidote](https://github.com/mattmc3/antidote) plugin list at `~/.zsh_plugins.txt`:

```text
/path/to/terraform-plugin-zsh
```

Start a new shell to load the plugin.

## Functions

| Function            | Description                                             |
| ------------------- | ------------------------------------------------------- |
| `tfa <environment>` | Apply with `environments/<environment>.tfvars`          |
| `tfc <environment>` | Open a console with `environments/<environment>.tfvars` |
| `tpv <environment>` | Plan with `environments/<environment>.tfvars`           |
| `tfu <environment>` | Detect and force-unlock a stuck state lock              |
| `tflist`            | List all commands provided by this plugin               |

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

```text
tfinit dev
```

## Notes

- `tfa`, `tfc`, and `tpv` expect `environments/<environment>.tfvars` relative to the current directory.
- Use `tfu` only when you are certain the state lock is stale.
- Configure `TF_PLUGIN_CACHE_DIR` outside this plugin if you use it.
