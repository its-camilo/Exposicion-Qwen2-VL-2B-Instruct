#!/usr/bin/env bash
# Sirve Qwen2-VL-2B-Instruct con llama.cpp (recomendado para VISIÓN en Mac M1).
# Uso: bash scripts/run_llamacpp.sh
# Abre luego http://localhost:8080 en el navegador para adjuntar imágenes.
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v llama-server >/dev/null 2>&1 && ! command -v llama >/dev/null 2>&1; then
  echo "llama.cpp no encontrado. Instalando con Homebrew..."
  brew install llama.cpp
fi

# Vía 1 (preferida si hay red): descarga y sirve directo desde HF.
# Nota: `llama serve -hf` resuelve solo el mmproj, no hace falta pasarlo.
if command -v llama >/dev/null 2>&1; then
  llama serve -hf bartowski/Qwen2-VL-2B-Instruct-GGUF:Q4_K_M
else
  # Vía 2 (fallback local, sin red): usa los GGUF ya descargados en models/.
  # Requiere el mmproj para visión (ver models/).
  llama-server \
    -m models/Qwen2-VL-2B-Instruct-Q4_K_M.gguf \
    --mmproj models/mmproj-Qwen2-VL-2B-Instruct-f16.gguf \
    --host 127.0.0.1 --port 8080
fi
