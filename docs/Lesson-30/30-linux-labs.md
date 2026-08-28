# Advanced IAM Policy Management

An AWS Identity and Access Management (IAM) project designed to implement **role-based access control (RBAC)** and the **Principle of Least Privilege** for different organizational teams.

The project defines separate IAM roles and policies for Development, QA, DevOps, and Management teams. All IAM policies are stored as JSON files and can be deployed using the AWS CLI.

---

## Project Goals

The main goals of this project are:

* Design a role hierarchy for different teams.
* Implement the Principle of Least Privilege.
* Define team-specific IAM permissions.
* Separate IAM policies from role trust policies.
* Store IAM configuration as code using JSON.
* Deploy IAM resources using AWS CLI.
* Verify and test the assigned permissions.

---

## Architecture

The project uses four main IAM roles:

```text
AWS Account
│
├── Development
│   └── DevelopmentRole
│
├── QA
│   └── QARole
│
├── DevOps
│   └── DevOpsRole
│
└── Management
    └── ManagementRole
```

Each role has a different level of access based on the responsibilities of the corresponding team.

---

## Role Permissions

### Development

The Development team requires access to development infrastructure and application resources.

Expected permissions include:

**EC2**

* Describe instances
* Start instances
* Stop instances

**S3**

* List buckets
* Read objects
* Upload objects

**RDS**

* Describe database instances

Developers should not be able to perform destructive or administrative operations such as:

```text
ec2:TerminateInstances
rds:DeleteDBInstance
iam:*
```

---

### QA

The QA team primarily requires read access to infrastructure and test data.

Expected permissions include:

**EC2**

* Describe instances

**S3**

* List buckets
* Read objects

**RDS**

* Describe database instances

QA should not be able to modify or delete infrastructure.

---

### DevOps

The DevOps team requires broader permissions because it is responsible for managing AWS infrastructure.

Expected areas of access include:

* EC2
* VPC
* ECS
* S3
* RDS
* CloudWatch
* IAM

Even though DevOps requires elevated permissions, the role should still follow the Principle of Least Privilege and should not automatically receive unrestricted `AdministratorAccess`.

---

### Management

The Management team requires visibility into the infrastructure but should not be able to modify it.

Expected permissions include read-only access to:

* EC2
* ECS
* RDS
* CloudWatch

Management should not be able to:

* Create resources
* Modify resources
* Delete resources
* Manage IAM users or roles

---

## Principle of Least Privilege

The project follows the **Principle of Least Privilege**, meaning that each role receives only the permissions required to perform its intended responsibilities.

For example:

```text
Developer
    │
    ├── Can view EC2 instances
    ├── Can start EC2 instances
    ├── Can stop EC2 instances
    │
    └── Cannot terminate EC2 instances

QA
    │
    ├── Can view EC2 instances
    ├── Can read test data
    │
    └── Cannot modify infrastructure

DevOps
    │
    ├── Can manage infrastructure
    └── Has broader operational permissions

Management
    │
    ├── Can view infrastructure
    └── Cannot modify infrastructure
```

The goal is to avoid unnecessarily broad permissions such as:

```json
{
  "Effect": "Allow",
  "Action": "*",
  "Resource": "*"
}
```

---

## Project Structure

```text
advanced-iam-policy-management/
│
├── policies/
│   ├── development-policy.json
│   ├── qa-policy.json
│   ├── devops-policy.json
│   └── management-policy.json
│
├── roles/
│   ├── development-trust-policy.json
│   ├── qa-trust-policy.json
│   ├── devops-trust-policy.json
│   └── management-trust-policy.json
│
├── README.md
└── .gitignore
```

---

## IAM Policies vs Trust Policies

This project separates two different types of IAM policies.

### Permission Policy

A permission policy defines **what actions a role is allowed to perform**.

For example:

```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:DescribeInstances"
  ],
  "Resource": "*"
}
```

This allows the role to retrieve information about EC2 instances.

### Trust Policy

A trust policy defines **who or what is allowed to assume the role**.

Example:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::ACCOUNT_ID:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

`ACCOUNT_ID` should be replaced with the appropriate AWS account ID.

---

# Deployment

The IAM configuration can be deployed using the AWS CLI.

The AWS Management Console is not required for the deployment process.

## Prerequisites

Install and configure the AWS CLI.

Verify the current AWS identity:

```bash
aws sts get-caller-identity
```

The command should return information about the currently authenticated AWS account and IAM identity.

---

## Create IAM Policies

Example:

```bash
aws iam create-policy \
  --policy-name DevelopmentPolicy \
  --policy-document file://policies/development-policy.json
```

The same approach can be used for the other policies:

```bash
aws iam create-policy \
  --policy-name QAPolicy \
  --policy-document file://policies/qa-policy.json

aws iam create-policy \
  --policy-name DevOpsPolicy \
  --policy-document file://policies/devops-policy.json

aws iam create-policy \
  --policy-name ManagementPolicy \
  --policy-document file://policies/management-policy.json
```

---

## Create IAM Roles

Example:

```bash
aws iam create-role \
  --role-name DevelopmentRole \
  --assume-role-policy-document file://roles/development-trust-policy.json
```

Create the remaining roles in the same way:

```bash
aws iam create-role \
  --role-name QARole \
  --assume-role-policy-document file://roles/qa-trust-policy.json

aws iam create-role \
  --role-name DevOpsRole \
  --assume-role-policy-document file://roles/devops-trust-policy.json

aws iam create-role \
  --role-name ManagementRole \
  --assume-role-policy-document file://roles/management-trust-policy.json
```

---

## Attach Policies to Roles

After creating the roles and policies, attach the appropriate policy to each role.

Example:

```bash
aws iam attach-role-policy \
  --role-name DevelopmentRole \
  --policy-arn arn:aws:iam::ACCOUNT_ID:policy/DevelopmentPolicy
```

Repeat the process for the remaining roles.

---

# Verification

Verify that the roles were created successfully:

```bash
aws iam list-roles
```

Inspect a specific role:

```bash
aws iam get-role \
  --role-name DevelopmentRole
```

List policies attached to a role:

```bash
aws iam list-attached-role-policies \
  --role-name DevelopmentRole
```

---

# Permission Testing

The final stage of the project is to verify that each role has the expected permissions.

The tests should verify both:

### Allowed actions

For example, Development should be able to:

```text
ec2:DescribeInstances
ec2:StartInstances
ec2:StopInstances
```

### Denied actions

Development should not be able to:

```text
ec2:TerminateInstances
rds:DeleteDBInstance
iam:CreateUser
iam:DeleteUser
```

The same approach should be used to verify the permissions of QA, DevOps, and Management.

---

# Security Considerations

The project follows several security best practices:

* Avoid using `AdministratorAccess` unless explicitly required.
* Avoid using `Action: "*"` whenever possible.
* Restrict resources using specific ARNs where practical.
* Separate permissions between organizational teams.
* Grant destructive permissions only when required.
* Keep IAM configuration version-controlled.
* Never commit AWS access keys or secret keys.
* Never store credentials in policy files.

---

# AWS Management Console

The project can also be implemented manually through the AWS Management Console.

However, using JSON files and the AWS CLI provides several advantages:

* Configuration can be version-controlled with Git.
* Policies can be reviewed before deployment.
* The same configuration can be reused.
* Changes can be tracked.
* The configuration is easier to reproduce.
* The process is closer to an Infrastructure as Code workflow.

The AWS Console can still be used to verify the resources after deployment.

---

# Expected Result

After completing the project, the AWS account should contain:

```text
IAM Roles
│
├── DevelopmentRole
├── QARole
├── DevOpsRole
└── ManagementRole
```

Each role should have a dedicated permission policy matching the responsibilities of its team.

The final implementation demonstrates knowledge of:

* AWS IAM
* IAM Roles
* IAM Policies
* Trust Policies
* Role-Based Access Control
* Principle of Least Privilege
* AWS CLI
* JSON-based configuration
* IAM security best practices
* Infrastructure as Code concepts

---

# Future Improvements

Possible future improvements include:

* IAM Groups
* IAM Permission Boundaries
* AWS IAM Access Analyzer
* AWS Organizations
* Service Control Policies (SCPs)
* Automated IAM deployment using Boto3
* Terraform-based IAM management
* CI/CD validation of IAM policies
* Automated permission testing
