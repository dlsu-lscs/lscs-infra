# How to run?

1. Make sure ansible is installed in your local machine.
    - Follow install [guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pip)

    > [!NOTE]
    > Python is required to be installed to run `ansible`

2. Run `bootstrap_lscs_vps.yml` playbook

    > [!IMPORTANT]
    > Override `user_name` and `user_password`

    ```bash
    # replace user_name and user_password variables
    ansible-playbook --ask-become-pass bootstrap_lscs_vps.yml -i inventory/hosts.ini -e "user_name=USERNAME user_password=YOUR_SECURE_PASSWORD"
    ```

    - If you used `ansible-vault` to encrypt something, then add `--ask-vault-pass` flag:

    ```bash
    ansible-playbook --ask-become-pass --ask-vault-pass bootstrap_lscs_vps.yml -i ./inventory/hosts.ini -e "user_name=USERNAME user_password=YOUR_SECURE_PASSWORD"
    ```

    > [!NOTE]
    > If there is a "Module not found" error, then `ansible.posix` is not installed
    > Install it with: `ansible-galaxy collection install -r collection/requirements.yml`

---

## Ansible Vault Encryption (via `ansible-vault`)

- create a "master password"

    ```bash
    echo "SECRET_PASSWORD" > master_password
    ```

- encrypting a string with `encrypt_string`

    ```bash
    ansible-vault encrypt_string --vault-password-file <PATH_TO_PASS_FILE> "string to encrypt" --name "VERY_SECRET_VARIABLE_NAME"
    ```

- encrypting files (ssh keys, gpg keys, etc.) with `encrypt_string`

    ```bash
    cat file.key | ansible-vault encrypt_string --vault-password-file <PATH_TO_PASS_FILE> --stdin-name "file.key"
    ```

    - Then you can use `file.key` as a key in `./group_vars/all.yml`
