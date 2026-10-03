# Exposicion-Qwen2-VL-2B-Instruct

Proyecto de exposición: **Qwen2-VL-2B-Instruct** (visión-lenguaje 2B) aplicado a protestas universitarias en Bogotá 1971-2025, con énfasis en el 16 de mayo de 1984.

Repo: https://github.com/its-camilo/Exposicion-Qwen2-VL-2B-Instruct (privado)

## Estructura

- `Modelfile` — custom Ollama `qwen2vl-expo` (Q4_K_M + system prompt del dataset)
- `scripts/`
  - `descargar_modelo.sh` — re-descarga Ollama + GGUF + mmproj
  - `run_ollama.sh` — `ollama create qwen2vl-expo -f Modelfile && ollama run qwen2vl-expo`
  - `run_llamacpp.sh` — `llama serve -hf bartowski/Qwen2-VL-2B-Instruct-GGUF:Q4_K_M` (recomendado para imágenes, UI http://localhost:8080)
- `models/` — GGUF local **NO versionado** (ver `.gitignore`): `Qwen2-VL-2B-Instruct-Q4_K_M.gguf` (940MB) + `mmproj-*.gguf` (1.2GB)
- `dataset/` — ver `dataset/README_DATASET.md`
  - `raw/` copia fiel de Descargas (catálogo F01-F20, 6 PDFs, 6 txt, LEEME, trazabilidad + informe Reventando Silencios 35MB)
  - `train/entrenamiento_piloto_30.jsonl` + `train_qwen_chat.jsonl` (30, formato messages, images:null)
  - `val/validacion_3.jsonl` (3)
  - `test_reservado/evaluacion_con_evidencia_10.jsonl` (10, **NO ENTRENAR** E001-E010)
- `notebooks/finetune_qwen2vl_colab.ipynb` — finetune rápido en Colab (Unsloth + QLoRA, <20 min) + comparativa antes vs después. Ver `notebooks/README_COLAB.md`.
- `README_MODELO.md` — cómo correr en Mac M1 8GB + imágenes.

## Uso rápido Mac M1

```bash
./scripts/run_ollama.sh
# o para imágenes:
./scripts/run_llamacpp.sh
# abrir http://localhost:8080, arrastrar imagen
```

Modelo base sin finetune **alucina fechas/citas** (verificado: responde 24-feb-1984 / 17-abr-1984). El SFT piloto lo corrige parcialmente.

## Finetune en Colab (plan pago, L4/A100)

1. Sube `notebooks/finetune_qwen2vl_colab.ipynb` a Colab, activa GPU + High-RAM.
2. Base: `unsloth/Qwen2-VL-2B-Instruct-bnb-4bit`, LoRA r16/a16, 80 steps, lr 2e-4, batch efectivo 8.
3. Dataset auto-descargado desde este repo (`dataset/train/train_qwen_chat.jsonl`).
4. Guarda LoRA en Drive + push Hub + exporta GGUF Q4_K_M para el Mac.
5. La celda 7 hace **antes vs después** con 5 preguntas fijas y guarda `resultados_antes_despues.json`.

## Licencias

Fuentes CC BY-NC-ND (varias) + testimonios. Uso académico/no comercial. Ver `dataset/README_DATASET.md` § licencias. No afirma memoria factual perfecta con 30 ejemplos: es piloto.
