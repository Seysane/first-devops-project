# Database role

## Purpose

The database role installs and configures MySQL database server for the application.

## Responsibilities

- Install MySQL packages
- Create application database
- Create database user
- Grant required privileges
- Create application database tables

## Error handling

Database operations are protected using Ansible block/rescue/always structure.

## Variables

Defined in:

- `roles/database/defaults/main.yml`
- `group_vars/all.yml`

Example variables:

- `database_name`
- `database_user`
- `database_password`
- `database_packages`