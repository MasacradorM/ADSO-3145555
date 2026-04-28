ADRs – Decisiones de arquitectura sobre el modelo de datos

Este documento reúne un conjunto de decisiones arquitectónicas relacionadas con cambios en el esquema de la base de datos. Su propósito es dejar registro claro de qué se modificó, por qué se tomó cada decisión, qué alternativas se evaluaron y cuáles son los efectos esperados.

ADR 001 – Simplificación en seat_assignment

Título: Eliminación de una clave foránea compuesta innecesaria

Decisión

Se eliminará la clave foránea compuesta definida por los campos:

(ticket_segment_id, flight_segment_id)

en la tabla seat_assignment.

Contexto y justificación

El campo ticket_segment_id ya es suficiente para identificar de manera única un registro en ticket_segment. Incluir adicionalmente flight_segment_id en la relación introduce redundancia y complejidad innecesaria, sin aportar beneficios reales en la integridad de los datos.

Alternativas consideradas
Mantener la clave foránea compuesta actual.
Rediseñar ticket_segment con una clave compuesta real.
Usar únicamente ticket_segment_id como referencia.
Consecuencias
Se simplifica el modelo de datos.
Las consultas y relaciones son más fáciles de mantener.
Posible mejora en el rendimiento al reducir validaciones redundantes.
La integridad se preserva mediante la clave primaria existente.
ADR 002 – Relación directa con flight_segment

Título: Incorporación de clave foránea hacia flight_segment

Decisión

Se añadirá una clave foránea desde seat_assignment.flight_segment_id hacia la tabla flight_segment.

Contexto y justificación

Se detectó que flight_segment_id podía contener valores sin validar su existencia en flight_segment, lo que abría la puerta a inconsistencias, como asignaciones de asientos vinculadas a vuelos inexistentes.

Alternativas consideradas
Validar únicamente desde el backend.
No aplicar ninguna restricción referencial.
Definir una FK directamente en la base de datos.
Consecuencias
Se fortalece la integridad referencial.
Se previenen registros inválidos.
Parte de la validación se traslada a la base de datos.
ADR 003 – Consistencia entre asiento y aeronave

Título: Validación entre el asiento asignado y el avión del vuelo

Decisión

Se implementará una validación que garantice que el asiento asignado pertenece a la misma aeronave del segmento de vuelo. Esta lógica podrá implementarse mediante triggers en la base de datos o en el backend.

Contexto y justificación

Aunque los asientos y los segmentos de vuelo existen de forma independiente, es necesario asegurar que ambos correspondan al mismo avión. Sin esta verificación, podrían generarse inconsistencias críticas en la operación.

Alternativas consideradas
No aplicar validación adicional.
Validar solo desde el backend.
Implementar validación en la base de datos (trigger/regla).
Consecuencias
Mejora la consistencia del modelo.
Evita asignaciones inválidas.
Incrementa ligeramente la complejidad técnica.
Requiere definir claramente dónde se ejecutará la validación.
ADR 004 – Unicidad en campos opcionales

Título: Uso de índices únicos parciales para valores NULL

Decisión

Se reemplazarán ciertas restricciones UNIQUE por índices únicos parciales que solo apliquen cuando el valor no sea NULL.

Ejemplo:

CREATE UNIQUE INDEX idx_unique_optional_field
ON table_name(optional_field)
WHERE optional_field IS NOT NULL;
Contexto y justificación

En PostgreSQL, los valores NULL no se consideran iguales entre sí, por lo que una restricción UNIQUE permite múltiples NULL. Esto puede ser deseable en algunos casos, pero en otros puede generar comportamientos no esperados si se busca unicidad únicamente cuando hay un valor presente.

Alternativas consideradas
Mantener las restricciones UNIQUE.
Convertir los campos a NOT NULL.
Usar índices únicos condicionales.
Consecuencias
Mayor control sobre la unicidad de los datos.
Se conserva la flexibilidad de campos opcionales.
Mejora la calidad de la información almacenada.
El comportamiento del modelo queda más explícito.
ADR 005 – Mejora en almacenamiento de contraseñas

Título: Ajuste del tipo y validación de password_hash

Decisión

La columna password_hash se cambiará a tipo TEXT y se agregará una validación de longitud mínima.

Contexto y justificación

El uso de varchar(255) puede ser restrictivo para ciertos algoritmos de hashing. Además, no existía una validación mínima que garantizara que el valor almacenado tuviera una estructura válida.

Alternativas consideradas
Mantener varchar(255).
Validar solo desde el backend.
Usar TEXT con validaciones en base de datos.
Consecuencias
Mayor flexibilidad para distintos algoritmos de hash.
Mejora en la seguridad del modelo.
Menor dependencia del backend para validaciones básicas.
Preparación para cambios futuros en la estrategia de seguridad.
ADR 006 – Normalización de valores categóricos

Título: Uso de tablas catálogo en lugar de CHECK

Decisión

Se reemplazarán restricciones CHECK por tablas catálogo para manejar valores categóricos como transaction_type.

Contexto y justificación

Las restricciones CHECK son útiles para reglas simples, pero resultan limitadas cuando los valores deben crecer, reutilizarse o gestionarse dinámicamente. Las tablas catálogo permiten centralizar estos valores y relacionarlos mediante claves foráneas.

Alternativas consideradas
Mantener CHECK.
Usar tipos ENUM de PostgreSQL.
Implementar tablas catálogo.
Consecuencias
Mayor flexibilidad y escalabilidad.
Reutilización de valores en distintas partes del modelo.
Mantenimiento más sencillo ante cambios.
Incremento en el número de tablas, pero con mejor normalización.
ADR 007 – Automatización de updated_at

Título: Actualización automática del campo de modificación

Decisión

Se crearán triggers para actualizar automáticamente el campo updated_at en cada operación de tipo UPDATE.

Contexto y justificación

Depender del backend para actualizar este campo puede provocar inconsistencias y afectar la trazabilidad. Automatizar este proceso asegura que siempre refleje el último cambio real.

Alternativas consideradas
Actualización manual desde el backend.
No utilizar el campo.
Automatizar mediante triggers.
Consecuencias
Mejora la trazabilidad de los datos.
Reduce errores humanos.
Hace más confiable la auditoría básica.
Introduce un pequeño costo adicional en operaciones de actualización.
Resumen

Las decisiones documentadas apuntan a:

simplificar relaciones innecesarias;
reforzar la integridad referencial;
evitar inconsistencias entre entidades clave;
mejorar el manejo de unicidad en campos opcionales;
optimizar el almacenamiento de contraseñas;
normalizar valores categóricos;
automatizar la trazabilidad de cambios.

En conjunto, estos ajustes fortalecen la consistencia del modelo, facilitan su mantenimiento y lo preparan mejor para futuras evoluciones.
