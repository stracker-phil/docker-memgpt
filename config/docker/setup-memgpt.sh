#!/bin/bash

# Install pip if it is not already installed
python -m ensurepip
pip install --upgrade pip

# Install the MemGPT project.
pip install -U pymemgpt

# Requirements that are missing in the default python-slim image.
pip install -r /usr/local/etc/memgpt-requirements.txt
