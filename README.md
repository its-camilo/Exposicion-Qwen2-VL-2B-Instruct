# Exposicion-Qwen2-VL-2B-Instruct

Proyecto de exposición: **Qwen2-VL-2B-Instruct** (visión-lenguaje 2B) aplicado a protestas universitarias en Bogotá 1971-2025, con énfasis en el 16 de mayo de 1984.

Repo: https://github.com/its-camilo/Exposicion-Qwen2-VL-2B-Instruct (privado)

## Estructura

- `Modelfile` — custom Ollama `qwen2vl-expo` (Q4_K_M + system prompt del dataset)
- `scripts/`
  - `descargar_modelo.sh` — re-descarga Ollama + GGUF + mmproj
  - `run_ollama.sh` — `ollama create qwen2vl-expo -f Modelfile && ollama run qwen2vl-expo`
  - `run_sin_adaptador.sh` — corre la base `qwen2vl-expo` (solo texto)
  - `run_con_adaptador.sh` — detecta el GGUF finetuneado + mmproj en `~/Descargas`, crea `qwen2vl-expo-ft`
  - `run_llamacpp.sh` — sirve la base con llama.cpp (UI http://localhost:8080)
  - `run_llamacpp_ft.sh` — sirve el **finetuneado con visión** (modelo + mmproj, CPU en M1 8GB)
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
./scripts/run_sin_adaptador.sh   # base Q4_K_M (qwen2vl-expo)
./scripts/run_con_adaptador.sh   # finetuneado: detecta el GGUF de la celda 6b en ~/Descargas y crea qwen2vl-expo-ft
# o para imágenes (web UI http://localhost:8080):
./scripts/run_llamacpp.sh
```

Modelo base sin finetune **alucina fechas/citas** (verificado: responde 24-feb-1984 / 17-abr-1984). El SFT piloto lo corrige parcialmente.

## Fuentes: tratamiento y clasificación

Materia prima en `dataset/raw/` (copia fiel del paquete "Protestas universitarias en Bogotá 1971–2025"):

- **Catálogo F01–F20**: 20 fuentes clasificadas por **tipo** (artículos académicos, páginas institucionales, periodismo de memoria, trabajos de grado, comunicados estudiantiles/institucionales, reportes de movilidad, bases de datos), **período/alcance** (Bogotá vs. contexto nacional), **uso recomendado** (prioridad alta/media, qué extraer) y **nivel de verificación** (texto leído + PDF descargado vs. solo ficha/resumen).
- **6 PDFs originales** preservados sin modificación en `pdfs_originales/` (hashes SHA-256 en `atribuciones_y_control.json`); extracciones de trabajo en `textos_para_preparacion/` (el OCR de F01/F11 no está corregido: no usar para cifras literales).
- **Criterio de inclusión**: hechos universitarios bogotanos 1971–2025, énfasis obligatorio 16-may-1984 (UNAL Bogotá). F16 (reserva de usos mecánicos) y comentarios de blogs **excluidos** del entrenamiento.
- **Límites honestos**: cobertura selectiva (no es censo; floja en 1985–2009, privadas y 2021). El informe "Reventando silencios" (35MB) se agregó como referencia aparte, fuera del SFT.

## Dataset: cómo se armó

- `train/`: 30 ejemplos SFT piloto (`train_qwen_chat.jsonl`, formato `{"messages": [system, user, assistant]}`), redacción sintética cotejada con pasajes (8 sobre 1984), con `trazabilidad_entrenamiento.json` (fuente + localizador por ejemplo).
- `val/`: 3 ejemplos de eventos distintos (sin 1984) para validar sin fuga.
- `test_reservado/`: 10 ejercicios E001–E010 + `contextos_evaluacion.json` — **prohibido entrenar con ellos** (miden lectura de evidencia, no memoria).
- Partición por **grupos de eventos**, no líneas aleatorias (criterio del LEEME).
- Normalización Qwen2-VL: dataset **solo-texto** (columna `images: null` eliminada; el collator visual falla con `None`).

## Finetuning: proceso

1. **Dónde**: Google Colab GPU L4/A100 + High-RAM (`notebooks/finetune_qwen2vl_colab.ipynb`, 11 celdas).
2. **Base**: `unsloth/Qwen2-VL-2B-Instruct-bnb-4bit` (4-bit). **Método**: LoRA r=16/alpha=16 **solo en el lenguaje** (torre visual congelada) → ~18M parámetros (0.83%).
3. **Entreno**: SFTTrainer (TRL), 80 steps, batch efectivo 8, lr 2e-4, warmup 5, cosine, ~10–18 min.
4. **Salidas**: LoRA en Drive (+ push Hub opcional), merge 16-bit opcional, **export GGUF Q4_K_M + mmproj** (celda 6b) y descarga directa (6c).
5. **Evaluación**: celda 7 compara base vs finetuneado (5 preguntas fijas, temp 0) con rúbrica 0–2 en `resultados_antes_despues.json`.
6. **Verificado en local**: el finetuneado leyó "16 de mayo de 1984" de una imagen de prueba.

## Darle imágenes en local (verificado en este Mac)

Requisito: `models/ft-model.gguf` + `models/ft-mmproj.gguf` (los deja `run_con_adaptador.sh`).

```bash
./scripts/run_llamacpp_ft.sh   # sirve en http://localhost:8080
```

Abre **http://localhost:8080/index.html** (página incluida en `webui/`), adjunta la imagen con el botón y pregunta. Notas honestas:

- En M1 8GB corre en CPU (`-ngl 0`): más lento pero evita OOM de Metal (con GPU falla por memoria). Para probar GPU parcial: `NGL=20 ./scripts/run_llamacpp_ft.sh`.
- `ollama run` interactivo **no acepta imágenes**, y `qwen2vl-expo-ft` quedó en Ollama sin capacidad `vision` (el GGUF local se registró sin mmproj). Para visión con el finetuneado usa llama.cpp.
- Vía API (para scripts): `POST http://127.0.0.1:8080/v1/chat/completions` (OpenAI-compatible) con la imagen en base64 en `messages[].content[]` (`type: image_url`).

## Finetune en Colab (plan pago, L4/A100)

1. Sube `notebooks/finetune_qwen2vl_colab.ipynb` a Colab, activa GPU + High-RAM.
2. Base: `unsloth/Qwen2-VL-2B-Instruct-bnb-4bit`, LoRA r16/a16, 80 steps, lr 2e-4, batch efectivo 8.
3. Dataset auto-descargado desde este repo (`dataset/train/train_qwen_chat.jsonl`).
4. Guarda LoRA en Drive + push Hub + exporta GGUF Q4_K_M para el Mac.
5. La celda 7 hace **antes vs después** con 5 preguntas fijas y guarda `resultados_antes_despues.json`.

## Licencias

Fuentes CC BY-NC-ND (varias) + testimonios. Uso académico/no comercial. Ver `dataset/README_DATASET.md` § licencias. No afirma memoria factual perfecta con 30 ejemplos: es piloto.
