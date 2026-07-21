# Web role

## Purpose

The web role installs and configures the Apache web server.

## Responsibilities

- Install Apache HTTP server
- Ensure Apache service is running
- Manage Apache configuration changes
- Restart Apache when configuration changes occur

## Handlers

The role includes a handler:

- Restart Apache service after configuration changes

## Variables

Defined in:

- `roles/web/defaults/main.yml`

Example variables:

- `web_package` - Apache package name
- `web_service` - Apache service name