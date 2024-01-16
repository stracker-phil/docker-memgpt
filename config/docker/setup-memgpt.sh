#!/bin/bash

# Install pip if it is not already installed
python -m ensurepip
pip install --upgrade pip

pip install -U pymemgpt

pip install pgvector
pip install psycopg
pip install "psycopg[binary,pool]"
pip install psycopg2-binary
