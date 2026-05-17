## AWS IAM Management using Terraform (User & Group Management)

### Overview
The lab is based on AWS Academy:\
**Guided Lab: Exploring AWS Identity and Access Management (IAM)**

In this lab, I explored AWS IAM by working with users and groups.  
I assigned users to IAM groups and verified permission using AWS managed policies.

I also used Terraform to automate IAM user-group assignments in AWS.

### Objectives

- Explore existing IAM users and groups in AWS
- Understand IAM policies attached to groups
- Assign IAM users to IAM groups using Terraform
- Verify IAM permissions using AWS CLI and Terraform state
- Demonstrate Infrastructure as Code best practices

### Lab Objective
Implement an IAM structure where access is controlled based on job roles:

| User    | Group        | Permissions |
|---------|-------------|-------------|
| user-1  | S3-Support  | Read-only access to Amazon S3 |
| user-2  | EC2-Support | Read-only access to Amazon EC2 |
| user-3  | EC2-Admin   | View, Start, Stop EC2 instances |

To implement a Role-Based Access Control (RBAC) model:

**Users**
- user-1 → S3-Support Group
- user-2 → EC2-Support Group
- user-3 → EC2-Admin Group

**Groups**
- S3-Support → S3 read-only access
- EC2-Support → EC2 read-only access
- EC2-Admin → EC2 start/stop permissions

**Policies**
- AWS Managed Policies:
  - AmazonS3ReadOnlyAccess
  - AmazonEC2ReadOnlyAccess
- Inline Policy:
  - EC2-Admin custom permissions

**Security Concept Used: Least Privilege Access**

Each user only receives permissions required for their job role:
- No direct user-level permissions
- All access controlled via IAM groups
- Centralized policy management

### What I Did (Solution Overview)

I performed the following tasks:

- Explored existing IAM users: `user-1`, `user-2`, `user-3`
- Explored IAM groups:
  - `S3-Support`
  - `EC2-Support`
  - `EC2-Admin`
- Assigned users to correct groups using Terraform
- Verified group membership using AWS CLI
- Validated IAM permissions through AWS Console testing (manual lab step)

---

### Implementation Steps

#### AWS Authentication Setup

#### Prerequisites

- Terraform ≥ 1.5.0
- AWS CLI installed and configured
- AWS Account credentials
- Pre-created IAM users and groups in AWS account
- Environment Configuration like:  [```aws-env.example.sh```](link-I-will-provide) with name: ```aws-env.sh```

1. Load AWS credentials:

```bash
source aws-env.sh
```

2. Verify authentication:

```bash
aws sts get-caller-identity
```
- expected outcome:
```bash
{
  "UserId": "xxxx",
  "Account": "xxxx",
  "Arn": "arn:aws:sts::xxxx:assumed-role/..."
}
```

3. Terraform Deployment Steps
- Initialize Terraform
```bash
terraform init
```
Downloads AWS provider and initializes working directory.

- Validate configuration
```bash
terraform validate
```
Ensures Terraform configuration syntax is correct.

- Format code
```bash
terraform fmt
```
Auto-formats Terraform files.

- Preview changes
```bash
terraform plan
```

- Apply changes
```bash
terraform apply
```
Confirm with:
```bash
yes
```

4. Terraform state verification
```bash
terraform state list
```

- output:

```bash
data.aws_iam_group.ec2_admin
data.aws_iam_group.ec2_support
data.aws_iam_group.s3_support
data.aws_iam_user.user1
data.aws_iam_user.user2
data.aws_iam_user.user3
aws_iam_user_group_membership.user1_membership
aws_iam_user_group_membership.user2_membership
aws_iam_user_group_membership.user3_membership
```

- specific mapping
```bash
terraform state show aws_iam_user_group_membership.user1_membership
```
```bash
# aws_iam_user_group_membership.user1_membership:
resource "aws_iam_user_group_membership" "user1_membership" {
    groups = [
        "S3-Support",
    ]
    id     = "terraform-20260517115945008600000002"
    user   = "user-1"
}
```

- Terraform Outputs
```bash
terraform output
```
```bash
users = [
  "user-1",
  "user-2",
  "user-3",
]
```
---
- **Note**:
*Users, Groups, and Roles are assigned Policies, and those Policies define Permissions.*
---
