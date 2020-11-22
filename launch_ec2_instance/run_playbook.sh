#!/bin/sh

ansible-playbook -i "localhost," launch.yaml --connection=local
