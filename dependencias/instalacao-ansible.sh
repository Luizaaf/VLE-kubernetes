#!/bin/bash

sudo apt-get update
sudo apt-get install python3 -y

sudo apt install python3-pip
pip install boto3 botocore ansible
