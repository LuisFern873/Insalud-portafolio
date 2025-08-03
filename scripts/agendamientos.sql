-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Jesús María %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SELECT 
	AG.id_agendamiento, 
    'Individual' AS tipo,
    1 AS sede_id, 
    AG.especialidad_id,
    PRO.nombre AS procedimiento_nombre,
    DATE(AG.created_at) AS fecha_agendamiento,
    DATE(AG.start) AS fecha_atencion,
    AG.numero_documento AS paciente_numero_documento,
    UPPER(CONCAT(PER.nombres, ' ', PER.apellido_paterno, ' ', PER.apellido_materno)) AS paciente_nombre,
    -- Verificamos si el paciente es nuevo o continuador
    CASE 
		WHEN DATE(AG.created_at) = DATE(PER.created_at) THEN 'Nuevo'
        ELSE 'Continuador'
    END AS paciente_tipo,
    UPPER(CONCAT(PE.nombres, ' ', PE.apellido_paterno, ' ', PE.apellido_materno)) AS gestor_nombre,
    PA.id_proceso_asistencial AS id_atencion
FROM sistema_insalud.agendamiento AG
-- Recuperamos el nombre del gestor
LEFT JOIN sistema_insalud.trabajadores TR
	ON AG.trabajador_id = TR.id_trabajador
LEFT JOIN sistema_insalud.persona PE
	ON TR.persona_id = PE.id_persona
-- Recuperamos datos del paciente (usamos created_at para verificar si el paciente es nuevo o continuador)
LEFT JOIN sistema_insalud.persona PER
	ON AG.numero_documento = PER.numero_documento
-- Recuperamos el nombre del procedimiento
LEFT JOIN sistema_insalud_centralizado.procedimientos PRO
	ON AG.uuid_global_procedimiento = PRO.uuid_procedimiento
-- Verificamos si el agendamiento tiene asociado una atención (un valor null significa que no tiene)
LEFT JOIN sistema_insalud.proceso_asistencial PA
	ON AG.id_agendamiento = PA.agendamiento_id
WHERE TR.rol_id = 13 -- Solo gestores

UNION ALL

SELECT 
	AGP.id_agendamiento_paquete, 
    'Paquete' AS tipo,
    1 AS sede_id, 
    AGP.especialidad_id,
	PAQ.nombre AS procedimiento_nombre,
    DATE(AGP.created_at) AS fecha_agendamiento,
    DATE(AGP.start) AS fecha_atencion,
    AGP.numero_documento AS paciente_numero_documento,
    UPPER(CONCAT(PER.nombres, ' ', PER.apellido_paterno, ' ', PER.apellido_materno)) AS paciente_nombre,
    -- Verificamos si el paciente es nuevo o continuador
    CASE 
		WHEN DATE(AGP.created_at) = DATE(PER.created_at) THEN 'Nuevo'
        ELSE 'Continuador'
    END AS paciente_tipo,
    UPPER(CONCAT(PE.nombres, ' ', PE.apellido_paterno, ' ', PE.apellido_materno)) AS gestor_nombre,
    PA.id_paquete_adquirido AS id_atencion
FROM sistema_insalud.agendamiento_paquete AGP
-- Recuperamos el nombre del gestor
LEFT JOIN sistema_insalud.trabajadores TR
	ON AGP.trabajador_id = TR.id_trabajador
LEFT JOIN sistema_insalud.persona PE
	ON TR.persona_id = PE.id_persona
-- Recuperamos datos del paciente (usamos created_at para verificar si el paciente es nuevo o continuador)
LEFT JOIN sistema_insalud.persona PER
	ON AGP.numero_documento = PER.numero_documento
-- Recuperamos el nombre del procedimiento
LEFT JOIN sistema_insalud.paquetes PAQ
	ON AGP.paquete_id = PAQ.id_paquete
-- Para verificar si el agendamiento tiene un paquete adquirido asociado
LEFT JOIN sistema_insalud.paquetes_adquiridos PA
	ON AGP.id_agendamiento_paquete = PA.agendamiento_paquete_id
WHERE TR.rol_id = 13 -- Solo gestores

UNION ALL
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Golf %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SELECT 
	AG.id_agendamiento, 
    'Individual' AS tipo,
    5 AS sede_id, 
    AG.especialidad_id,
    PRO.nombre AS procedimiento_nombre,
    DATE(AG.created_at) AS fecha_agendamiento,
    DATE(AG.start) AS fecha_atencion,
    AG.numero_documento AS paciente_numero_documento,
    UPPER(CONCAT(PER.nombres, ' ', PER.apellido_paterno, ' ', PER.apellido_materno)) AS paciente_nombre,
    CASE 
		WHEN DATE(AG.created_at) = DATE(PER.created_at) THEN 'Nuevo'
        ELSE 'Continuador'
    END AS paciente_tipo,
    UPPER(CONCAT(PE.nombres, ' ', PE.apellido_paterno, ' ', PE.apellido_materno)) AS gestor_nombre,
    PA.id_proceso_asistencial AS id_atencion
FROM sistema_insalud_golf.agendamiento AG
LEFT JOIN sistema_insalud_golf.trabajadores TR
	ON AG.trabajador_id = TR.id_trabajador
LEFT JOIN sistema_insalud_golf.persona PE
	ON TR.persona_id = PE.id_persona
LEFT JOIN sistema_insalud_golf.persona PER
	ON AG.numero_documento = PER.numero_documento
LEFT JOIN sistema_insalud_centralizado.procedimientos PRO
	ON AG.uuid_global_procedimiento = PRO.uuid_procedimiento
LEFT JOIN sistema_insalud_golf.proceso_asistencial PA
	ON AG.id_agendamiento = PA.agendamiento_id
WHERE TR.rol_id = 13

UNION ALL

SELECT 
	AGP.id_agendamiento_paquete, 
    'Paquete' AS tipo,
    5 AS sede_id, 
    AGP.especialidad_id,
	PAQ.nombre AS procedimiento_nombre,
    DATE(AGP.created_at) AS fecha_agendamiento,
    DATE(AGP.start) AS fecha_atencion,
    AGP.numero_documento AS paciente_numero_documento,
    UPPER(CONCAT(PER.nombres, ' ', PER.apellido_paterno, ' ', PER.apellido_materno)) AS paciente_nombre,
    CASE 
		WHEN DATE(AGP.created_at) = DATE(PER.created_at) THEN 'Nuevo'
        ELSE 'Continuador'
    END AS paciente_tipo,
    UPPER(CONCAT(PE.nombres, ' ', PE.apellido_paterno, ' ', PE.apellido_materno)) AS gestor_nombre,
    PA.id_paquete_adquirido AS id_atencion
FROM sistema_insalud_golf.agendamiento_paquete AGP
LEFT JOIN sistema_insalud_golf.trabajadores TR
	ON AGP.trabajador_id = TR.id_trabajador
LEFT JOIN sistema_insalud_golf.persona PE
	ON TR.persona_id = PE.id_persona
LEFT JOIN sistema_insalud_golf.persona PER
	ON AGP.numero_documento = PER.numero_documento
LEFT JOIN sistema_insalud_golf.paquetes PAQ
	ON AGP.paquete_id = PAQ.id_paquete
LEFT JOIN sistema_insalud_golf.paquetes_adquiridos PA
	ON AGP.id_agendamiento_paquete = PA.agendamiento_paquete_id
WHERE TR.rol_id = 13

UNION ALL
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sur %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SELECT 
	AG.id_agendamiento, 
    'Individual' AS tipo,
    2 AS sede_id, 
    AG.especialidad_id,
    PRO.nombre AS procedimiento_nombre,
    DATE(AG.created_at) AS fecha_agendamiento,
    DATE(AG.start) AS fecha_atencion,
    AG.numero_documento AS paciente_numero_documento,
    UPPER(CONCAT(PER.nombres, ' ', PER.apellido_paterno, ' ', PER.apellido_materno)) AS paciente_nombre,
    CASE 
		WHEN DATE(AG.created_at) = DATE(PER.created_at) THEN 'Nuevo'
        ELSE 'Continuador'
    END AS paciente_tipo,
    UPPER(CONCAT(PE.nombres, ' ', PE.apellido_paterno, ' ', PE.apellido_materno)) AS gestor_nombre,
    PA.id_proceso_asistencial AS id_atencion
FROM sistema_insalud_sur.agendamiento AG
LEFT JOIN sistema_insalud_sur.trabajadores TR
	ON AG.trabajador_id = TR.id_trabajador
LEFT JOIN sistema_insalud_sur.persona PE
	ON TR.persona_id = PE.id_persona
LEFT JOIN sistema_insalud_sur.persona PER
	ON AG.numero_documento = PER.numero_documento
LEFT JOIN sistema_insalud_centralizado.procedimientos PRO
	ON AG.uuid_global_procedimiento = PRO.uuid_procedimiento
LEFT JOIN sistema_insalud_sur.proceso_asistencial PA
	ON AG.id_agendamiento = PA.agendamiento_id
WHERE TR.rol_id = 13

UNION ALL

SELECT 
	AGP.id_agendamiento_paquete, 
    'Paquete' AS tipo,
    2 AS sede_id, 
    AGP.especialidad_id,
	PAQ.nombre AS procedimiento_nombre,
    DATE(AGP.created_at) AS fecha_agendamiento,
    DATE(AGP.start) AS fecha_atencion,
    AGP.numero_documento AS paciente_numero_documento,
    UPPER(CONCAT(PER.nombres, ' ', PER.apellido_paterno, ' ', PER.apellido_materno)) AS paciente_nombre,
    CASE 
		WHEN DATE(AGP.created_at) = DATE(PER.created_at) THEN 'Nuevo'
        ELSE 'Continuador'
    END AS paciente_tipo,
    UPPER(CONCAT(PE.nombres, ' ', PE.apellido_paterno, ' ', PE.apellido_materno)) AS gestor_nombre,
    PA.id_paquete_adquirido AS id_atencion
FROM sistema_insalud_sur.agendamiento_paquete AGP
LEFT JOIN sistema_insalud_sur.trabajadores TR
	ON AGP.trabajador_id = TR.id_trabajador
LEFT JOIN sistema_insalud_sur.persona PE
	ON TR.persona_id = PE.id_persona
LEFT JOIN sistema_insalud_sur.persona PER
	ON AGP.numero_documento = PER.numero_documento
LEFT JOIN sistema_insalud_sur.paquetes PAQ
	ON AGP.paquete_id = PAQ.id_paquete
LEFT JOIN sistema_insalud_sur.paquetes_adquiridos PA
	ON AGP.id_agendamiento_paquete = PA.agendamiento_paquete_id
WHERE TR.rol_id = 13