## Lesson 29 AWS Exercises

---


# AWS VPC and RDS PostgreSQL Lab

## Exercise 1

The goal of this lab was to build a basic AWS networking and database environment using the AWS CLI.

The exercise covered:

* inspecting an existing VPC
* inspecting subnets and Availability Zones
* inspecting the Internet Gateway
* creating Security Groups
* configuring HTTP/HTTPS access
* allowing PostgreSQL traffic only between Security Groups
* creating an RDS DB Subnet Group
* creating a private PostgreSQL RDS instance

## 2. AWS Region

All resources were created in:

```text
eu-north-1
```

## 3. VPC and Subnets

An existing default VPC was used.

The VPC contained three subnets in different Availability Zones:

```text
VPC
├── eu-north-1a
├── eu-north-1c
└── eu-north-1b
```

The subnets were inspected with:

```bash
aws ec2 describe-subnets --output table
```

The subnets in `eu-north-1a` and `eu-north-1c` were later selected for the RDS DB Subnet Group.

## 4. Internet Gateway

The existing Internet Gateway attached to the VPC was inspected with:

```bash
aws ec2 describe-internet-gateways --output table
```

No additional Internet Gateway was required.

## 5. Security Groups

Two dedicated Security Groups were created:

```text
VPC
├── WebServer Security Group
└── Database Security Group
```

### WebServer Security Group

The WebServer Security Group was created with:

```bash
aws ec2 create-security-group \
  --description "web server security group" \
  --group-name webserver \
  --vpc-id <VPC_ID> \
  --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=WebServerSG},{Key=Environment,Value=Development}]' \
  --region eu-north-1
```

HTTP and HTTPS access was allowed:

```text
Internet
   │
   ├── TCP 80
   └── TCP 443
        │
        ▼
WebServer Security Group
```

Rules were added using:

```bash
aws ec2 authorize-security-group-ingress
```

### Database Security Group

A separate Security Group was created for the database.

PostgreSQL access was restricted to the WebServer Security Group:

```bash
aws ec2 authorize-security-group-ingress \
  --group-id <DATABASE_SG_ID> \
  --protocol tcp \
  --port 5432 \
  --source-group <WEBSERVER_SG_ID> \
  --region eu-north-1
```

This means that the database does not accept PostgreSQL connections directly from the public Internet.

The traffic flow is:

```text
WebServer Security Group
          │
          │ TCP 5432
          ▼
Database Security Group
          │
          ▼
RDS PostgreSQL
```

## 6. DB Subnet Group

An RDS DB Subnet Group was created using two Availability Zones:

```text
postgres-subnet-group
├── eu-north-1a
└── eu-north-1c
```

The DB Subnet Group defines the subnets that RDS can use for database resources.

It does not create a separate database in every subnet.

## 7. RDS PostgreSQL

The RDS instance was configured with:

```text
Identifier:             postgres-dev
Engine:                 PostgreSQL
Version:                18.6
Instance class:         db.t3.micro
Storage:                20 GiB
Storage type:           gp3
Publicly accessible:    No
Region:                 eu-north-1
```

The instance was created with:

```bash
aws rds create-db-instance \
  --db-instance-identifier postgres-dev \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --engine-version 18.6 \
  --master-username postgres \
  --master-user-password '<PASSWORD>' \
  --allocated-storage 20 \
  --storage-type gp3 \
  --db-subnet-group-name postgres-subnet-group \
  --vpc-security-group-ids <DATABASE_SG_ID> \
  --no-publicly-accessible \
  --region eu-north-1
```

The RDS instance was verified with:

```bash
aws rds describe-db-instances \
  --db-instance-identifier postgres-dev \
  --region eu-north-1 \
  --query 'DBInstances[0].[DBInstanceIdentifier,DBInstanceStatus,Engine,EngineVersion,DBInstanceClass,PubliclyAccessible]' \
  --output table
```

## 8. Final Architecture

```text
AWS eu-north-1
│
└── Default VPC
    │
    ├── Internet Gateway
    │
    ├── Subnets
    │   ├── eu-north-1a
    │   ├── eu-north-1b
    │   └── eu-north-1c
    │
    ├── WebServer Security Group
    │   ├── TCP 80  ← Internet
    │   └── TCP 443 ← Internet
    │
    ├── Database Security Group
    │   └── TCP 5432 ← WebServer Security Group
    │
    └── RDS
        └── PostgreSQL 18.6
            ├── db.t3.micro
            ├── 20 GiB gp3
            ├── Private
            └── DB Subnet Group
                ├── eu-north-1a
                └── eu-north-1c
```

## 9. Key Concepts

### VPC

Provides the logical network for AWS resources.

### Subnet

A subdivision of a VPC associated with a specific Availability Zone.

### Internet Gateway

Provides connectivity between a VPC and the Internet when routing and resource configuration allow it.

### Security Group

A stateful virtual firewall controlling inbound and outbound traffic.

### `authorize-security-group-ingress`

Adds an inbound Security Group rule.

### DB Subnet Group

Defines which subnets an RDS database can use.

### RDS

A managed relational database service. AWS manages the underlying infrastructure and database service.

### `--no-publicly-accessible`

Prevents the RDS instance from being directly exposed through a public IP address.

### `--query`

Allows AWS CLI output to be filtered and formatted to display only the required information.

## 10. Result

The lab created a basic private database architecture:

```text
Internet
   │
   │ 80 / 443
   ▼
Web Server
   │
   │ 5432
   ▼
RDS PostgreSQL 18.6
```

The database is not publicly accessible. PostgreSQL traffic is permitted only from the WebServer Security Group.
