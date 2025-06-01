# Ansible Role: Listmonk
[![Ansible Galaxy](https://img.shields.io/badge/Ansible%20Galaxy-idNoRD.listmonk-blue.svg?logo=ansible)](https://galaxy.ansible.com/idNoRD/listmonk)
[![Fedora 41](https://github.com/idNoRD/ansible-listmonk/actions/workflows/fedora-41.yml/badge.svg)](https://github.com/idNoRD/ansible-listmonk/actions/workflows/fedora-41.yml) 
![GitHub Maintained](https://img.shields.io/maintenance/yes/2025)
![GitHub License](https://img.shields.io/github/license/ironwolphern/ansible-role-certbot)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/idNoRD/ansible-listmonk/badge)](https://securityscorecards.dev/viewer/?uri=github.com/idNoRD/ansible-listmonk)

Ansible role to install and configure [Listmonk](https://listmonk.app)  
This role is primarily intended for Amazon Linux 2023 (AL2023), but it should also work on Fedora, RHEL distributions such as CentOS, Rocky Linux, and AlmaLinux, though testing on these platforms has not been done.

---

## 📍 FEATURES
- [x] Add RedHat os_family OS check
- [x] Create dedicated system user/group (`listmonk:listmonk`)
- [x] Download latest Listmonk release archive
- [x] Extract and install Listmonk binary to `/opt/listmonk/bin`
- [x] Create and configure `config.toml` via Ansible template
- [x] Create, start and enable `listmonk.service` systemd service for Listmonk
- [x] Add role variables (see `defaults/main.yml`)
- [x] Listmonk works with a PostgreSQL database already installed on the same machine. `Note: This Ansible role does not install or manage PostgreSQL.`
- [x] Basic health check and service status validation
- [x] Published [role on Ansible Galaxy](https://galaxy.ansible.com/ui/standalone/roles/idNoRD/listmonk)
- [x] Admin credentials are not stored in the Listmonk config file. They are provided as environment variables only during the initial bootstrap (one-time setup).
- [x] Logs captured by systemd and logged via journald.
- [x] Can override Settings using Listmonk API. Creates ADMIN_API_USER for that with a token.
- [x] Developer guide
- [x] Repository Funding is ready for your donate

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

We assume that for production you will have:
- Certbot (or alternative certificate provisioning tool)
- NGINX (or alternative reverse proxy solution)

---

## Example Playbook
```text
ansible-galaxy role install idNoRD.listmonk
```
### Install only:
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
### Install and override Settings:
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
      app.site_name: Mailing list (managed by Ansible role)
      app.root_url: http://localhost:9000
      app.favicon_url: ""
      app.from_email: "listmonk <noreply@listmonk.yoursite.com>"
      app.logo_url: ""
      app.concurrency: 10
      app.message_rate: 10
      app.batch_size: 1000
      app.max_send_errors: 1000
      app.message_sliding_window: false
      app.message_sliding_window_duration: 1h
      app.message_sliding_window_rate: 10000
      app.cache_slow_queries: false
      app.cache_slow_queries_interval: "0 3 * * *"
      app.enable_public_archive: true
      app.enable_public_subscription_page: true
      app.enable_public_archive_rss_content: true
      app.send_optin_confirmation: true
      app.check_updates: true
      app.notify_emails: []
      app.lang: en
      privacy.individual_tracking: false
      privacy.unsubscribe_header: true
      privacy.allow_blocklist: true
      privacy.allow_export: true
      privacy.allow_wipe: true
      privacy.allow_preferences: true
      privacy.exportable:
        - profile
        - subscriptions
        - campaign_views
        - link_clicks
      privacy.domain_blocklist: []
      privacy.domain_allowlist: []
      privacy.record_optin_ip: false
      security.enable_captcha: false
      security.captcha_key: ""
      security.captcha_secret: ""
      security.oidc:
        enabled: false
        client_id: ""
        provider_url: ""
        client_secret: ""
        provider_name: ""
      upload.provider: filesystem
      upload.max_file_size: 5000
      upload.extensions:
        - jpg
        - jpeg
        - png
        - gif
        - svg
        - "*"
      upload.filesystem.upload_path: uploads
      upload.filesystem.upload_uri: /uploads
      upload.s3.url: https://ap-south-1.s3.amazonaws.com
      upload.s3.public_url: ""
      upload.s3.aws_access_key_id: ""
      upload.s3.aws_secret_access_key: ""
      upload.s3.aws_default_region: ap-south-1
      upload.s3.bucket: ""
      upload.s3.bucket_domain: ""
      upload.s3.bucket_path: /
      upload.s3.bucket_type: public
      upload.s3.expiry: 167h
      smtp:
        - host: smtp.yoursite.com
          port: 25
          enabled: true
          password: password
          tls_type: STARTTLS
          username: username
          max_conns: 10
          idle_timeout: 15s
          wait_timeout: 5s
          auth_protocol: cram
          email_headers: []
          hello_hostname: ""
          max_msg_retries: 2
          tls_skip_verify: false
        - host: smtp.gmail.com
          port: 465
          enabled: false
          password: password
          tls_type: TLS
          username: username@gmail.com
          max_conns: 10
          idle_timeout: 15s
          wait_timeout: 5s
          auth_protocol: login
          email_headers: []
          hello_hostname: ""
          max_msg_retries: 2
          tls_skip_verify: false
      messengers: []
      bounce.enabled: false
      bounce.webhooks_enabled: false
      bounce.actions:
        hard:
          count: 1
          action: blocklist
        soft:
          count: 2
          action: none
        complaint:
          count: 1
          action: blocklist
      bounce.ses_enabled: false
      bounce.sendgrid_enabled: false
      bounce.sendgrid_key: ""
      bounce.postmark:
        enabled: false
        password: ""
        username: ""
      bounce.forwardemail:
        key: ""
        enabled: false
      bounce.mailboxes:
        - host: pop.yoursite.com
          port: 995
          type: pop
          enabled: false
          password: password
          username: username
          return_path: bounce@listmonk.yoursite.com
          tls_enabled: true
          auth_protocol: userpass
          scan_interval: 15m
          tls_skip_verify: false
      appearance.admin.custom_css: ""
      appearance.admin.custom_js: ""
      appearance.public.custom_css: ""
      appearance.public.custom_js: ""
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
OPTION 1:
# To start/restart VM from scratch and re-executing all sh scripts that run ansible role
vagrant destroy -f && vagrant up --provision

# To connect to VM
vagrant ssh

OPTION 2:
# Instead of downloading the role from Github repo everytime you can sync folders between your local source and the VM
config.vm.synced_folder "/Users/<username>/work/myansible/ansible-listmonk", "/root/.ansible/roles/idNoRD.listmonk", create: true, type: "rsync"
# Once you change the code on your local machine we can auto-update the role in the VM immediately
vagrant rsync-auto
# So after that we just can rerun ansible without reinstalling postgres and without redownloading ansible role
# since my postgresql.sh is not idempotent yet I temporary comment it and uncomment later if I need OPTION 1 (see above)
    #config.vm.provision "shell", name: "install-postgres", path: "userdata_scripts/postgres-only.sh"
    config.vm.provision "shell", name: "install-listmonk", path: "userdata_scripts/listmonk-only.sh"
# and then you can run. This is useful for quick re-run of ansible.
vagrant up --provision

```

### content of Vagrantfile
```text
Vagrant.configure("2") do |config|

config.vm.box = "gbailey/al2023"

# Make sure that this IP is available in your network to avoid conflict
config.vm.network "private_network", ip: "192.168.56.101"

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
#### The purpose of the bash script is to install ansible, get the role with your custom changes, create a playbook and run ansible playbook that uses the role
#### there are two options to get the role with your custom changes: download the role from your custom github repo OPTION 1 or use the source code of the role on your Host maniche that is synced to VM OPTION 2
You can change the script to download the role from your custom branch

```
#!/bin/bash
set -e

sudo dnf install python3.12 augeas-libs -y

sudo python3.12 -m venv /opt/ansible-for-listmonk/
sudo /opt/ansible-for-listmonk/bin/pip install --upgrade pip
sudo /opt/ansible-for-listmonk/bin/pip install ansible

# Please READ OPTION 1 and OPTION 2 carefully
# HERE you can comment all "role install" commands if you are using OPTION 2 (Instead of downloading the role from Github repo everytime you can sync folders between your local source and the VM)
# HERE you can change the script to download the role from your custom branch if you are using OPTION 1
# If you don't change anything here this script will download published role from Ansible Galaxy which won't contain your custom changes
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
        app.site_name: Mailing list (managed by Ansible role)
        app.root_url: http://localhost:9000
        app.favicon_url: ""
        app.from_email: "listmonk <noreply@listmonk.yoursite.com>"
        app.logo_url: ""
        app.concurrency: 10
        app.message_rate: 10
        app.batch_size: 1000
        app.max_send_errors: 1000
        app.message_sliding_window: false
        app.message_sliding_window_duration: 1h
        app.message_sliding_window_rate: 10000
        app.cache_slow_queries: false
        app.cache_slow_queries_interval: "0 3 * * *"
        app.enable_public_archive: true
        app.enable_public_subscription_page: true
        app.enable_public_archive_rss_content: true
        app.send_optin_confirmation: true
        app.check_updates: true
        app.notify_emails: []
        app.lang: en
        privacy.individual_tracking: false
        privacy.unsubscribe_header: true
        privacy.allow_blocklist: true
        privacy.allow_export: true
        privacy.allow_wipe: true
        privacy.allow_preferences: true
        privacy.exportable:
          - profile
          - subscriptions
          - campaign_views
          - link_clicks
        privacy.domain_blocklist: []
        privacy.domain_allowlist: []
        privacy.record_optin_ip: false
        security.enable_captcha: false
        security.captcha_key: ""
        security.captcha_secret: ""
        security.oidc:
          enabled: false
          client_id: ""
          provider_url: ""
          client_secret: ""
          provider_name: ""
        upload.provider: filesystem
        upload.max_file_size: 5000
        upload.extensions:
          - jpg
          - jpeg
          - png
          - gif
          - svg
          - "*"
        upload.filesystem.upload_path: uploads
        upload.filesystem.upload_uri: /uploads
        upload.s3.url: https://ap-south-1.s3.amazonaws.com
        upload.s3.public_url: ""
        upload.s3.aws_access_key_id: ""
        upload.s3.aws_secret_access_key: ""
        upload.s3.aws_default_region: ap-south-1
        upload.s3.bucket: ""
        upload.s3.bucket_domain: ""
        upload.s3.bucket_path: /
        upload.s3.bucket_type: public
        upload.s3.expiry: 167h
        smtp:
          - host: smtp.yoursite.com
            port: 25
            enabled: true
            password: password
            tls_type: STARTTLS
            username: username
            max_conns: 10
            idle_timeout: 15s
            wait_timeout: 5s
            auth_protocol: cram
            email_headers: []
            hello_hostname: ""
            max_msg_retries: 2
            tls_skip_verify: false
          - host: smtp.gmail.com
            port: 465
            enabled: false
            password: password
            tls_type: TLS
            username: username@gmail.com
            max_conns: 10
            idle_timeout: 15s
            wait_timeout: 5s
            auth_protocol: login
            email_headers: []
            hello_hostname: ""
            max_msg_retries: 2
            tls_skip_verify: false
        messengers: []
        bounce.enabled: false
        bounce.webhooks_enabled: false
        bounce.actions:
          hard:
            count: 1
            action: blocklist
          soft:
            count: 2
            action: none
          complaint:
            count: 1
            action: blocklist
        bounce.ses_enabled: false
        bounce.sendgrid_enabled: false
        bounce.sendgrid_key: ""
        bounce.postmark:
          enabled: false
          password: ""
          username: ""
        bounce.forwardemail:
          key: ""
          enabled: false
        bounce.mailboxes:
          - host: pop.yoursite.com
            port: 995
            type: pop
            enabled: false
            password: password
            username: username
            return_path: bounce@listmonk.yoursite.com
            tls_enabled: true
            auth_protocol: userpass
            scan_interval: 15m
            tls_skip_verify: false
        appearance.admin.custom_css: ""
        appearance.admin.custom_js: ""
        appearance.public.custom_css: ""
        appearance.public.custom_js: ""
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
