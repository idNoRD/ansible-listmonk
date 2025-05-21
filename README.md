> ⚠️ **Work in Progress**
>
> This Ansible role is currently under active development and is **not yet production-ready**.
>
> We're working on automating the installation and configuration of [Listmonk](https://listmonk.app) on RHEL/CentOS and Fedora-compatible systems like Amazon Linux 2023.
>
> ✅ The role has been initialized and basic structure is in place.  
> 🛠️ Key tasks such as downloading binaries, creating a systemd service, and templating configuration are planned (see [ROADMAP.md](./ROADMAP.md) for details).
>
> Contributions, issues, and feedback are welcome as the role evolves!


# Ansible Role: Listmonk

Ansible role to install and configure [Listmonk](https://listmonk.app)  
This role is primarily intended for Amazon Linux 2023, but it should work on Fedora 37/38, RHEL/CentOS 8/9, Rocky Linux, and AlmaLinux, though testing on these platforms has not been done.

---

## 📍 ROADMAP: Development Plan

### ✅ Completed
- [x] Init empty role
- [x] Add an OS check
- [x] Create system group (`listmonk`)
- [x] Create dedicated user (`listmonk`, non-login)
- [x] Download latest Listmonk release binary from GitHub
- [x] Extract and install Listmonk binary to `/opt/listmonk/bin`
- [x] Create and configure `listmonk.toml` via Ansible template
- [x] Create systemd service unit for Listmonk
### 🛠️ In Progress / Planned
- [ ] Configure data and log directories
- [ ] Start and enable the Listmonk systemd service
- [ ] Add role variables (e.g. port, paths, log level)
- [ ] Optional: Configure PostgreSQL (external or integrated role)
- [ ] Optional: Set up NGINX as a reverse proxy (or expose option)
- [ ] Add basic health check and service status validation
- [ ] Add Molecule tests for role verification
- [ ] Publish role on Ansible Galaxy
- [ ] Improve documentation with usage examples and variable reference

---

## 💡 Suggestions or Contributions

Feel free to open a PR or issue if you'd like to contribute or suggest improvements!

---

## Role Variables

The following are a set of key variables used by the role:

| Variable                | Description                                                                           | Default value                       |
|------------------------|---------------------------------------------------------------------------------------|-------------------------------------|
| `listmonk_version`           | Listmonk version (from [GitHub Releases](https://github.com/knadh/listmonk/releases)) | `v5.0.0`  |
| `listmonk_archive`           | Listmonk archive (from [GitHub Releases](https://github.com/knadh/listmonk/releases)) | `listmonk_5.0.0_linux_amd64.tar.gz` |
| `listmonk_config_admin_password` | Password for the Listmonk admin user 8+ chars                                         | `listmonk`                          |
| `listmonk_config_db_password`    | Password for the PostgreSQL database                                                  | `listmonk`                          |

The following variables are _optional_:

| Variable | Description | Default |
|:---------|:------------|:---------|
|`listmonk_service_user`| posix account username | `listmonk` |
|`listmonk_service_group`| posix account group | `listmonk` |
|`listmonk_service_restart_always`| systemd restart always behavior activation | `False` |
|`listmonk_service_restart_on_failure`| systemd restart on-failure behavior activation | `False` |
|`listmonk_service_startlimitintervalsec`| systemd StartLimitIntervalSec | `300` |
|`listmonk_service_startlimitburst`| systemd StartLimitBurst | `5` |
|`listmonk_service_restartsec`| systemd RestartSec | `10s` |
|`listmonk_service_pidfile`| pid file path for service | `/run/listmonk/listmonk.pid` |

> Other configuration variables can be found in [`defaults/main.yml`](defaults/main.yml).

---

## Dependencies

This role assumes the following are already installed or managed externally:

- PostgreSQL (configured and running)
- Certbot (or alternative certificate provisioning tool)
- NGINX (or alternative reverse proxy solution)

---

## Example Playbook

```yaml
---
- hosts: listmonk_servers
  vars:
    listmonk_config_admin_password: "listmonk"
    listmonk_config_db_password: "listmonk"
  roles:
    - idNoRD.listmonk
```

License
---

MIT
