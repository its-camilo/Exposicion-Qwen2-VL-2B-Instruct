# Finetune Qwen2-VL-2B en Colab — Guía rápida

Notebook: `finetune_qwen2vl_colab.ipynb` (11 celdas, nbformat 4, validado con `python3 -c "import json; json.load(open(...))"`).

## Pasos

1. **Sube el notebook a Colab**: `Archivo > Subir notebook` o ábrelo desde GitHub (`its-camilo/Exposicion-Qwen2-VL-2B-Instruct`, rama `main`, ruta `notebooks/`).
2. **Activa GPU + High-RAM**: `Entorno > Cambiar tipo de entorno > Acelerador GPU (L4 o A100)` y activa **Memoria RAM alta**. Verifica en la celda 1 (`!nvidia-smi`, `torch.cuda.get_device_name`).
3. **Ejecutar todo**: `Entorno > Ejecutar todo` (o celda por celda):
   - Celda 2 instala Unsloth en una sola pasada (`unsloth[colab-new]`, `xformers trl peft accelerate bitsandbytes`).
   - Celda 3 pide token HF (usa secreto `HF_TOKEN`) y descarga `dataset/train/train_qwen_chat.jsonl` desde el raw de GitHub, con fallback a `files.upload()`.
   - Celda 5 entrena (~10–18 min, 80 steps). Celda 7 genera `resultados_antes_despues.json`.
4. **Descargar el modelo**:
   - LoRA desde Drive: `qwen2vl-2b-protestas-bogota-lora/` → Mac `~/Models/`.
   - O desde el Hub: `huggingface-cli download <tu-usuario>/qwen2vl-2b-protestas-bogota-lora`.
   - GGUF `Q4_K_M` (celda 6b, `DO_GGUF=True`) → `ollama create qwen2vl-protestas -f Modelfile` (ver celda final, usa `ADAPTER`).

## Notas

- Seeds fijos (`3407`), rutas relativas `../dataset/`, comentarios en español.
- Eval E001–E010 **no se entrena**, solo evaluación.
- Licencia dataset + adaptador: **CC BY-NC-ND 4.0** (no comercial). Respeta además la licencia Qwen de la base.
