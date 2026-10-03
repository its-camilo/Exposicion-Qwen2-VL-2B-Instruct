#!/usr/bin/env bash
# Re-descarga el modelo Qwen2-VL-2B-Instruct Q4_K_M para Ollama + GGUF local.
# Uso: bash scripts/descargar_modelo.sh
set -euo pipefail
cd "$(dirname "$0")/.."

OLLAMA_MODEL="hf.co/bartowski/Qwen2-VL-2B-Instruct-GGUF:Q4_K_M"
HF_REPO="bartowski/Qwen2-VL-2B-Instruct-GGUF"
GGUF_FILE="Qwen2-VL-2B-Instruct-Q4_K_M.gguf"
MMPROJ_FILE="mmproj-Qwen2-VL-2B-Instruct-f16.gguf"

echo "==> 1/2 Ollama pull (ejecución directa)"
ollama pull "$OLLAMA_MODEL"

echo "==> 2/2 GGUF directo en models/ (para llama.cpp / LM Studio)"
mkdir -p models
# CLI nuevo `hf` (huggingface_hub>=0.35) o legacy `huggingface-cli`
if command -v hf >/dev/null 2>&1; then
  HF_DL="hf download"
elif command -v huggingface-cli >/dev/null 2>&1; then
  HF_DL="huggingface-cli download"
else
  echo "Instalando huggingface_hub[cli]..."
  python3 -m pip install -U "huggingface_hub[cli]" --break-system-packages
  HF_DL="hf download"
fi
# shellcheck disable=SC2086
$HF_DL "$HF_REPO" --include "$GGUF_FILE" --local-dir models/
# shellcheck disable=SC2086
$HF_DL "$HF_REPO" --include "$MMPROJ_FILE" --local-dir models/

echo "==> Verificación"
ls -lh models/
ollama list
