#!/usr/bin/env bash
set -e
echo "Starting Rasa Action Server on port ${PORT:-8000}"
exec rasa run actions --port ${PORT:-8000} --debug
