# Deploy SSH rsync Action.

This GitHub Action project is designed to send and synchronize files from your GitHub repository to a remote server using SSH and rsync. These files can either be processed within GitHub Actions beforehand or sent directly from your repository.

In simple terms, this code connects to your server via SSH, executes rsync with the extra options you specify, and your files are successfully transferred to your remote server.


## Remote info (required)

- `REMOTE_HOST` - The IP address or hostname of your remote server. For example, 1.1.1.1 or host.example.com.

- `REMOTE_PORT` - The port of your remote server. By default, port 22 is used, but this may vary depending on your provider.

- `REMOTE_PATH` - The directory path to synchronize. Make sure to verify the location from which the SSH connection is established.

- `REMOTE_USER` - The username for connecting to your remote server via SSH.

- `REMOTE_SSH_KEY` - The private SSH key. Remember, it must be properly linked to your remote server.


## Remote info (optional)

- `REMOTE_PASSWORD` - The password for connecting to your remote server via SSH.

- `REMOTE_SSH_KEY_PASS` - If your SSH key has an associated passphrase, remember to add it.


## Local info (requiered)

- `LOCAL_PATH` - Local directory from which the files will be synchronized to the remote folder.


## Rsync options (requiered)

- `RSYNC_OPTIONS`* - Here you should enter the rsync options that are necessary for your specific use case.  

Example: `-rvaz --delete`  

```bash
#Some examples of rsync options:

--archive, -a         archive mode is -rlptgoD (no -A,-X,-U,-N,-H)
--verbose, -v         increase verbosity
--compress, -z        compress file data during the transfer
--recursive, -r       recurse into directories
--exclude=PATTERN     exclude files matching PATTERN
--exclude-from=FILE   read exclude patterns from FILE
--include=PATTERN     dont exclude files matching PATTERN
--include-from=FILE   read include patterns from FILE
--filter=RULE, -f     add a file-filtering RULE
--delete              delete extraneous files from dest dirs
--delete-before       receiver deletes before xfer, not during
--delete-during       receiver deletes during the transfer
--delete-delay        find deletions during, delete after
--delete-after        receiver deletes after transfer, not during
--delete-excluded     also delete excluded files from dest dirs
```

## Extra Shell Commands (optional)

- `EXTRA_SHELL_COMMANDS` - Here you can add extra arguments that you need to execute.  

## Required secret(s)

## Important: Use Secret Variables  

Navigate to: `repo settings > Secrets and variables > Actions`.  

We recommend using these secrets for all sensitive information:  

- Host  
- User  
- Password  
- Port  
- Remote Path  
- SSH Key  
- SSH Key Passphrase  

It's always good to be cautious, especially when dealing with sensitive data.  

## Example usage

In all examples, we will use secrets in the "REMOTE_*" format.

### Basic:

```
name: Basic Deploy
on:
  push:
    branches:
    - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Deploy SSH rsync Action.
      uses: chrisconh/deploy-ssh-rsync-action@1.0
      with:
        REMOTE_HOST: ${ secrets.REMOTE_HOST }
        REMOTE_PORT: ${ secrets.REMOTE_PORT }
        REMOTE_USER: ${ secrets.REMOTE_USER }
        REMOTE_PASSWORD: ${ secrets.REMOTE_PASSWORD }
        REMOTE_KEY: ${ secrets.REMOTE_SSH_KEY }
        REMOTE_PATH: ${ secrets.REMOTE_PATH }
        LOCAL_PATH: /
        RSYNC_OPTIONS: -rvaz --delete
```

### Intermediate: (with exclude, include and filter options)

```
name: Intermediate Deploy
on:
  push:
    branches:
    - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Deploy SSH rsync Action.
      uses: chrisconh/deploy-ssh-rsync-action@1.0
      with:
        REMOTE_HOST: ${ secrets.REMOTE_HOST }
        REMOTE_PORT: ${ secrets.REMOTE_PORT }
        REMOTE_USER: ${ secrets.REMOTE_USER }
        REMOTE_PASSWORD: ${ secrets.REMOTE_PASSWORD }
        REMOTE_KEY: ${ secrets.REMOTE_SSH_KEY }
        REMOTE_PATH: ${ secrets.REMOTE_PATH }
        LOCAL_PATH: /
        RSYNC_OPTIONS: -rvaz --exclude='file-a.txt' --include='file-b.txt'  --filter='- .gitignore' --delete
```

### Advanced: (more secure with passphrase)

```
name: Advanced Deploy
on:
  push:
    branches:
    - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Deploy SSH rsync Action
      uses: chrisconh/deploy-ssh-rsync-action@1.0
      with:
        REMOTE_HOST: ${ secrets.REMOTE_HOST }
        REMOTE_PORT: ${ secrets.REMOTE_PORT }
        REMOTE_USER: ${ secrets.REMOTE_USER }
        REMOTE_SSH_KEY: ${ secrets.REMOTE_SSH_KEY }
        REMOTE_SSH_KEY_PASS: ${ secrets.REMOTE_SSH_KEY_PASS }
        REMOTE_PATH: ${ secrets.REMOTE_PATH }
        LOCAL_PATH: /
        RSYNC_OPTIONS: -rvaz --exclude='file-a.txt' --include='file-b.txt'  --filter='- .gitignore' --delete
```

## Additional notes

This code is based on many repositories, so it would take me forever to list them all here. I basically "brought" some code from various sources to create a GitHub Action that meets my needs for easy deployments to a remote server. I personally use this code, so if it’s useful to someone else, that’s awesome! 👍
