-- ============================================================
--  VISTA: v_dashboard_productos
--  Base de datos: cafetin_sena | Motor: PostgreSQL
--  Descripción:
--    Vista ejecutiva del catálogo de productos activos.
--    Consolida por cada producto: su categoría, precio,
--    stock actual, unidades vendidas en total, ingresos
--    generados y una etiqueta de alerta de inventario.
--    Útil para el panel de administración del cafetín.
--  Uso: SELECT * FROM v_dashboard_productos;
--       SELECT * FROM v_dashboard_productos WHERE alerta_stock = 'CRÍTICO';
-- ============================================================

CREATE OR REPLACE VIEW v_dashboard_productos AS
SELECT
    p.id                                        AS producto_id,
    p.nombre                                    AS producto,
    c.nombre                                    AS categoria,
    p.precio,
    p.stock                                     AS stock_actual,

    -- Total de unidades vendidas (de pedidos no cancelados)
    COALESCE(SUM(dp.cantidad), 0)               AS unidades_vendidas,

    -- Ingresos generados por este producto
    COALESCE(SUM(dp.subtotal), 0)               AS ingresos_generados,

    -- Etiqueta de alerta según nivel de stock
    CASE
        WHEN p.stock = 0        THEN 'AGOTADO'
        WHEN p.stock <= 5       THEN 'CRÍTICO'
        WHEN p.stock <= 15      THEN 'BAJO'
        ELSE                         'OK'
    END                                         AS alerta_stock,

    p.creado_en                                 AS creado_en,
    p.actualizado_en                            AS actualizado_en

FROM productos p
JOIN categorias c
    ON c.id = p.categoria_id
LEFT JOIN detalle_pedido dp
    ON dp.producto_id = p.id
LEFT JOIN pedidos pe
    ON pe.id = dp.pedido_id
   AND pe.estado <> 'cancelado'   -- excluir pedidos cancelados
WHERE
    p.activo  = TRUE
    AND c.activo = TRUE
GROUP BY
    p.id,
    p.nombre,
    c.nombre,
    p.precio,
    p.stock,
    p.creado_en,
    p.actualizado_en
ORDER BY
    alerta_stock ASC,       -- primero los críticos / agotados
    ingresos_generados DESC;

-- ============================================================
--  EJEMPLOS DE USO
-- ============================================================
-- Ver todos los productos del dashboard:
--   SELECT * FROM v_dashboard_productos;
--
-- Ver solo los productos con stock crítico o agotado:
--   SELECT * FROM v_dashboard_productos
--   WHERE alerta_stock IN ('CRÍTICO', 'AGOTADO');
--
-- Ver productos más rentables:
--   SELECT producto, categoria, ingresos_generados
--   FROM v_dashboard_productos
--   ORDER BY ingresos_generados DESC
--   LIMIT 5;
