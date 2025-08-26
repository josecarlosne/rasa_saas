#!/usr/bin/env bash
set -e

# Fail fast if there is no model and AUTO_TRAIN is not enabled
if [ -z "$(ls -A models 2>/dev/null)" ]; then
  if [ "${AUTO_TRAIN}" = "true" ]; then
    echo "No model found in ./models. Training a quick one..."
    rasa train --quiet
  else
    echo "ERROR: No model found in ./models. Train locally (rasa train) and commit the tar.gz,"
    echo "or set env var AUTO_TRAIN=true to train at startup (heavier on memory/CPU)."
    exit 1
  fi
fi

# Allow CORS from an env var (default permissive for dev)
CORS="${CORS_ORIGINS:-*}"

echo "Starting Rasa server on port ${PORT:-8000} (CORS: ${CORS})"
exec rasa run       --enable-api       --cors "${CORS}"       --debug       --port ${PORT:-8000}
