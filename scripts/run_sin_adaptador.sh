#!/usr/bin/env bash
# Lanza Ollama con el modelo BASE (sin finetune): qwen2vl-expo (Q4_K_M).
# Uso: ./scripts/run_sin_adaptador.sh
set -euo pipefail
cd "$(dirname "$0")/.."

if ! ollama show qwen2vl-expo >/dev/null 2>&1; then
  echo "Creando qwen2vl-expo desde Modelfile..."
  ollama create qwen2vl-expo -f Modelfile
fi
echo "Corriendo BASE sin adaptador (qwen2vl-expo). Para imágenes usa ./scripts/run_llamacpp.sh"
exec ollama run qwen2vl-expo
