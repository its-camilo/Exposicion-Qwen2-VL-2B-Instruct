# README_DATASET — Protestas universitarias en Bogotá (1971–2025)

Piloto SFT para Qwen2-VL-2B-Instruct. Copias de trabajo, **uso no comercial y de investigación**.
Fecha de organización: 2026-10-03. Orígenes copiados con `cp`/`rsync` (nunca movidos).

## 1. Origen (qué se copió y de dónde)

| Destino en `raw/` | Origen |
|---|---|
| `LEEME.md`, `catalogo_fuentes.json/.md`, `entrenamiento_piloto_30.jsonl`, `evaluacion_con_evidencia_10.jsonl`, `contextos_evaluacion.json`, `trazabilidad_entrenamiento.json`, `atribuciones_y_control.json`, `Guia_y_catalogo_Bogota_1971_2025.pdf`, `pdfs_originales/` (6 PDF), `textos_para_preparacion/` (6 txt) | `/Users/itscamilo/Downloads/Protestas_universitarias_Bogota/` (copia fiel) |
| `informe_reventando_silencios/Reventando Silencios Memorias del 16 de mayo.pdf` (35 MB) | `/Users/itscamilo/Downloads/Reventando Silencios Memorias del 16 de mayo.pdf` (copia) |
| `Guia_y_catalogo_Bogota_1971_2025_EXTRA_descargas.pdf` | `/Users/itscamilo/Downloads/Guia_y_catalogo_Bogota_1971_2025.pdf` — **DIFIERE** del incluido en la carpeta (sha256 distinto, 96 159 vs 71 188 bytes); se conserva como extra, no se sobrescribe el original |
| ZIP `Protestas_universitarias_Bogota_1971_2025.zip` | **NO descomprimido**: inspeccionado con `unzip -l` + comparación de nombres/tamaños byte a byte → **duplicado exacto** de la carpeta (21 ficheros, mismos tamaños). Ver `manifest.json:zip_duplicado`. |

## 2. Delimitación temporal y temática

- **Núcleo: 1971-01-01 a 2025-12-31.** Movilizaciones y protestas universitarias en Bogotá: demandas, organización, repertorios, respuestas institucionales y memoria.
- **Énfasis obligatorio: 16 de mayo de 1984**, sede Bogotá de la Universidad Nacional (denominado masacre por fuentes testimoniales e institucionales del catálogo: F01, F02, F04–F06 + informe Reventando silencios).
- 1971 abre (organización, cogobierno, Programa Mínimo); 2025 cierra el año. Decisión de diseño, no origen del movimiento.
- UNAL, Pedagógica y Distrital tienen mayor presencia; privadas solo con evidencia local. Cobertura selectiva (huecos 1985–2009, 2021). Excluir protestas escolares y paros generales sin participación universitaria identificable. F18 (1929/1954) es antecedente fuera del núcleo.
- Detalle completo en `raw/LEEME.md`.

## 3. Licencias — ADVERTENCIA NO COMERCIAL

- Revistas incluidas: **CC BY-NC-ND** (F01, F07, F08, F09, F10, F11, F19) y **CC BY-NC** (F02, F03). **NC = no comercial; ND = sin derivadas.**
- F04/F05/F06/F12–F15/F17/F18/F20: sin licencia verificada o con reserva explícita (F16 Caracol: todos los derechos reservados + reserva de usos mecánicos → solo referencia, sin copia ni SFT).
- Los 30 ejemplos son **redacción sintética propia cotejada con pasajes**, no respuestas de los autores ni revisión experta. La extracción `textos_para_preparacion/` es copia de trabajo con errores (OCR F01/F11 sin corregir).
- **Antes de entrenar o distribuir (y en especial cualquier uso comercial, incluido fine-tuning como servicio), revisar `catalogo_fuentes.json` campo `licencia_observada` + `permiso_especifico_fine_tuning` y el apartado de licencias de `raw/LEEME.md`.** La disponibilidad pública no certifica permiso. Este paquete no otorga derechos.
- Informe Reventando silencios: verificar su licencia de origen antes de derivar entrenamiento; aquí se conserva como documento de consulta.

## 4. Estructura

```
dataset/
  README_DATASET.md
  manifest.json
  raw/  (copia fiel, no editar: fuente de verdad documental)
    LEEME.md, catalogo_fuentes.json/.md, trazabilidad_entrenamiento.json,
    atribuciones_y_control.json, entrenamiento_piloto_30.jsonl,
    evaluacion_con_evidencia_10.jsonl, contextos_evaluacion.json
    Guia_y_catalogo_Bogota_1971_2025.pdf
    Guia_y_catalogo_Bogota_1971_2025_EXTRA_descargas.pdf
    pdfs_originales/ (6 PDF F01,F02,F03,F07,F08,F11)
    textos_para_preparacion/ (6 txt)
    informe_reventando_silencios/Reventando Silencios Memorias del 16 de mayo.pdf
  train/
    entrenamiento_piloto_30.jsonl  (copia exacta de raw, 30 líneas)
    train_qwen_chat.jsonl          (validado: 30 líneas {"messages":[{role,content}],"images":null})
  val/
    validacion_3.jsonl             (3 líneas formato Qwen, grupos 1971/2011/2019, sin 1984)
  test_reservado/
    evaluacion_con_evidencia_10.jsonl (copia, E001–E010)
    contextos_evaluacion.json         (copia, C2024/C2025)
    NO_ENTRENAR.txt
```

## 5. Split por grupos de eventos (80/10/10 orientativo, por grupos, no por líneas aleatorias)

- Piloto actual: **train 30 / val 3 / test 10** (ver conteos en `manifest.json`). El 80/10/10 del LEEME es la proporción objetivo al escalar; con 30+3+10 el reparto honesto se hace **por grupo de evento**: paráfrasis y documentos del mismo acontecimiento van juntos al mismo split, se eliminan duplicados antes de repartir.
- `val/validacion_3.jsonl`: líneas 11/15/23 del train original → **T011 (1971, Segundo Encuentro/Programa Mínimo, F07)**, **T015 (2011, primera MANE en la Distrital, F08)**, **T023 (2019, comunicado DIE-Distrital, F12)**. Tres eventos distintos, **ninguno de 1984** (evita leakage del tema de énfasis) y ninguno E00x.
- ⚠️ Val son copias de grupos de train (práctica de piloto). Para validación estricta, **excluir T011/T015/T023 de train antes de ajustar** (quedarían 27) o tratar val solo como chequeo de formato/flujo, no como early-stopping honesto.
- Test (E001–E010, F14/F15, hechos 2024–2025) **no aparece en train**: reservado para medir lectura de evidencia nueva + abstención. Ver `test_reservado/NO_ENTRENAR.txt`.

## 6. AVISO: E001–E010 reservados — NO entrenar

Los IDs **E001–E010** viven solo en `test_reservado/`. Verificado el 2026-10-03: **ningún `E00x` aparece en `train/`** (`grep -o "E00[0-9]" train/*.jsonl` vacío). No los copies, parafrasees ni los uses para hiperparámetros. Su criterio de puntuación (0–2 por exactitud/respaldo/pertinencia/incertidumbre) está en `raw/LEEME.md`.

## 7. Cómo citar F01–F20

- Los IDs **F01–F20** remiten a `raw/catalogo_fuentes.json` (autoría, fechas, alcance, licencia, URL, localizador, sha256). Resolver el identificador en la aplicación y comprobar el pasaje: el modelo puede inventar o mezclar referencias.
- Reglas: atribuir cada afirmación (documentada / testimonio atribuido / interpretación / no establecido), conservar versiones discrepantes con autor y fecha, no fabricar cifras de consenso, registrar página PDF y página impresa por separado.
- F16: solo consulta/contraste, sin SFT. F04 audios: transcribir y cotejar antes de usar. F09/F10/F13: fichas/resúmenes, leer el completo antes de afirmar.

## 8. Qwen2-VL: campo `images` y cómo añadir páginas PDF (opcional)

- `train_qwen_chat.jsonl` y `val/validacion_3.jsonl` usan el esquema validado por línea:
  `{"messages":[{"role":"system"|"user"|"assistant","content":str}],"images":null}`.
  `images:null` = lote actual **solo-texto** (válido para Qwen2-VL en modo texto; el LEEME advierte adaptar plantilla/límites al modelo).
- Para añadir evidencia visual después (una o varias páginas por ejemplo):
  1. Renderizar la página citada en `trazabilidad_entrenamiento.json:localizador` a PNG (≈1024 px lado mayor).
  2. Cambiar `"images":null` → `"images":["images/F02_p04-05.png"]` (rutas relativas al JSONL) y mencionar la figura en el `user` ("Observa la página anexa…").
  3. Revalidar con `python3 -c "import json;[json.loads(l) for l in open('train/train_qwen_chat.jsonl')]"` y comprobar que cada ruta existe.
- Ejemplo con PyMuPDF (no ejecutado aquí porque `pymupdf` **no está instalado** → no hay `dataset/images_muestra/`; solo se documenta):
  ```bash
  pip install pymupdf
  python3 -c "import fitz; d=fitz.open('raw/pdfs_originales/F02_Florez_1984_Controversia.pdf'); p=d[4]; p.get_pixmap(matrix=fitz.Matrix(2,2)).save('images_muestra/F02_p05.png')"
  ```
  Respetar licencias ND/NC al redistribuir páginas renderizadas.

## 9. Validación ejecutada (2026-10-03)

- `python3 -c "import json; [json.loads(l) for l in open(f)]"` → OK en los 4 jsonl (train 30, train_qwen 30, val 3, eval 10).
- `wc -l` → 30 / 30 / 3 / 10. `grep E00x train/` → vacío.
- sha256 en `manifest.json` (clave `archivos`). Hashes de los 2 PDF grandes en la sección 10.

## 10. Hashes de los 2 PDF grandes (+ guía extra y F01/F11 para referencia)

- Informe Reventando silencios (34 MB): `c0164271a01afaf0ccdd808479d85e98ba0b489c5c1f7fb872735c0b29c61f70`
- Guía EXTRA de Descargas (96 159 bytes, difiere de la incluida): `06ffba085df9be2364eeeb8df44d6a5ea8da138abc0d74aabaf9522c4d4bdc53`
- Guía incluida en paquete (71 188 bytes): `66c0a051cb0a8b6366727b481f5aaf748143a5f9cc8a8066a1fe1ef1739cd0c4`
- F01 (18 MB, mayor de `pdfs_originales/`): `c180be0f84091c6e9263ef25b591d9091119b4aa201fab68a61283e24b950d46`
- F11 (8.5 MB): `bfe6f8626de9157b60a0a74147e4a1a956104d6cfc2287ab6144c3fc6343ade6`
