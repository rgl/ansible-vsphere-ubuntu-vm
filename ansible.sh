#!/bin/bash
set -euo pipefail

command="$(basename "$0" .sh)"

# build the ansible image.
install -d tmp
DOCKER_BUILDKIT=1 docker build -f Dockerfile.ansible --iidfile tmp/ansible-iid.txt .
ansible_iid="$(cat tmp/ansible-iid.txt)"

# show information about the execution environment.
docker run --rm -i "$ansible_iid" bash <<'EOF'
exec 2>&1
set -euxo pipefail
cat /etc/os-release
ansible --version
python3 -m pip list
ansible-galaxy collection list
EOF

# execute command (e.g. ansible-playbook).
# NB the GITHUB_ prefixed environment variables are used to trigger ansible-lint
#    to annotate the GitHub Actions Workflow with the linting violations.
#    see https://github.com/ansible/ansible-lint/blob/v24.2.1/src/ansiblelint/app.py#L94-L95
#    see https://ansible-lint.readthedocs.io/en/latest/usage/#ci-cd
exec docker run \
    --rm \
    --net=host \
    -v "$PWD:/project:ro" \
    -e GITHUB_ACTIONS \
    -e GITHUB_WORKFLOW \
    -e VM_ANSIBLE_PROJECT_PATH="$PWD" \
    -e VM_VSPHERE_HOSTNAME \
    -e VM_VSPHERE_USERNAME \
    -e VM_VSPHERE_PASSWORD \
    -e VM_VSPHERE_DATACENTER \
    -e VM_VSPHERE_CLUSTER \
    -e VM_VSPHERE_RESOURCE_POOL \
    -e VM_VSPHERE_DATASTORE \
    -e VM_VSPHERE_TEMPLATE \
    -e VM_VSPHERE_FOLDER \
    -e VM_GATEWAY \
    -e VM_FIRST_IP \
    -e VM_ADMIN_PASSWORD \
    "$ansible_iid" \
    "$command" \
    "$@"
