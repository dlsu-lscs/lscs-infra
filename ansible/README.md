# How to run?

1. Install Ansible on your local machine.

> [!NOTE]
> Python and pipx (better than pip) is required to run `ansible`

- Make sure to install python and pipx via your package manager first

- Use `pipx` (Recommended)
    - Keeps Ansible isolated.
        - use `--include-deps` to expose other binaries like `ansible-playbook,` etc.

    ```bash
    pipx install --include-deps --force ansible
    # Install passlib for password hashing support
    pipx inject ansible passlib
    ```

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

## Troubleshooting

- **"Unable to encrypt nor hash, passlib must be installed. No module named 'passlib'."**
    - using the `password_hash()` function needs `passlib` in the ansible server (not on the target host)
    - Install in the machine where ansible is installed with: `pipx inject ansible passlib`
