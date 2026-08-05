# Terraform Zsh Plugin

Zsh functions and aliases for common Terraform workflows.

## Requirements

- [Terraform](https://www.terraform.io/) in `PATH`

## Installation

With [antidote](https://github.com/mattmc3/antidote), add the local plugin path to `~/.zsh_plugins.txt`:

```text
/Users/matt/zsh-plugins/terraform-plugin-zsh
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
| `tfaa`   | `terraform apply -auto-approve`         |
| `tfinit` | `tinitgcp`                              |
| `tff`    | `terraform fmt -recursive`              |
| `tfp`    | `terraform plan`                        |
| `tfsl`   | `terraform state list`                  |
| `tfss`   | `terraform state show`                  |
| `tfv`    | `terraform validate`                    |
| `tfrm`   | `rm -rf .terraform .terraform.lock.hcl` |

## Notes

- `tfa`, `tfc`, and `tpv` expect `environments/<environment>.tfvars` relative to the current directory.
- Use `tfu` only when you are certain the state lock is stale.
- `tfinit` requires the external `tinitgcp` command.
- Configure `TF_PLUGIN_CACHE_DIR` outside this plugin if you use it.
