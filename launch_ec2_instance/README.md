# This is example of how to use Ansible to launch AWS EC2 instance.

This example is based on this article: 
https://www.codewithjason.com/launch-ec2-instance-using-ansible/

## Assumptions

It assumed you have an AWS account and have access to a Linux system.
I will be using a docker container.

## Step 1) Create Docker container (optional)


The Dockerfile I used is based on this https://github.com/dockerfile/ubuntu/blob/master/Dockerfile


Check out this repo and execute `cd /launch-ec2-instance-using-ansible`
and then execute:

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

## Step 3) Make sure you have key pair uploaded in AWS.

Create a ssh key pair by executing: `ssh-keygen`.
Upload the resulting `~/.ssh/id_rsa.pub` to AWS and name the key `aws_key`.
You could use a different name but you'd then have to edit the `launch.yaml` playbook.


## Step 4) Create a `vars.yaml` file


You need to place the aws_access_key and aws_secret_key into a file called `./vars.yaml`.


### vars.yaml file

create a `./vars.yaml` file


```
---
aws_access_key: XXXXXXXXXXXXXXXX
aws_secret_key: XXXXXXXXXXXXXXXX
```

Replace XXXXXX with the contents of the cvs file you downloaded.
(!) Be sure to add `./vars.yaml` file added to your `.gitignore` file. (!)


### Note about aws_key

`aws_key` is the name you have given to the public key you have uploaded to AWS key pairs.
So to create this key pair with `ssh-keygen`.  then upload it to AWS.  Be sure that you upload the
key to same region (us-west-2) as the instance.


### Run it


start docker container

```
$ docker run -itd --name ubuntu-ansible -e container=docker -v ${PWD}:/root ubuntu-ansible
```

Logon to the running container by executing:

```
plankton@DESKTOP-C8MFTFD MINGW64 ~/GITHUB/ansible-examples/launch_ec2_instance (launch_ec2_instance)
$ docker exec -it ubuntu-ansible bash
root@7ec25d9bbec8:~#
```

Change directory to `/root`

```
root@7ec25d9bbec8:~# cd /root/
```


Run the playbook:

```

root@7ec25d9bbec8:/root# ansible-playbook -i "localhost," launch.yaml --connection=local

```

Be sure to terminate the instance you created via the AWS console.

