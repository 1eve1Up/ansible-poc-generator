# Ansible POC Generator

## Build & Lint Status

[![Lint & Syntax](https://github.com/1eve1Up/ansible-poc-generator/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/1eve1Up/ansible-poc-generator/actions/workflows/lint.yml)

## Intro

The Ansible POC Generator repo is authored and maintained by Red Hat® Premier Partner [Level Up Technology LLC](https://levelupla.io).

## Goals of This Repo

1. Provide an instant repo and set of job templates for popular Ansible POC use cases. 
1. Provide guardrailed defaults.
1. Allow users to easily configure individual job templates and create new playbooks using the example tasks provided.

## Selecting Your Ansible POC Package

1. linux_config_mgmt
1. network_automation
1. rhel_patching
1. windows_automation
1. windows_patching

## Quickstart: Running the Bootstrap

No warranty & no support - use at your own risk.

1. Fork this repo first! https://github.com/1eve1Up/ansible-poc-generator

1. This quickstart assumes that:
    1. You have already successfully installed Red Hat Ansible Automation Platform (AAP) 2.5. 
    1. You are running these CLI steps on the AAP controller itself.

1. Create `YOUR_AAP_TOKEN` for admin user with "Write" scope [Red Hat AAP 2.5 doc: "Adding tokens"](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.5/html/access_management_and_authentication/gw-token-based-authentication#proc-controller-apps-create-tokens)

    ---
    > **_NOTE:_** How to test your API access:
        ```
        export HOSTNAME=$(hostname)
        export AAP_TOKEN=<YOUR_AAP_TOKEN>
        curl -k -H "Authorization: Bearer $AAP_TOKEN" \
            https://$HOSTNAME/api/controller/v2/ping/
        ```
    ---

1. $ `ssh -A USERNAME@HOSTNAME`

1. Copy your existing `~/.ansible.cfg` or otherwise create a hub `token` [Red Hat AAP 2.5 doc: "Token management in automation hub"](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.5/html-single/managing_automation_content/index#token-management-hub_cloud-sync)

1. $ `git clone git@github.com:1eve1Up/ansible-poc-generator.git (REPLACE WITH YOUR FORK)`

1. $ `ansible-galaxy collection install ansible.controller`

1. $ `ansible-galaxy collection install ansible.platform`

1. $ `cd ansible-poc-generator`

1. $ `vi playbooks/bootstrap/vars.yml`

    ```
    ---
    aap_hostname: "https://<HOSTNAME>"
    aap_token: "<AAP_TOKEN>"
    controller_oauthtoken: "<AAP_TOKEN>"
    poc_aap_controller_username: "ec2-user" # example
    poc_aap_controller_password: ""
    poc_package: "rhel_patching" # example
    scm_pat: "<GITHUB_PAT>"
    scm_url: "https://github.com/1eve1Up/ansible-poc-generator.git" # example - use your own fork
    scm_username: "<GITHUB_USER>"

    ```

1. $ `vi /home/daniel/.tower_cli.cfg`
    ```
    [general]
    host = https://<HOSTNAME>
    verify_ssl = false
    oauth_token = <YOUR_AAP_TOKEN>

    ```

1. $ `ansible-playbook playbooks/bootstrap/main.yml`

NOTES:

- Due to AAP 2.5 redesign, the `ansible.*` collections involved in this are transitioning, and there is near-duplication of variables in certain cases. 

- This assumes you will use a `vars.yml` file or `export` environment variables

- You **MUST** fork the ansible-poc-generator repo, or you will not be able to modify the Ansible playbook code.

- Only run this bootstrap post AAP 2.5 install. Do not attempt to use this on prior AAP versions.

## Using the Ansible POC Package

1. Go to https://$HOSTNAME
1. Review the following:
    - Templates
    - Inventories
    - Credentials
    - Projects
    - Organizations
1. Finish configuring your first Machine credential as needed.
1. Test an ad-hoc module such as "ping" on the AAP POC Controller host (you will need to enable it in the "POC AAP" inventory first by toggling).

### Working With Example Playbooks

- Most of the playbooks are single-tasks, but there are a few that have multiple tasks. The `tasks/main.yml` file is where you can add additional tasks or modify existing ones.
- It is recommended that you follow the example patterns of tasks and usage of variabless, etc. to create new playbooks, whether in your forked repo or a separate repo.
- Again, you **MUST** fork the ansible-poc-generator repo, or you will not be able to modify the Ansible playbook code.

### Modifying Example Playbook Task Variables

- You can either modify the example variables found in `roles/poc_packages/PACKAGE_NAME/vars/main.yml`...
- ...OR you can inject values into job templates via [extra variables](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.5/html/using_automation_execution/controller-job-templates#controller-extra-variables) or [surveys](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.5/html/using_automation_execution/controller-job-templates#controller-surveys-in-job-templates).

### Determining Installed `pip` Packages and Ansible Collections in the Latest Default Execution Environment Image

```
[user@host ]$ podman pull registry.redhat.io/ansible-automation-platform-25/ee-supported-rhel8:latest
Trying to pull registry.redhat.io/ansible-automation-platform-25/ee-supported-rhel8:latest...
Getting image source signatures
Checking if image destination supports signatures
Copying blob 0d8da9fbfab5 done   |
Copying blob d62aa0635f4c done   |
Copying blob f9aaac9b2d03 done   |
Copying blob 019d6be86f6b done   |
Copying config 7608b66b6f done   |
Writing manifest to image destination
Storing signatures
7608b66b6fbfc7fb01b1d1ebc9b27e3dc748198ca3dfdb053b10c2ff7e1137d0
[user@host ]$ podman run -it 7608b66b6fbfc7fb01b1d1ebc9b27e3dc748198ca3dfdb053b10c2ff7e1137d0 /bin/bash
bash-4.4# pip3 list
<output omitted>
bash-4.4# ansible-galaxy collection list | head

# /usr/share/ansible/collections/ansible_collections
Collection                      Version
------------------------------- ------------
amazon.aws                      9.2.0
ansible.controller              4.6.18
ansible.eda                     2.8.2
ansible.hub                     1.0.0
ansible.netcommon               7.1.0
ansible.network                 4.0.0
bash-4.4#

```

## License and Copyright

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

This repository is maintained by **Level Up Technology LLC**.  

See the [LICENSE](LICENSE) and [NOTICE](NOTICE) files for details.
