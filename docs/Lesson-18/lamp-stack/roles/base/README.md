# Base role

## Purpose

The base role prepares the server for application deployment by installing required system packages and basic dependencies.

## Responsibilities

- Install common system packages
- Prepare the operating system environment
- Provide a base configuration required by other roles

## Variables

Defined in:

- `roles/base/defaults/main.yml`
- `group_vars/all.yml`

Example variables:

- `base_packages` - list of required system packages