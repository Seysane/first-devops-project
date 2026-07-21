# Application role

## Purpose

The application role deploys the PHP application files to the web server.

## Responsibilities

- Remove default Apache index page
- Deploy application source files
- Configure database connection using templates
- Provide application files required for testing

## Templates

Used templates:

- `index.php.j2`

Template variables are provided by Ansible inventory and group variables.

## Variables

Defined in:

- `roles/app/defaults/main.yml`
- `group_vars/all.yml`

Example variables:

- `app_path`
- `database_name`
- `database_user`
- `database_password`