# This is example of how to use Ansible to launch AWS EC2 instance.

This example is based on this article: 
https://www.codewithjason.com/launch-ec2-instance-using-ansible/

## Assumptions

It assumed you have an AWS account and have access to a Linux system.
I will be using a docker container.

## Step 1) Create Docker container (optional)

Start with this Dockerfile https://github.com/dockerfile/ubuntu/blob/master/Dockerfile

```
#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:14.04

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

# Add files.
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
```

Add these lines to the RUN statement above.


```
  apt-get install python -y && \
  apt-add-repository ppa:ansible/ansible && \
  apt-get install ansible -y &&\

```
and remove these lines:

```
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts
```
Then execute:

```
$ docker build -t=ubuntu-ansible .
```

Test like so ...


```
docker run -it --rm ubuntu-ansible
```

## Step 2) Create AWS user via IAM and get AWS SECRETS


Login to your AWS account via AWS console:

https://aws.amazon.com/console/


Go to IAM service and click on Users.  Then click on 'Add user'.

Set username to "ansible" and check Programmatic access for the AWS access type.
Then click Next: Permissions

Check Adminstrators group (this assumes you have create a group called Administrators with AdministratorAccess).

Then click Next:Tags
Click Next:Review
Click Create user

Download the .csv


## Step 3) Write the playbook 



See https://www.codewithjason.com/launch-ec2-instance-using-ansible/

### vars.yaml file

create a `./vars.yaml` file


```
---
aws_access_key: XXXXXXXXXXXXXXXX
aws_secret_key: XXXXXXXXXXXXXXXX
```

replace XXXXXX with the contents of the cvs file you downloaded.
Be sure to add `./vars.yaml` file added to your ./gitignore file.

### launch.yaml file

create a file called `./launch.yaml` with these contents:


```
---
- hosts: localhost
  gather_facts: false
  vars_files:
    - vars.yml

  tasks:
    - name: Provision instance
      ec2:
        aws_access_key: "{{ aws_access_key }}"
        aws_secret_key: "{{ aws_secret_key }}"
        key_name: aws_key
        instance_type: t2.micro
        image: ami-0d1cd67c26f5fca19
        wait: yes
        count: 1
        region: us-west-2
```

where `aws_key` is the name you have given to the public key you have uploaded to AWS key pairs.
So to create this key pair with `ssh-keygen`.  then upload it to AWS.  Be sure that you upload the
key to same region (us-west-2) as the instance.


### Run it


start docker container

```
$ docker run -itd -e container=docker -v ${PWD}:/myfile ubuntu-ansible

i
plankton@DESKTOP-C8MFTFD MINGW64 ~/GITHUB/ansible-examples/launch_ec2_instance (launch_ec2_instance)
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
7ec25d9bbec8        ubuntu-ansible      "bash"              44 seconds ago      Up 41 seconds                           boring_mcclintock

plankton@DESKTOP-C8MFTFD MINGW64 ~/GITHUB/ansible-examples/launch_ec2_instance (launch_ec2_instance)
$ docker exec -it boring_mcclintock bash
root@7ec25d9bbec8:~#
root@7ec25d9bbec8:~# cd /myfile/
root@7ec25d9bbec8:/myfile# ls -l
total 14
-rwxrwxrwx 1 1000 staff  786 Nov 21 23:40 Dockerfile
-rwxrwxrwx 1 1000 staff 3678 Nov 22 00:16 README.md
-rwxrwxrwx 1 1000 staff  809 Nov 21 22:48 build_docker.sh
-rwxrwxrwx 1 1000 staff  384 Nov 22 00:10 launch.yaml
-rwxrwxrwx 1 1000 staff  192 Nov 21 23:58 new_user_credentials.csv
-rwxrwxrwx 1 1000 staff   98 Nov 22 00:07 vars.yaml


You need to execute these commands:

add-apt-repository universe
apt-get -y update
apt install -y python-pip
pip install boto3
pip install boto

Maybe they should be added to the Dockerfile.



root@7ec25d9bbec8:/myfile# ansible-playbook -i "localhost," launch.yaml --connection=local

PLAY [localhost] **************************************************************

TASK: [Provision instance] ****************************************************
failed: [localhost] => {"failed": true}
msg: boto required for this module

FATAL: all hosts have already failed -- aborting

PLAY RECAP ********************************************************************
           to retry, use: --limit @/root/launch.yaml.retry

	   localhost                  : ok=0    changed=0    unreachable=0    failed=1




add-apt-repository universe
apt-get -y update
apt install -y python-pip
pip install boto3
pip install boto




```

