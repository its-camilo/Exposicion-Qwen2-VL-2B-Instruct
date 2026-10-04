# AGENTS.md — Exposicion-Qwen2-VL-2B-Instruct

Guía para futuros agentes de IA que trabajen en este repositorio. Leer antes de
modificar cualquier cosa.

## Qué es

Exposición con **Qwen2-VL-2B-Instruct** (visión-lenguaje, 2B) aplicado al dossier
de protestas universitarias en Bogotá 1971–2025 (énfasis 16-may-1984).
Repo GitHub **privado**: `its-camilo/Exposicion-Qwen2-VL-2B-Instruct`, rama `main`.
Idioma del proyecto: español.

## Estructura (no romper)

- `Modelfile` — modelo Ollama `qwen2vl-expo` (base Q4_K_M + system prompt del dataset).
- `Modelfile.ft` — GENERADO por `run_con_adaptador.sh` (lleva ruta absoluta). Gitignored.
- `scripts/` — `run_sin_adaptador.sh` (base), `run_con_adaptador.sh` (finetuneado,
  autodetecta GGUF+mmproj en `~/Downloads`), `run_ollama.sh`, `run_llamacpp.sh`,
  `descargar_modelo.sh`. Todos versionados (hay negaciones `!` en `.gitignore`).
- `models/` — SOLO local, gitignored (`*.gguf`, `.cache/`): base Q4_K_M + mmproj F16.
- `dataset/` — `raw/` copia fiel, `train/` 30 ejemplos, `val/` 3, `test_reservado/` 10.
- `notebooks/finetune_qwen2vl_colab.ipynb` — flujo Colab (11 celdas, ver orden abajo).

## Reglas duras del dataset

1. `test_reservado/evaluacion_con_evidencia_10.jsonl` (E001–E010) **JAMÁS entra a train**.
2. Formato train: `{"messages": [{system,user,assistant}]}`. La columna `images: null`
   del piloto DEBE eliminarse antes de entrenar (rompe el collator visual).
3. Licencias CC BY-NC-ND → uso académico, **no comercial**. No redistribuir PDFs fuera.
4. 30 ejemplos = piloto de estilo/citas, no memorización. No sobrestimar resultados.

## Gotchas ya pagados (no reintroducir)

- `f'...{!var}...'` es SyntaxError (el `!` es conversión). Usar `{not var}`.
- Dataset con `images: None` → `TypeError` en `fetch_images`. Normalizar a solo
  `messages` y dejar solo columna `text` en train/val.
- `tokenizer` de FastVisionModel es el **processor Qwen2-VL** (`images` va primero).
  Llamarlo SIEMPRE por keyword: `tok(text=[...], images=None, ...)`. Posicional
  mete el prompt como imagen → `ValueError` base64.
- `save_pretrained_gguf(path)` crea **CARPETA** (a veces `path_gguf`) con el `.gguf`
  + `*-mmproj.gguf` dentro. Buscar con `glob` en ambas, nunca asumir archivo.
- Sin **mmproj no hay visión** (solo chat). 6b/6c y `run_con_adaptador.sh` manejan ambos.
- `raw.githubusercontent.com` da **404 en repo privado** sin token → notebook usa
  secret `GITHUB_TOKEN` + fallback `files.upload()`.
- Avisos benignos (ignorar): tokens PAD/BOS/EOS, `push_to_hub_token`→`hub_token`.
- **Ollama ≥0.35 eliminó la instrucción `ADAPTER`** (ver docs oficiales). Finetune en
  Ollama = GGUF fusionado vía `FROM`, nunca adaptador suelto.
- Magias `!pip`/`!nvidia-smi` son válidas en Colab; excluirlas si se valida con `compile()`.

## Entorno local conocido

MacBookPro17,1 M1 8 GB (RAM ajustada: Q4_K_M ≈1 GB + mmproj ≈1.2 GB).
Ollama 0.35.1 (`brew services start ollama`). Modelos: `qwen2vl-expo` (base),
`qwen2vl-expo-ft` (finetuneado). `gh` autenticado como `its-camilo`.

## Al modificar

- Notebook: mantener orden de celdas (0 intro, 1–6 base/train/save, 6b/6c export,
  7 comparativa, final). Validar JSON + `compile()` de cada celda code.
- Probar scripts con `bash -n`; la rama de detección se prueba con dummies y se
  limpia después (incluido `models/ft-*.gguf` y `Modelfile.ft` de prueba).
- NO commitear `*.gguf`, `.DS_Store`, blobs de Ollama ni `Modelfile.ft`.
- Commits en español, descriptivos del fix. Push a `origin main` solo a petición.
