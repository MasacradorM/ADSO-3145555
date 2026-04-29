-- ============================================================
--  FUNCIÓN: fn_resumen_pedido(p_pedido_id INT)
--  Base de datos: cafetin_sena | Motor: PostgreSQL
--  Descripción:
--    Recibe el ID de un pedido y retorna una tabla con el
--    detalle completo: datos del cliente, cada producto
--    solicitado, subtotales y el total general del pedido.
--  Retorna: TABLE (conjunto de filas)
--  Uso:     SELECT * FROM fn_resumen_pedido(3);
-- ============================================================

CREATE OR REPLACE FUNCTION fn_resumen_pedido(p_pedido_id INT)
RETURNS TABLE (
    pedido_id       INT,
    fecha_pedido    TIMESTAMP,
    estado          estado_pedido,
    pago_recibido   BOOLEAN,
    cliente         TEXT,
    correo          TEXT,
    producto        VARCHAR(120),
    categoria       VARCHAR(80),
    cantidad        SMALLINT,
    precio_unitario NUMERIC(10,2),
    subtotal        NUMERIC(10,2),
    total_pedido    NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar que el pedido exista
    IF NOT EXISTS (SELECT 1 FROM pedidos WHERE id = p_pedido_id) THEN
        RAISE EXCEPTION 'El pedido con ID % no existe.', p_pedido_id;
    END IF;

    RETURN QUERY
    SELECT
        pe.id                               AS pedido_id,
        pe.fecha_pedido,
        pe.estado,
        pe.pago_recibido,
        (u.nombre || ' ' || u.apellido)     AS cliente,
        u.correo,
        pr.nombre                           AS producto,
        c.nombre                            AS categoria,
        dp.cantidad,
        dp.precio_unitario,
        dp.subtotal,
        pe.total                            AS total_pedido
    FROM pedidos pe
    JOIN usuarios        u  ON u.id  = pe.usuario_id
    JOIN detalle_pedido  dp ON dp.pedido_id  = pe.id
    JOIN productos       pr ON pr.id = dp.producto_id
    JOIN categorias      c  ON c.id  = pr.categoria_id
    WHERE pe.id = p_pedido_id
    ORDER BY pr.nombre;
END;
$$;

-- ============================================================
--  EJEMPLO DE USO
-- ============================================================
-- SELECT * FROM fn_resumen_pedido(1);
