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


### Developer guide
<details>
<summary>Install and configure Vagrant</summary>

### Provides ability to run a Virtual Machine for dev and testing purposes
#### The purpose of the Vagrantfile is to have locally running "EC2 instance" with available service manager (systemd) because docker doesn't provide convenient way to test it
You can change the script to download the role from your custom branch

Useful commands:
```text
# To start/restart VM from scratch and re-executing all sh scripts that run ansible role
vagrant destroy -f && vagrant up --provision

# To connect to VM
vagrant ssh

# To see an IP address of the VM. So you can open for example: http://192.168.1.123:9000
vagrant ssh -c "ip addr show"
```

### content of Vagrantfile
```text
Vagrant.configure("2") do |config|

config.vm.box = "gbailey/al2023"

config.vm.network "private_network", type: "dhcp"
# To find out an IP address use: 
# vagrant ssh -c "ip addr show"

config.vm.provider "virtualbox" do |vb|
# Display the VirtualBox GUI when booting the machine
vb.gui = true
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    # Customize the amount of CPU on the VM:
    vb.cpus = "3"
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
end

config.vm.provision "shell", name: "install-postgres", path: "postgres-only.sh"
config.vm.provision "shell", name: "install-listmonk", path: "listmonk-only.sh"

end
```
</details>

<details>

<summary>content of postgres-only.sh</summary>

```
#!/bin/bash
set -e

echo "ERROR: PLEASE REPLACE THIS MESSAGE WITH YOUR CUSTOM POSTGRES INSTALL"
exit 1

```
</details>

<details>

<summary>content of listmonk-only.sh</summary>

### Vagrant will execute this script on your Virtual Machine (it is not for your main host machine)
#### The purpose of the bash script is to install ansible, download the role, create a playbook and run ansible playbook that uses the role
You can change the script to download the role from your custom branch

```
#!/bin/bash
set -e

sudo dnf install python3.12 augeas-libs -y

sudo python3.12 -m venv /opt/ansible-for-listmonk/
sudo /opt/ansible-for-listmonk/bin/pip install --upgrade pip
sudo /opt/ansible-for-listmonk/bin/pip install ansible



# HERE you can change the script to download the role from your custom branch
/opt/ansible-for-listmonk/bin/ansible-galaxy role install idNoRD.listmonk --force
# /opt/ansible-for-listmonk/bin/ansible-galaxy role install git+https://github.com/idNoRD/ansible-listmonk.git,feature/234_qwer_v26 --force

# --force is to always download to get your latest changes. Use --force for development purposes only





echo "Step Create playbook_listmonk"
sudo rm -rf playbook_listmonk.yml
sudo touch playbook_listmonk.yml
sudo tee playbook_listmonk.yml <<EOF
---
- name: Install and Configure listmonk
  hosts: localhost
  vars:
    ansible_python_interpreter: /opt/ansible-for-listmonk/bin/python3.12
    listmonk_config_db_database: "abcd"
    listmonk_config_db_user: "abcd"
    listmonk_config_db_password: "your_abcd_database_password_here"
    debug_mode: true
    listmonk_restart_health_check_retries: 5
    listmonk_override_settings: true
    listmonk_api_settings_payload:
      app.site_name: "Mailing list (managed by Ansible role)"
      app.lang: "en"
      upload.provider: "filesystem"
#      upload.max_file_size: 5000
#      upload.extensions:
#        - "jpg"
#        - "jpeg"
#        - "png"
#        - "gif"
#        - "svg"
#        - "*"
#      upload.filesystem.upload_path: "uploads"
#      upload.filesystem.upload_uri: "/uploads"
      smtp:
        - enabled: true
          host: "smtp.example.com"
          hello_hostname: ""
          port: 25
          auth_protocol: "None"
          username: ""
          email_headers:
            - {}
          max_conns: 10
          max_msg_retries: 2
          idle_timeout: "15s"
          wait_timeout: "5s"
          tls_type: "STARTTLS"
          tls_skip_verify: true
  roles:
    - idNoRD.listmonk
EOF
echo "Step Run created playbook_listmonk.yml"
# Temporarily disable 'set -e' to check the exit status of ansible-playbook
set +e
/opt/ansible-for-listmonk/bin/ansible-playbook -c local -i localhost, playbook_listmonk.yml -v
listmonk_ansible_exit_code=$?  # Capture the exit status of ansible-playbook
# Re-enable 'set -e' so that the script will exit on future errors
set -e
# Check if ansible-playbook failed
if [ $listmonk_ansible_exit_code -ne 0 ]; then
    echo "Ansible playbook_listmonk failed with exit code $listmonk_ansible_exit_code, exiting the script."
    exit 1
else
  echo "🌍 **SYSTEM STATUS:** playbook_listmonk completed successfully"
fi

```
</details>
