#!/usr/bin/env bash

apt-get install -y software-properties-common
apt-add-repository ppa:ansible/ansible -y
apt-get update -y
apt-get install ansible -y
