# Lesson 18

This section documents exercises from lesson 18

---

### 1 Lamp stack implementation with Ansible


#### 1.1 Project requirements

- Create project structure with roles:
    - `base` role, basic tools
    - `web` role, apache install and config
    - `database` role, MySQL install and config
    - `php` role, PHP install and config
    - `app` role, implement basic PHP app with `database` connection


Each role should include:
    - Tasks
    - Defaults
    - Templates (if needed)
    - Handlers (if needed)

#### 1.2 Functionality

- Apache should be configured with PHP module.
- Database and user should be created in MySQL
- PHP app should be connected to database and show something
- Ansible configuration should be idempotent.

#### 1.3 Documentaion

- Create `README.md` (this file)
- Describie what every role does


#### Roles description

`base`

Responsible for basic system configuration.

Tasks:

- Install required system packages
- Prepare the server environment

`web`

Responsible for Apache web server deployment.

Tasks:

- Install Apache
- Manage Apache service
- Provide handler for Apache restart when configuration changes

`database`

Responsible for MySQL database setup.

Tasks:

- Install MySQL server
- Create application database
- Create database user
- Grant privileges for the application
- Create required database tables

`php`

Responsible for PHP environment.

Tasks:

- Install PHP packages
- Install Apache PHP module
- Install MySQL PHP extension

`app`

Responsible for application deployment.

Tasks:

- Remove default Apache index page
- Deploy PHP application files
- Configure database connection using Ansible templates

## Usage

Update the `inventory` file with the target server IP address.

Example:

```text
[all]
xxx.xxx.x.xx
```

Run the playbook:

```bash
ansible-playbook -i inventory site.yml --ask-pass
```