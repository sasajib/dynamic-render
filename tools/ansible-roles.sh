#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Determine the directory with files
SCRIPT_DIR="$(realpath "$(dirname "${0}")/../")"
pushd "${SCRIPT_DIR}" >>'/dev/null'

# Ansible roles
ansible-galaxy 'role' 'install' \
	--verbose \
	--roles-path 'roles/' \
	--role-file 'requirements.yml'

ansible-galaxy 'collection' 'install' \
	--verbose \
	--collections-path './' \
	--requirements-file 'requirements.yml'

popd >>'/dev/null'
