docker-ansible
==============

Ansible with awscli installed under alpine for small footprint

## Usage

The container is primarily used to launch ansible to run the ansible commands.  To run it using instance profile credentials (or not providing any credentials), use:

```docker run -it --rm onesysadmin/ansible <command> <options>```

You can attach your AWS credentials using environment variables, but this is not the most secure method since your credentials are shown in the process list:

```docker run -it --rm -e AWS_ACCESS_KEY_ID=xxxxxx -e AWS_SECRET_ACCESS_KEY=xxxxx -e AWS_DEFAULT_REGION=us-east-1 onesysadmin/ansible <command> <options>```

You can also have a file containing the environment variables and then set the environment variables to use using the docker `--env-file` option.

You can also attach your AWS Credentials file by mounting it in:

```docker run -i -t --rm -v mycredentialsfile:/root/.aws/credentials:ro onesysadmin/ansible <command> <options>```

Your credential file would look something like this:

```
[default]
aws_access_key_id = your_access_key_id
aws_secret_access_key = your_secret_access_key
```

## Creating multiple credential profiles

To create separate profiles within the credentials file, you simply specify the name, ie.

You can also match the profile against a separate set of crendentials in the credentials file:

```
[default]
aws_access_key_id = your_access_key_id
aws_secret_access_key = your_secret_access_key
region=us-east-1

[dev]
aws_access_key_id=AKIAI44QH8DHBEXAMPLE
aws_secret_access_key=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
region=us-west-1
```

For more command options, please see [AWS CLI Getting Started documentation](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).

### Executing playbooks for AWS environments

Production systems will usually contain encrypted variables files that contain credentials and sensitive information.  The person running the production environment will need to have have access to the vault password.

Executing the playbooks will be as follows:

```docker run -it --rm -e AWS_PROFILE=dev -w /playbooks -v <playbook dir>:/playbooks -v credentials:/root/.aws/credentials onesysadmin/ansible ansible-playbook --ask-vault-pass -i /playbooks/environments/stage/ec2.py <playbook name>```

You can also store the vault password inside an external file and then reference it using the ansible-playbook `--vault-password-file=<file location>` option.  If you do this, it's important to set the file permission to something more secure like 0600 so that only you can view the file.

One can also set the `ANSIBLE_VAULT_PASSWORD_FILE` environment variable to the location of the vault password file.

AWS_PROFILE is required to set the proper profile to use when running ec2.py to retrieve dynamic inventory as well as to run the AWS CLI commands inside the playbooks.  This should match the environment directory.
