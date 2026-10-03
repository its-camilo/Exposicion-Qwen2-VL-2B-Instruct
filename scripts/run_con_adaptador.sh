#!/usr/bin/env bash
# Lanza Ollama con el modelo FINETUNEADO (qwen2vl-expo-ft).
# Detecta solo en ~/Downloads (o models/):
#   1) GGUF fusionado de Colab (celda 6b): *protestas*.gguf, *merged*.gguf,
#      *finetune*.gguf, *ft*.gguf, *lora*.gguf -> crea qwen2vl-expo-ft FROM ese GGUF.
#   2) Solo LoRA crudo (qwen2vl-2b-protestas-bogota-lora.zip/dir): Ollama actual
#      ya no acepta adaptadores sueltos (instrucción ADAPTER eliminada); se indica
#      cómo generar el GGUF fusionado en Colab.
# Uso: ./scripts/run_con_adaptador.sh
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/.." && pwd)"
DL="$HOME/Downloads"

GGUF="$(ls -t "$DL"/*[Pp]rotestas*.gguf "$DL"/*merged*.gguf "$DL"/*finetune*.gguf "$DL"/*[Ff]t*.gguf "$DL"/*[Ll]ora*.gguf "$PROJ"/models/*[Pp]rotestas*.gguf 2>/dev/null | head -n 1 || true)"

if [[ -n "${GGUF:-}" ]]; then
  echo "GGUF finetuneado detectado: $GGUF"
  { echo "FROM $GGUF"; grep -v '^FROM ' "$PROJ/Modelfile"; } > "$PROJ/Modelfile.ft"
  ollama create qwen2vl-expo-ft -f "$PROJ/Modelfile.ft"
  echo "Corriendo FINETUNEADO (qwen2vl-expo-ft). Para imágenes usa ./scripts/run_llamacpp.sh con este GGUF."
  exec ollama run qwen2vl-expo-ft
fi

if ls "$DL"/qwen2vl-2b-protestas-bogota-lora* >/dev/null 2>&1; then
  echo "Encontré el adaptador LoRA crudo en $DL, pero Ollama (v0.35+) ya no acepta"
  echo "adaptadores sueltos (instrucción ADAPTER eliminada de la documentación oficial)."
  echo "Genera el GGUF fusionado en Colab con la celda 6b (DO_GGUF=True), bájalo con"
  echo "la celda 6c a Descargas y reejecuta este script."
  exit 1
fi

echo "No encontré ni GGUF fusionado ni LoRA en $DL."
echo "En Colab ejecuta la celda 6c (descargar adaptador) y/o 6b (exportar GGUF Q4_K_M),"
echo "luego reejecuta este script."
exit 1
