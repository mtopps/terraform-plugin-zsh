0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Terraform functions
tfa() {
  if [[ -z "$1" ]]; then
    echo "Usage: tfa <environment>"
    return 1
  fi
  terraform apply -var-file=environments/$1.tfvars
}

tfc() {
  if [[ -z "$1" ]]; then
    echo "Usage: tfc <environment>"
    return 1
  fi
  terraform console -var-file=environments/$1.tfvars
}

tpv() {
  if [[ -z "$1" ]]; then
    echo "Usage: tpv <environment>"
    return 1
  fi
  terraform plan -var-file=environments/$1.tfvars
}

tfu() {
  if [[ -z "$1" ]]; then
    echo "Usage: tfu <environment>"
    return 1
  fi

  # Run terraform plan to capture lock error
  output=$(terraform plan -var-file=environments/$1.tfvars 2>&1)

  # Extract lock ID from error message (format: │   ID:        1784412084112552)
  lock_id=$(echo "$output" | grep "ID:" | head -1 | awk -F': ' '{print $2}' | xargs)

  if [[ -z "$lock_id" ]]; then
    echo "Error: Could not find lock ID in terraform plan output"
    echo "Full output:"
    echo "$output"
    return 1
  fi

  echo "Found lock ID: $lock_id"
  echo "Forcing unlock..."
  terraform force-unlock -force "$lock_id"
}

# Terraform aliases
alias tf='terraform'
alias tfaa="terraform apply -auto-approve"
alias tff='terraform fmt -recursive'
alias tfp='terraform plan'
alias tfsl='terraform state list'
alias tfss='terraform state show'
alias tfv='terraform validate'
alias tfrm='rm -rf .terraform .terraform.lock.hcl'

# List all Terraform commands provided by this plugin
tflist() {
  local -a entries=(
    "tfa:Apply terraform with environment var-file"
    "tfc:Open terraform console with environment var-file"
    "tpv:Plan terraform with environment var-file"
    "tfu:Detect and force-unlock a stuck terraform state lock"
    "tf:terraform"
    "tfaa:terraform apply -auto-approve"
    "tff:terraform fmt -recursive"
    "tfp:terraform plan"
    "tfsl:terraform state list"
    "tfss:terraform state show"
    "tfv:terraform validate"
    "tfrm:Remove .terraform and .terraform.lock.hcl"
  )

  local entry name desc
  for entry in "${entries[@]}"; do
    name="${entry%%:*}"
    desc="${entry#*:}"
    printf "  %-8s %s\n" "$name" "$desc"
  done
}
