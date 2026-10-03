# README_MODELO — Qwen2-VL-2B-Instruct en Mac M1 (8 GB)

Modelo base: `bartowski/Qwen2-VL-2B-Instruct-GGUF` cuantizado **Q4_K_M**,
servido vía **Ollama** (texto) y **llama.cpp** (visión).

## 1. Estado instalado (2026-10-03)

- Ollama: `0.35.1` (servicio `brew services start ollama`, API en `http://localhost:11434`)
- Modelo Ollama activo: `hf.co/bartowski/Qwen2-VL-2B-Instruct-GGUF:Q4_K_M`
  (sin fallback: el pull primario funcionó; NO hizo falta `qwen2-vl:2b`)
- GGUF local en `models/`:
  - `Qwen2-VL-2B-Instruct-Q4_K_M.gguf` — ~940 MB (pesos LLM Q4_K_M)
  - `mmproj-Qwen2-VL-2B-Instruct-f16.gguf` — ~1.2 GB (proyector visión, **SÍ existe en el repo**,
    descargado también; imprescindible para visión con llama.cpp)
  - Total `models/` ≈ 2.2 GB. Blob Ollama ≈ 2.3 GB (`ollama list`).
- RAM esperada en M1 8 GB: 3–4 GB ocupados al inferir (pesos ~2.2 GB + KV cache ctx 8k).
  Cierra apps pesadas; si hay swapping baja a Q4_K_S o IQ3_M.

## 2. Cómo correr en Mac M1

### Opción A — Ollama (texto, exposición con system prompt F01–F20)

```bash
brew services start ollama          # o: ollama serve > /tmp/ollama.log 2>&1 &
bash scripts/descargar_modelo.sh    # re-descargable: ollama pull + hf download
bash scripts/run_ollama.sh          # = ollama create qwen2vl-expo -f Modelfile && ollama run qwen2vl-expo
```

Prueba no interactiva:

```bash
ollama run hf.co/bartowski/Qwen2-VL-2B-Instruct-GGUF:Q4_K_M \
  "Responde en una línea: ¿qué día ocurrieron los hechos de 1984 en la UNAL Bogotá?"
# Esperado: 16 de mayo de 1984 (con el custom: + cita [F04]/[F02], sede Bogotá UNAL)
```

### Opción B — llama.cpp (VISIÓN, recomendado para imágenes)

```bash
brew install llama.cpp
bash scripts/run_llamacpp.sh
# abre http://localhost:8080 (web UI con botón de adjuntar imagen)
```

`scripts/run_llamacpp.sh` usa `llama serve -hf bartowski/Qwen2-VL-2B-Instruct-GGUF:Q4_K_M`
(esta forma **resuelve el mmproj solo**, no hay que pasarlo).
Fallback sin red: `llama-server -m models/...Q4_K_M.gguf --mmproj models/mmproj-...f16.gguf`.

## 3. Cómo adjuntar imágenes

- **Ollama custom (`qwen2vl-expo` / `hf.co/...Q4_K_M`): el soporte de visión NO es
  fiable en este custom** (el Modelfile FROM trae `vision`, pero el CLI de Ollama
  no siempre adjunta imagen en modelos `hf.co/...`; puede responder como solo-texto).
  Para la expo con fotos/páginas PDF **NO uses Ollama para visión**.
- **Recomendado**: llama.cpp web UI en **http://localhost:8080**
  (arrastrar/soltar imagen + prompt, el mmproj ya está en `models/`).
- Alternativa: **LM Studio** (Mac M1): importa `models/Qwen2-VL-2B-Instruct-Q4_K_M.gguf`
  + mmproj como proyector, o busca el preset `Qwen2-VL-2B-Instruct-GGUF`.
- Nota: `dataset/train/train_qwen_chat.jsonl` trae `"images": null` (lote solo-texto);
  ver `dataset/README_DATASET.md` §8 para añadir PNG de páginas citadas.

## 4. Tamaño en disco / RAM

| Artefacto | Tamaño |
|---|---|
| `models/Qwen2-VL-2B-Instruct-Q4_K_M.gguf` | ~940 MB |
| `models/mmproj-Qwen2-VL-2B-Instruct-f16.gguf` | ~1.2 GB |
| Blob Ollama `hf.co/...:Q4_K_M` | ~2.3 GB (`ollama list`) |
| Total aproximado | ~4.5 GB (GGUF + blob Ollama duplican pesos) |

RAM: 3–4 GB en inferencia Q4_K_M (ctx 8k). Si el M1 de 8 GB se queda corto,
repite con `Q3_K_M` / `IQ3_M` del mismo repo.

## 5. System prompt (Modelfile)

Verbatim de `dataset/train/train_qwen_chat.jsonl`:

> Eres un asistente de investigación sobre protestas universitarias en Bogotá
> entre 1971 y 2025... Los identificadores F01-F20 remiten al catálogo
> documental del proyecto.

Reglas: español claro, distinguir hechos/testimonios/interpretaciones,
citar F01–F20, **no inventar cifras/citas/personas**, no atribuir a Bogotá
hechos nacionales sin respaldo local, declarar falta de evidencia.

## 6. Re-descargar todo

```bash
bash scripts/descargar_modelo.sh
```

Requiere: Ollama en ejecución + `hf` CLI (`pip install -U "huggingface_hub[cli]"`).
Los `*.gguf` están ignorados por git (ver `.gitignore`); los scripts sí se versionan.

## 7. Smoke test 2026-10-03 (demonio OK, contenido sin SFT NO fiable)

- `ollama run hf.co/...:Q4_K_M "¿qué día ocurrieron los hechos de 1984 en la UNAL Bogotá?"`
  → respondió `24 de febrero de 1984` (**incorrecto**).
- `ollama run qwen2vl-expo "..."` (con system prompt F01–F20) → `17 de abril de 1984`
  + fuente inexistente (**alucinación**; esperado: **16 de mayo de 1984**, sede Bogotá UNAL [F04]).
- Conclusión: inferencia y demonio funcionan; el conocimiento factual correcto
  requiere el fine-tuning piloto (`dataset/train/train_qwen_chat.jsonl` +
  `notebooks/finetune_qwen2vl_colab.ipynb`). No exponer respuestas sin SFT como verdad.
