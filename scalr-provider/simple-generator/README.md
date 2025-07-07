# Scalr Terraform Environments and Workspaces Automation

This Terraform configuration automates the creation of multiple Scalr environments and associated workspaces using the official Scalr provider.

## 📦 What This Does

- **Creates 20 Scalr environments** named `provider-env-0` through `provider-env-19`
- **Creates 20 VCS-driven workspaces**, 2 per environment
- **Creates 200 CLI-driven workspaces**, 10 per environment
- Connects VCS workspaces to a GitHub repository with dry runs enabled

## 🧰 Prerequisites

- Terraform >= 1.0 or OpenTofu
- A valid Scalr API token
- Your Scalr account and environment IDs
- VCS provider already connected in Scalr (e.g., GitHub)

## 🚀 Usage

### 1. Clone the repository or copy this configuration

```bash
git clone https://github.com/your-org/scalr-provisioning.git
cd scalr-provisioning
```

## 2. 🔧 Set Required Variables

You must provide several input variables for the configuration to work. You can do this in **two ways**:

---

### ✅ Option A: Use a `terraform.tfvars` file

Create a file named `terraform.tfvars` in the root of your project and paste the following, replacing the values with your own:

```hcl
hostname        = "your-scalr-host"
api_token       = "your-scalr-api-token"
account_id      = "your-scalr-account-id"
vcs_provider_id = "your-vcs-provider-id"
```


> ℹ️ Optionally, you can also define `environment_id` if you want to target existing environments instead of creating new ones.

---

### ✅ Option B: Use environment variables

Set variables directly in your terminal session:

```bash
export TF_VAR_hostname="your-scalr-host"
export TF_VAR_api_token="your-scalr-api-token"
export TF_VAR_account_id="your-scalr-account-id"
export TF_VAR_vcs_provider_id="your-vcs-provider-id"
```

---

### 📄 Variable Reference

| Variable Name       | Description                                             | Required | Example Value                   |
|---------------------|---------------------------------------------------------|----------|---------------------------------|
| `hostname`          | Your Scalr hostname                                     | No       | `acc-name.scalr-host` |
| `api_token`         | API token used to authenticate with Scalr              | Yes      | `scalr.pat.xxxxxx`              |
| `account_id`        | Scalr account identifier                                | Yes      | `acc-xxxxxxxxxx`                |
| `vcs_provider_id`   | ID of the connected VCS provider (GitHub, GitLab, etc.) | Yes      | `vcs-xxxxxxxxxx`                |
| `environment_id`    | (Optional) Existing environment ID to reuse             | No       | `env-xxxxxxxxxx`                |

---

## 3. 🧪 Initialize and Apply

```bash
terraform init
terraform apply
```

---

## 🛠️ Provider Configuration

The Scalr provider is configured as follows:

```hcl
terraform {
  required_providers {
    scalr = {
      source  = "registry.scalr.io/scalr/scalr"
      version = "3.2.0"
    }
  }
}

provider "scalr" {
  hostname = var.hostname
  token    = var.api_token
}
```

---

## 🧪 Workspace Layout Logic

- Every 10 environments receive:
    - 1 VCS-driven workspace (20 total, index `0-19`)
    - 10 CLI workspaces (200 total, index `0-199`)
- Workspace assignment to environments is managed via:

```hcl
floor(count.index / 10)
```

---

## 🧑‍💻 Repo Details for VCS Workspaces

The following GitHub repo is used as an example for VCS-driven workspaces:

```hcl
vcs_repo {
  identifier       = "Heshercat/tf-magicanimals-plan"
  branch           = "master"
  dry_runs_enabled = true
}
```

> 🔁 Replace with your own repo and branch as needed.

---