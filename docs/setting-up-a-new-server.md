---
date: 2026-01-10T19:50
title: Setting up a new server
tags:
    - Documentation
---

<!-- 2026-01-10-1950 (January 10, 2026 07:50:33 PM) -->

# Setting up a new server

This guide is everything you need to know on how to setup a brand new server/VM from scratch.

This works for any machine/server/VM (like AWS EC2, DigitalOcean Droplet, Hetzner VM, selfhosted server, etc.) with Ubuntu Linux or any Debian distribution installed.

> [!NOTE]
> Sometimes initial configuration (like SSH keys, timezone configs,) are done on the cloud dashboard. So you can skip some steps accordingly.

## Prerequisites

- Install Ansible in your machine
- Have a bash environment (bash shell/CLI)
- Have an SSH key configured - will be used for Ansible automation

## Things to do

- [ ] Get root password and IP of the server
- [ ] Prepare your SSH keys (this is important so we can use ansible properly later)
    - If not yet created, create it with: `ssh-keygen -t ed25519`
    - Then copy the `~/.ssh/id_ed25519.pub`
- [ ] Login to the server with root access
- [ ] Paste your public SSH key (`~/.ssh/id_ed25519.pub`) that you copied to the server's `~/.ssh/authorized_keys`
    - If `~/.ssh/authorized_keys` is not created, then create it with: `mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys`

- [ ] Run the preparation script (`../ansible/local_setup.sh`)
- [ ] Go to `../ansible/inventory/hosts.ini` and configure IP addresses and necessary variables
- [ ] Go to `../ansible/group_vars/all.yml` and configure the necessary variables
- [ ] Run the bootstrap playbook (`../ansible/bootstrap_lscs_vps.yml`)
