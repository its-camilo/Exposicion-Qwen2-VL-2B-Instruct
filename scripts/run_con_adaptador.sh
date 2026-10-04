#!/usr/bin/env bash
# Lanza Ollama con el modelo FINETUNEADO (qwen2vl-expo-ft).
# Detecta solo en ~/Downloads (o models/):
#   1) GGUF fusionado de Colab (celda 6b): *protestas*.gguf, *merged*.gguf,
#      *finetune*.gguf, *Qwen2-VL*.gguf (excluye *mmproj*) + su mmproj
#      -> copia ambos a models/ y crea qwen2vl-expo-ft FROM la copia local.
#   2) Solo LoRA crudo (qwen2vl-2b-protestas-bogota-lora.zip/dir): Ollama actual
#      ya no acepta adaptadores sueltos (instrucción ADAPTER eliminada); se indica
#      cómo generar el GGUF fusionado en Colab.
# Uso: ./scripts/run_con_adaptador.sh
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/.." && pwd)"
DL="$HOME/Downloads"

MODEL="$(ls -t "$DL"/*[Pp]rotestas*.gguf "$DL"/*merged*.gguf "$DL"/*finetune*.gguf "$DL"/*Qwen2-VL*.gguf "$PROJ"/models/*[Pp]rotestas*.gguf 2>/dev/null | grep -vi 'mmproj' | head -n 1 || true)"
MMPROJ="$(ls -t "$DL"/*mmproj*.gguf "$PROJ"/models/*mmproj*.gguf 2>/dev/null | head -n 1 || true)"

if [[ -n "${MODEL:-}" ]]; then
  echo "GGUF finetuneado detectado: $MODEL"
  cp -n "$MODEL" "$PROJ/models/ft-model.gguf" 2>/dev/null || true
  if [[ -n "${MMPROJ:-}" ]]; then
    echo "Mmproj detectado: $MMPROJ"
    cp -n "$MMPROJ" "$PROJ/models/ft-mmproj.gguf" 2>/dev/null || true
  else
    echo "AVISO: sin mmproj en Descargas -> funcionara el chat pero NO la vision."
    echo "Descarga tambien el *-mmproj.gguf con la celda 6c y reejecuta."
  fi
  { echo "FROM $PROJ/models/ft-model.gguf"; grep -v '^FROM ' "$PROJ/Modelfile"; } > "$PROJ/Modelfile.ft"
  ollama create qwen2vl-expo-ft -f "$PROJ/Modelfile.ft"
  echo "Corriendo FINETUNEADO (qwen2vl-expo-ft)."
  echo "Si las imagenes no responden en Ollama, usa llama.cpp con mmproj:"
  echo "  llama serve -m $PROJ/models/ft-model.gguf --mmproj $PROJ/models/ft-mmproj.gguf"
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
echo "En Colab ejecuta la celda 6b (exportar GGUF Q4_K_M + mmproj) y 6c (descargar),"
echo "luego reejecuta este script."
exit 1
