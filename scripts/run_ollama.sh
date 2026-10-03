#!/usr/bin/env bash
# Crea el custom model qwen2vl-expo desde el Modelfile y lo ejecuta.
# Uso: bash scripts/run_ollama.sh   (luego: ollama run qwen2vl-expo)
set -euo pipefail
cd "$(dirname "$0")/.."

ollama create qwen2vl-expo -f Modelfile
ollama run qwen2vl-expo
