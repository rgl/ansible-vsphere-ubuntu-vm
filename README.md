# About

This is an example Ansible project that creates a Ubuntu VMware vSphere Virtual Machine.

For a more complete Ansible Playbook see the [rgl/my-ubuntu-ansible-playbooks repository](https://github.com/rgl/my-ubuntu-ansible-playbooks).

# Usage

Execute the following procedure in a Ubuntu machine.

Install the [test/templates/ubuntu-22.04-amd64-vsphere virtual machine template](https://github.com/rgl/ubuntu-vagrant) in your VMware vSphere environment.

Install Docker.

Open the [inventory file](inventory.yml) and modify the virtual machines details to fit your environment.

Set your VMware vSphere details:

```bash
cat >secrets.sh <<'EOF'
export VM_VSPHERE_HOSTNAME='vsphere.local'
export VM_VSPHERE_USERNAME='administrator@vsphere.local'
export VM_VSPHERE_PASSWORD='password'
export VM_VSPHERE_DATACENTER='Datacenter'
export VM_VSPHERE_CLUSTER='Cluster'
export VM_VSPHERE_DATASTORE='Datastore'
export VM_VSPHERE_TEMPLATE='test/templates/ubuntu-22.04-amd64-vsphere'
export VM_VSPHERE_FOLDER='test'
export VM_ADMIN_PASSWORD='admin'
export VM_GATEWAY='10.0.0.1'
export VM_FIRST_IP='10.0.0.11'
EOF
source secrets.sh
```

Lint the `example.yml` playbook:

```bash
./ansible-lint.sh --offline --parseable example.yml
```

Create and configure the `example1` machine using the `example.yml` playbook: 

```bash
./ansible-playbook.sh --limit=example1 example.yml | tee ansible.log
```

Destroy the `example1` machine using the `example-destroy.yml` playbook: 

```bash
./ansible-playbook.sh --limit=example1 example-destroy.yml | tee ansible.log
```
