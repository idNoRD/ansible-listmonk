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
This role supports only Amazon Linux 2023, Fedora 37/38, or RHEL 8/9.

---

## 📍 ROADMAP: Development Plan

### ✅ Completed
- [x] Init empty role

### 🛠️ In Progress / Planned
- [ ] Add an OS check
- [ ] Create system group (`listmonk`)
- [ ] Create dedicated user (`listmonk`, non-login)
- [ ] Download latest Listmonk release binary from GitHub
- [ ] Extract and install Listmonk binary to `/opt/listmonk` or `/usr/local/bin`
- [ ] Set proper file ownership and permissions
- [ ] Create and configure `listmonk.toml` via Ansible template
- [ ] Create systemd service unit for Listmonk
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

| Variable                | Description                                                                                       | Default value                               |
|------------------------|---------------------------------------------------------------------------------------------------|---------------------------------------------|
| `lm_version`           | Listmonk release path (from [GitHub Releases](https://github.com/knadh/listmonk/releases))        | `v5.0.0/listmonk_5.0.0_linux_amd64.tar.gz`  |
| `lm_config_admin_password` | Password for the Listmonk admin user                                                         | `listmonk`                                  |
| `lm_config_db_password`    | Password for the PostgreSQL database                                                         | `listmonk`                                  |

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
    lm_version: "v5.0.0/listmonk_5.0.0_linux_amd64.tar.gz"
  roles:
    - idNoRD.listmonk
```

License
---

MIT
