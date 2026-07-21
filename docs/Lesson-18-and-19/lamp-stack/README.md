# Lesson 18 and 19

This section documents exercises from lesson 18 and 19

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

Install required Ansible collections:

```bash
ansible-galaxy collection install -r requirements.yml
```
#### 1.2 Functionality

- Apache should be configured with PHP module.
- Database and user should be created in MySQL
- PHP app should be connected to database and show something
- Ansible configuration should be idempotent.

#### 1.3 Documentation

- Create `README.md` (this file)
- Describe what every role does


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

### Usage

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


### 2 Multi-Environment Management

#### 2.1 Exercise requirements

Create `group_vars` directory with files for every environment such as:
- development (dev.yml)
- staging (staging.yml)
- production (prod.yml)

Configure the environments:

Development:
- debug mode on

Staging:
- configuration like production one

Production:
- Strict security, optimization

Implement switches between environments

Use tags to select specific tasks

Add variable for environment selection

#### 2.2 Environment selection

The environment can be selected using the `target_env` variable.

```bash
ansible-playbook -i inventory site.yml --ask-pass -e "target_env=prod"
```

#### 2.3 Available tags

The playbook supports selective task execution using tags:

- `web` - Apache tasks
- `database` - MySQL tasks
- `php` - PHP tasks
- `app` - Application deployment

Example:

```bash
ansible-playbook -i inventory site.yml --tags database
```

#### 2.4 Testing

```bash
TASK [Check Apache service] **********************************************************************ok: [192.168.1.89]                                                                                                                                                                                  TASK [Verify Apache is running] ******************************************************************ok: [192.168.1.89] => {                                                                               "changed": false,                                                                                 "msg": "Apache is running correctly"                                                          }                                                                                                                                                                                                   TASK [Check PHP installation] ********************************************************************ok: [192.168.1.89]                                                                                                                                                                                  TASK [Verify PHP exists] *************************************************************************ok: [192.168.1.89] => {                                                                               "changed": false,                                                                                 "msg": "PHP is installed correctly"                                                           }                                                                                                                                                                                                   TASK [Check database exists] *********************************************************************ok: [192.168.1.89]                                                                                                                                                                                  TASK [Verify application database exists] ********************************************************ok: [192.168.1.89] => {                                                                               "changed": false,                                                                                 "msg": "Database exists correctly"                                                            }                                                                                                                                                                                                   PLAY RECAP ***************************************************************************************192.168.1.89               : ok=17   changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

---

## Exercises from lesson 19


## Refactoring changes

The project was refactored following Ansible best practices.

### Changes introduced:

- Split the playbook into independent roles:
  - base
  - web
  - database
  - php
  - app

- Added role-specific documentation.

- Introduced environment-specific variables using `group_vars`:
  - dev.yml
  - staging.yml
  - prod.yml

- Added error handling using Ansible blocks:
  - block
  - rescue
  - always

- Improved task execution control by adding tags.

- Added `requirements.yml` to manage external Ansible collections.

- Improved idempotency by using native Ansible modules instead of shell commands.

---

## Maintainability and readability improvements

The refactored structure improves the project by:

- Separating responsibilities between roles, making the project easier to understand and modify.

- Allowing individual components to be updated independently.

- Making environment-specific changes possible without modifying the main playbook.

- Reducing code duplication by using variables and templates.

- Improving troubleshooting by using tags and structured error handling.

- Making the project easier to extend with additional services in the future.

---

## Running playbooks in different environments

Environment variables are stored in the `group_vars` directory:

```text
group_vars/
├── dev.yml
├── staging.yml
└── prod.yml
```
The target environment can be selected using an extra variable.

### Development environment

```bash
ansible-playbook -i inventory site.yml --ask-pass -e "target_env=dev"
```

#### Staging environment

```bash
ansible-playbook -i inventory site.yml --ask-pass -e "target_env=staging"
```

#### Production environment

```bash
ansible-playbook -i inventory site.yml --ask-pass -e "target_env=prod"
```

Each environment contains different configuration values, allowing the same playbook to be reused across multiple deployment scenarios.


### Testing

Configuration was verified using Ansible assertions:

Apache service status check
PHP installation verification
Database existence verification

Example:
```bash
ansible-playbook -i inventory site.yml --ask-pass
```

Successful execution should finish without failed tasks:

```bash
failed=0
```