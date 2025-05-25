# Ansible Role: Listmonk

Ansible role to install and configure [Listmonk](https://listmonk.app)  
This role is primarily intended for Amazon Linux 2023, but it should also work on Fedora, RHEL distributions such as CentOS, Rocky Linux, and AlmaLinux, though testing on these platforms has not been done.

---

## 📍 ROADMAP: Development Plan

### ✅ Completed
- [x] Add RedHat os_family OS check
- [x] Create dedicated system user/group (`listmonk:listmonk`)
- [x] Download latest Listmonk release archive
- [x] Extract and install Listmonk binary to `/opt/listmonk/bin`
- [x] Create and configure `config.toml` via Ansible template
- [x] Create, start and enable `listmonk.service` systemd service for Listmonk
- [x] Add role variables (see `defaults/main.yml`)
- [x] Listmonk works with a PostgreSQL database already installed on the same machine. `Note: This Ansible role does not install or manage PostgreSQL.`
- [x] Add basic health check and service status validation
- [x] Publish [role on Ansible Galaxy](https://galaxy.ansible.com/ui/standalone/roles/idNoRD/listmonk)
- [x] Admin credentials are not stored in the Listmonk config file. They are provided as environment variables only during the initial bootstrap (one-time setup).
### 🛠️ In Progress / Planned
- [ ] Configure data and log directories
- [ ] Optional: Set up NGINX as a reverse proxy (or expose option)
- [ ] Add Molecule tests for role verification
- [ ] Improve documentation with usage examples and variable reference

---

## 💡 Suggestions or Contributions

Feel free to open a PR or issue if you'd like to contribute or suggest improvements!

---

## Role Variables

The following are a set of key variables used by the role:

| Variable                                     | Description                                                                  | Default value          |
|----------------------------------------------|------------------------------------------------------------------------------|------------------------|
| `listmonk_version`                           | Listmonk version (from [GitHub Releases](https://github.com/knadh/listmonk/releases)) | `v5.0.0`               |
| `listmonk_archive`                           | Listmonk archive (from [GitHub Releases](https://github.com/knadh/listmonk/releases)) | `listmonk_5.0.0_linux_amd64.tar.gz` |
| `listmonk_bootstrap_LISTMONK_ADMIN_USER`     | Username for the Listmonk admin user                                         | `listmonk`             |
| `listmonk_bootstrap_LISTMONK_ADMIN_PASSWORD` | Password for the Listmonk admin user 8+ chars                                | `changeit`             |
| `listmonk_config_db_password`                | Password for the PostgreSQL database                                         | `listmonk`             |

> Other configuration variables can be found in [`defaults/main.yml`](defaults/main.yml).

---

## Dependencies

This role assumes the following are already installed or managed externally:

- PostgreSQL (configured and running)
- Certbot (or alternative certificate provisioning tool)
- NGINX (or alternative reverse proxy solution)

---

## Example Playbook
```text
ansible-galaxy role install idNoRD.listmonk
```
```yaml
---
- hosts: listmonk_server
  vars:
    listmonk_version: "v5.0.0"
    listmonk_archive: "listmonk_5.0.0_linux_amd64.tar.gz"
    listmonk_bootstrap_LISTMONK_ADMIN_USER: "listmonk"
    listmonk_bootstrap_LISTMONK_ADMIN_PASSWORD: "changeAdminPassword"
    listmonk_config_db_host: "localhost"
    listmonk_config_db_database: "listmonk"
    listmonk_config_db_user: "listmonk"
    listmonk_config_db_password: "changeDbPassword"
  roles:
    - idNoRD.listmonk
```
```yaml
---
- hosts: listmonk_server
  vars:
    listmonk_version: "v5.0.0"
    listmonk_archive: "listmonk_5.0.0_linux_amd64.tar.gz"
    listmonk_bootstrap_LISTMONK_ADMIN_USER: "listmonk"
    listmonk_bootstrap_LISTMONK_ADMIN_PASSWORD: "changeAdminPassword"
    listmonk_config_db_host: "localhost"
    listmonk_config_db_database: "listmonk"
    listmonk_config_db_user: "listmonk"
    listmonk_config_db_password: "changeDbPassword"
    listmonk_override_settings: true
    listmonk_api_settings_payload:
      app.site_name: "Mailing list (managed by Ansible role)"
      app.lang: "en"
      upload.provider: "filesystem"
      smtp:
        - enabled: true
          host: "smtp.configured-by-ansible.local"
          hello_hostname: ""
          port: 25
          auth_protocol: "None"
          username: "username"
          email_headers:
            - {}
          max_conns: 10
          max_msg_retries: 2
          idle_timeout: "15s"
          wait_timeout: "5s"
          tls_type: "STARTTLS"
          tls_skip_verify: false
  roles:
    - idNoRD.listmonk
```
License
---

MIT
