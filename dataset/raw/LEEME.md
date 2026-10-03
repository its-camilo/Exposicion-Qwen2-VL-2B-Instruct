# Protestas universitarias en Bogotá: paquete documental inicial

Preparado para Andrés. Consulta: 1 de octubre de 2026.

## Delimitación

- Núcleo: 1 de enero de 1971 a 31 de diciembre de 2025.
- Tema: movilizaciones y protestas universitarias en Bogotá, sus demandas, organización, repertorios, respuestas institucionales y memoria.
- Énfasis obligatorio: hechos del 16 de mayo de 1984 en la Universidad Nacional, sede Bogotá, denominados masacre por fuentes testimoniales e institucionales del catálogo.
- El inicio en 1971 permite estudiar organización, cogobierno y demandas anteriores a 1984; 2025 ofrece un cierre anual completo. Es una decisión de diseño, no la fecha de origen del movimiento.
- Universidad Nacional, Pedagógica y Distrital tienen mayor presencia en esta entrega. Las universidades privadas también entran en el alcance cuando hay evidencia local. La colección no representa equilibradamente todas las instituciones ni todos los años.
- Excluir protestas escolares y paros generales sin participación universitaria identificable. Los documentos nacionales sirven de contexto; sus hechos no se atribuyen automáticamente a Bogotá.
- F18 es antecedente sobre 1929 y 1954; está fuera del núcleo. El corte se aplica a los hechos estudiados, no obliga a excluir investigaciones publicadas después.

## Qué contiene

1. `Guia_y_catalogo_Bogota_1971_2025.pdf`: guía de lectura, 20 fichas y recomendaciones.
2. `catalogo_fuentes.md` y `catalogo_fuentes.json`: 20 fuentes con autoría, fechas, alcance, acceso, licencia observada y vínculos.
3. `pdfs_originales/`: seis PDF originales, sin modificación. Se conservan los créditos y licencias del editor.
4. `textos_para_preparacion/`: seis extracciones de texto con marcas de página. F01 y F11 proceden de OCR automático; no han sido corregidos integralmente. Los otros textos pueden contener errores de columnas, ligaduras y saltos de línea.
5. `entrenamiento_piloto_30.jsonl`: 30 ejemplos de conversación para un piloto de ajuste supervisado.
6. `trazabilidad_entrenamiento.json`: fuentes, localizadores y estado de revisión de cada ejemplo, en el mismo orden que el JSONL.
7. `evaluacion_con_evidencia_10.jsonl` y `contextos_evaluacion.json`: diez ejercicios reservados de lectura de evidencia; no incluirlos en entrenamiento.
8. `atribuciones_y_control.json`: tamaños, páginas, hashes y método de extracción de los PDF.

## Orden de lectura sugerido

1984: F01, F02 y F04; después F03 y las rutas F05-F06. Organización y demandas: F07, F08 y F20. Experiencias y otras universidades: F09-F13 y F19. Cierre reciente: F14-F16. Ampliación sistemática: F17.

## Cómo usar el material para fine-tuning

La colección documental es la materia prima. Para entrenar a responder preguntas conviene construir pares de pregunta y respuesta respaldados por pasajes concretos. El JSONL usa una lista `messages`, con los roles `system`, `user` y `assistant`. Es un esquema conversacional de ejemplo, documentado entre otros por Hugging Face TRL; no garantiza compatibilidad automática con cualquier proveedor o plantilla de chat.

Los 30 ejemplos son redacción sintética propia, cotejada con los pasajes indicados. No son respuestas de los autores ni una revisión experta independiente. Ocho ejemplos tratan directamente 1984. Los 30 sirven para comprobar el flujo, no para afirmar que un modelo ya domina 55 años de historia. No se entrenó ningún modelo en esta entrega.

1. Revisar los originales y corregir los errores de extracción en los pasajes que se utilizarán. Registrar página PDF y página impresa por separado.
2. Ampliar preguntas sobre causas, secuencia, demandas, participantes colectivos, resultados, comparaciones y límites de las fuentes. Incluir también actividades pacíficas, organización, arte y negociación.
3. Etiquetar cada afirmación: documentada por la fuente, testimonio atribuido, interpretación del autor o dato no establecido. Conservar versiones discrepantes con su autor y fecha; no fabricar una cifra de consenso.
4. Mantener juntas las paráfrasis y los documentos del mismo acontecimiento al repartir entrenamiento, validación y prueba. Eliminar duplicados antes de repartir. Una proporción inicial posible es 80/10/10, ajustada a grupos de eventos, no a líneas aleatorias.
5. Usar entrenamiento para actualizar parámetros, validación para decidir ajustes y prueba final solo para medir el resultado. No elegir hiperparámetros mirando las respuestas del examen final.
6. Comparar el modelo original y el ajustado con las mismas preguntas, formato y configuración. Medir exactitud, respaldo de las referencias, pertinencia geográfica y temporal, y capacidad de reconocer información insuficiente. La pérdida de entrenamiento por sí sola no valida hechos históricos.

Los IDs F01-F20 sirven para vincular la respuesta al catálogo. Un modelo ajustado puede inventar o mezclar referencias: resolver el identificador en la aplicación y comprobar el pasaje sigue siendo necesario. Para citas verificables y actualizaciones, el fine-tuning puede complementarse con consulta documental; no se presupone que el entrenamiento garantice memoria factual ni fuentes correctas.

No se fijan modelo, épocas, tasa de aprendizaje ni requisitos de GPU porque no se ha definido la plataforma. Antes de ejecutar el piloto, adaptar formato, plantilla de conversación y límites de longitud al modelo elegido. Conservar esta versión y las decisiones de preprocesamiento.

## Uso de la evaluación incluida

Cada fila E001-E010 referencia un `contexto_id`. El evaluador debe adjuntar el `texto` correspondiente de `contextos_evaluacion.json` a la pregunta y comparar la respuesta con el criterio. Las fuentes F14-F15 y los hechos de 2024-2025 de estos ejercicios no se utilizan en los 30 ejemplos de entrenamiento.

Esta evaluación comprueba uso de evidencia nueva y abstención; NO mide conocimiento memorizado sobre hechos ausentes del entrenamiento. Si el sistema final responde sin documentos, preparar además un examen cerrado de retención con preguntas nuevas sobre los contenidos efectivamente entrenados. Diez preguntas son una comprobación exploratoria, no un benchmark representativo.

Puntuar cada respuesta de 0 a 2 en: exactitud, respaldo de fuente, pertinencia y manejo de incertidumbre. Comparar los errores, además del promedio. Considerar fallos críticos inventar personas, cifras de víctimas o referencias. Conservar las preguntas reservadas fuera de todos los archivos de entrenamiento.

## Licencias, testimonios y comentarios

Las seis revistas incluidas publican sus artículos bajo las licencias Creative Commons indicadas en el catálogo. Se conserva cada original y su atribución. La extracción de texto es una copia de trabajo para lectura y revisión; no es una edición corregida ni una nueva fuente histórica. Respetar las restricciones NoComercial y, donde existe, SinDerivadas; la disponibilidad pública no certifica permiso para cualquier uso del modelo. Revisar el uso previsto antes de entrenamiento o distribución comercial.

F16 contiene una reserva explícita de usos mecánicos: se entrega su referencia y una descripción breve para consulta, sin copia integral ni ejemplos derivados para SFT. Para otras páginas, el catálogo declara cuando no se verificó una licencia.

El blog F20 aporta tanto un comunicado como comentarios públicos. Solo el comunicado se usa en el piloto. Los comentarios no constituyen una muestra representativa ni acreditan la identidad de quien escribe. No recopilar perfiles, contactos ni convertir acusaciones personales en respuestas factuales. Los audios de F04 están enlazados, pero no transcritos.

## Vacíos concretos de esta versión

- No se obtuvo el informe completo Reventando silencios ni una exportación de la base de eventos de CINEP.
- F09 y F10 se describen con sus fichas y resúmenes, no con lectura completa de las tesis. F13 solo se verificó mediante el resumen del índice institucional.
- La cobertura es selectiva, especialmente para 1985-2009, universidades privadas y protestas de 2021. No representa un censo de protestas.
- Las transcripciones OCR necesitan revisión antes de extracción automática de nombres o cifras. Se identificó además una diferencia entre las páginas citadas por la ficha de F11 y las impresas en su PDF.
- Se recomienda ampliar por vacíos y por errores observados en el piloto, no inflar el volumen mediante paráfrasis repetidas.

## Documentación técnica consultada

Hugging Face TRL, SFT Trainer: https://huggingface.co/docs/trl/sft_trainer (consulta: 2026-10-01).
