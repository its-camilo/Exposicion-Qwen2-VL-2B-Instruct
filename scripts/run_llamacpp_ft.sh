#!/usr/bin/env bash
# Sirve el modelo FINETUNEADO con visión (llama.cpp + mmproj) y abre la web UI.
# En M1 8GB corre en CPU (-ngl 0): más lento pero evita OOM de Metal con el mmproj F16.
# Para probar offload parcial a GPU: NGL=20 ./scripts/run_llamacpp_ft.sh
# Uso: ./scripts/run_llamacpp_ft.sh  (luego abre http://localhost:8080 y adjunta la imagen)
set -eu
PROJ="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJ"
NGL="${NGL:-0}"

command -v llama-server >/dev/null 2>&1 || { echo "Falta llama.cpp: brew install llama.cpp"; exit 1; }
[ -f models/ft-model.gguf ] || { echo "Falta models/ft-model.gguf: corre ./scripts/run_con_adaptador.sh primero"; exit 1; }
MMPROJ=""
if [ -f models/ft-mmproj.gguf ]; then
  MMPROJ="models/ft-mmproj.gguf"
else
  echo "AVISO: sin models/ft-mmproj.gguf funcionará el chat pero NO la visión."
fi

echo "Sirviendo finetuneado (ngl=$NGL) en http://localhost:8080/index.html ..."
if [ -n "$MMPROJ" ]; then
  exec llama-server -m models/ft-model.gguf --mmproj "$MMPROJ" -ngl "$NGL" --path "$PROJ/webui" --host 127.0.0.1 --port 8080
else
  exec llama-server -m models/ft-model.gguf -ngl "$NGL" --path "$PROJ/webui" --host 127.0.0.1 --port 8080
fi
