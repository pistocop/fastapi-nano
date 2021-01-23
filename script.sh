#!/usr/bin/env bash

# Automatically update dependencies and run the tests.
# Assumes venv is activated.

# Set command echo.
set -euxo pipefail

# Install cookiecutter.
pip install cookiecutter

# Create concrete project from cookiecutter.
cookiecutter $(pwd) --no-input

# Install dependencies.
cd fastapi-nano &&\
pip install -r requirements-dev.txt &&\
pip install -r requirements.txt &&\
cd ..

# Upgrade dependencies.
cd fastapi-nano && \
pip-compile --upgrade requirements-dev.txt && \
pip-compile --upgrade requirements.txt && \
cd ..

# Sync venv according to the upgraded dependencies.
cd fastapi-nano && \
pip-sync requirements-dev.txt requirements.txt &&
cd ..

# Run the tests.
pytest fastapi-nano

# Copy dependencies.
cp fastapi-nano/requirements.txt  \{\{cookiecutter.repo\}\}/ && \
cp fastapi-nano/requirements-dev.txt \{\{cookiecutter.repo\}\}/

# Build docker-container.
cd fastapi-nano && docker-compose up --build -d && cd ..

# Cleanup.
# cd fastapi-nano && docker-compose down && cd ..
# rm -rf fastapi-nano

# git config
# git config user.email "redowan.nafi@gmail.com"
# git config user.name "rednafi"
# git add .
# git commit -m "Dependency upgrade"
# git push origin master

# turn off command echo
set +x
