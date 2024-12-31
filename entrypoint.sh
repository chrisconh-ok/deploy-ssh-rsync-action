#!/bin/sh

# SSH agent load key.
source agent-start "$GITHUB_ACTION"
echo "$INPUT_REMOTE_SSH_KEY" | SSH_PASS="$INPUT_REMOTE_SSH_KEY_PASS" agent-add

# Set strict errors.
set -eu

# Vars from inputs.
RSYNC_OPTIONS="$INPUT_RSYNC_OPTIONS"
EXTRA_SHELL_COMMANDS="ssh -o StrictHostKeyChecking=no -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -p $INPUT_REMOTE_PORT $INPUT_EXTRA_SHELL_COMMANDS"
LOCAL_PATH="$GITHUB_WORKSPACE/$INPUT_LOCAL_PATH"
RU_RH="$INPUT_REMOTE_USER@$INPUT_REMOTE_HOST"

# Deploy.
sh -c "rsync $RSYNC_OPTIONS -e '$EXTRA_SHELL_COMMANDS' $LOCAL_PATH $RU_RH:$INPUT_REMOTE_PATH"
