-- ============================================================
--  BASE DE DATOS: Sistema de Gestión de Pedidos - Cafetín SENA
--  Motor: PostgreSQL
--  Módulos: Usuario | Catálogo | Pedidos | Auditoría
-- ============================================================

CREATE DATABASE cafetin_sena ENCODING 'UTF8';

\c cafetin_sena;

-- ============================================================
-- ██╗   ██╗███████╗██╗   ██╗ █████╗ ██████╗ ██╗ ██████╗
-- ██║   ██║██╔════╝██║   ██║██╔══██╗██╔══██╗██║██╔═══██╗
-- ██║   ██║███████╗██║   ██║███████║██████╔╝██║██║   ██║
-- ██║   ██║╚════██║██║   ██║██╔══██║██╔══██╗██║██║   ██║
-- ╚██████╔╝███████║╚██████╔╝██║  ██║██║  ██║██║╚██████╔╝
--  ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝
--  MÓDULO 1: USUARIO
--  Tablas: roles, usuarios, sesiones, permisos
-- ============================================================

CREATE TYPE rol_usuario AS ENUM ('aprendiz', 'personal', 'admin');

CREATE TABLE roles (
    id          SERIAL          PRIMARY KEY,
    nombre      rol_usuario     NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo      BOOLEAN         NOT NULL DEFAULT TRUE,
    creado_en   TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE usuarios (
    id              SERIAL          PRIMARY KEY,
    rol_id          INT             NOT NULL REFERENCES roles (id),
    nombre          VARCHAR(100)    NOT NULL,
    apellido        VARCHAR(100)    NOT NULL,
    correo          VARCHAR(150)    NOT NULL UNIQUE,
    contrasena      VARCHAR(255)    NOT NULL,
    activo          BOOLEAN         NOT NULL DEFAULT TRUE,
    creado_en       TIMESTAMP       NOT NULL DEFAULT NOW(),
    actualizado_en  TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE sesiones (
    id              SERIAL          PRIMARY KEY,
    usuario_id      INT             NOT NULL REFERENCES usuarios (id) ON DELETE CASCADE,
    token           VARCHAR(500)    NOT NULL UNIQUE,
    ip              VARCHAR(45),
    activo          BOOLEAN         NOT NULL DEFAULT TRUE,
    creado_en       TIMESTAMP       NOT NULL DEFAULT NOW(),
    expira_en       TIMESTAMP       NOT NULL
);

CREATE TABLE permisos (
    id              SERIAL          PRIMARY KEY,
    rol_id          INT             NOT NULL REFERENCES roles (id),
    modulo          VARCHAR(80)     NOT NULL,
    puede_ver       BOOLEAN         NOT NULL DEFAULT FALSE,
    puede_crear     BOOLEAN         NOT NULL DEFAULT FALSE,
    puede_editar    BOOLEAN         NOT NULL DEFAULT FALSE,
    puede_eliminar  BOOLEAN         NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_usuarios_correo  ON usuarios (correo);
CREATE INDEX idx_usuarios_rol     ON usuarios (rol_id);
CREATE INDEX idx_sesiones_token   ON sesiones (token);
CREATE INDEX idx_sesiones_usuario ON sesiones (usuario_id);

INSERT INTO roles (nombre, descripcion) VALUES
    ('aprendiz', 'Aprendiz SENA con acceso básico'),
    ('personal',  'Personal del cafetín'),
    ('admin',     'Administrador del sistema');

INSERT INTO permisos (rol_id, modulo, puede_ver, puede_crear, puede_editar, puede_eliminar) VALUES
    (1, 'catalogo', TRUE,  FALSE, FALSE, FALSE),
    (1, 'pedidos',  TRUE,  TRUE,  FALSE, FALSE),
    (2, 'catalogo', TRUE,  TRUE,  TRUE,  FALSE),
    (2, 'pedidos',  TRUE,  TRUE,  TRUE,  FALSE),
    (3, 'catalogo', TRUE,  TRUE,  TRUE,  TRUE),
    (3, 'pedidos',  TRUE,  TRUE,  TRUE,  TRUE),
    (3, 'usuarios', TRUE,  TRUE,  TRUE,  TRUE);

-- ============================================================
--  ██████╗ █████╗ ████████╗ █████╗ ██╗      ██████╗  ██████╗
-- ██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██║     ██╔═══██╗██╔════╝
-- ██║     ███████║   ██║   ███████║██║     ██║   ██║██║  ███╗
-- ██║     ██╔══██║   ██║   ██╔══██║██║     ██║   ██║██║   ██║
-- ╚██████╗██║  ██║   ██║   ██║  ██║███████╗╚██████╔╝╚██████╔╝
--  ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝
--  MÓDULO 2: CATÁLOGO
--  Tablas: categorias, productos, inventario_movimientos
--  Vistas: v_productos_activos, v_productos_sin_stock
-- ============================================================

CREATE TABLE categorias (
    id              SERIAL          PRIMARY KEY,
    nombre          VARCHAR(80)     NOT NULL UNIQUE,
    descripcion     VARCHAR(255),
    activo          BOOLEAN         NOT NULL DEFAULT TRUE,
    creado_en       TIMESTAMP       NOT NULL DEFAULT NOW(),
    actualizado_en  TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE productos (
    id              SERIAL          PRIMARY KEY,
    categoria_id    INT             NOT NULL REFERENCES categorias (id),
    nombre          VARCHAR(120)    NOT NULL,
    descripcion     VARCHAR(300),
    precio          NUMERIC(10, 2)  NOT NULL CHECK (precio >= 0),
    imagen_url      VARCHAR(500),
    stock           INT             NOT NULL DEFAULT 0 CHECK (stock >= 0),
    activo          BOOLEAN         NOT NULL DEFAULT TRUE,
    creado_en       TIMESTAMP       NOT NULL DEFAULT NOW(),
    actualizado_en  TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE inventario_movimientos (
    id          SERIAL      PRIMARY KEY,
    producto_id INT         NOT NULL REFERENCES productos (id),
    usuario_id  INT         NOT NULL REFERENCES usuarios (id),
    tipo        VARCHAR(20) NOT NULL CHECK (tipo IN ('entrada', 'salida', 'ajuste')),
    cantidad    INT         NOT NULL,
    motivo      VARCHAR(255),
    creado_en   TIMESTAMP   NOT NULL DEFAULT NOW()
);

CREATE VIEW v_productos_activos AS
    SELECT
        p.id,
        p.nombre,
        p.descripcion,
        p.precio,
        p.imagen_url,
        p.stock,
        c.nombre AS categoria
    FROM productos p
    JOIN categorias c ON c.id = p.categoria_id
    WHERE p.activo = TRUE AND c.activo = TRUE;

CREATE VIEW v_productos_sin_stock AS
    SELECT
        p.id,
        p.nombre,
        c.nombre AS categoria,
        p.stock
    FROM productos p
    JOIN categorias c ON c.id = p.categoria_id
    WHERE p.stock = 0 AND p.activo = TRUE;

CREATE INDEX idx_productos_categoria ON productos (categoria_id);
CREATE INDEX idx_productos_activo    ON productos (activo);
CREATE INDEX idx_productos_stock     ON productos (stock);

INSERT INTO categorias (nombre, descripcion) VALUES
    ('Bebidas',   'Jugos, gaseosas y bebidas calientes'),
    ('Almuerzos', 'Platos del día y menú ejecutivo'),
    ('Snacks',    'Pasabocas y refrigerios'),
    ('Postres',   'Dulces y postres del día');

-- ============================================================
-- ██████╗ ███████╗██████╗ ██╗██████╗  ██████╗ ███████╗
-- ██╔══██╗██╔════╝██╔══██╗██║██╔══██╗██╔═══██╗██╔════╝
-- ██████╔╝█████╗  ██║  ██║██║██║  ██║██║   ██║███████╗
-- ██╔═══╝ ██╔══╝  ██║  ██║██║██║  ██║██║   ██║╚════██║
-- ██║     ███████╗██████╔╝██║██████╔╝╚██████╔╝███████║
-- ╚═╝     ╚══════╝╚═════╝ ╚═╝╚═════╝  ╚═════╝ ╚══════╝
--  MÓDULO 3: PEDIDOS
--  Tablas: pedidos, detalle_pedido, historial_estado_pedido
--  Vistas: v_pedidos_pendientes, v_resumen_pedidos_usuario
--  Triggers: trg_actualizar_total
-- ============================================================

CREATE TYPE estado_pedido AS ENUM (
    'pendiente',
    'recibido',
    'en_preparacion',
    'entregado',
    'cancelado'
);

CREATE TABLE pedidos (
    id              SERIAL          PRIMARY KEY,
    usuario_id      INT             NOT NULL REFERENCES usuarios (id),
    estado          estado_pedido   NOT NULL DEFAULT 'pendiente',
    total           NUMERIC(10, 2)  NOT NULL DEFAULT 0.00,
    pago_recibido   BOOLEAN         NOT NULL DEFAULT FALSE,
    notas           VARCHAR(500),
    fecha_pedido    TIMESTAMP       NOT NULL DEFAULT NOW(),
    fecha_entrega   TIMESTAMP,
    actualizado_en  TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE detalle_pedido (
    id              SERIAL          PRIMARY KEY,
    pedido_id       INT             NOT NULL REFERENCES pedidos (id) ON DELETE CASCADE,
    producto_id     INT             NOT NULL REFERENCES productos (id),
    cantidad        SMALLINT        NOT NULL DEFAULT 1 CHECK (cantidad > 0),
    precio_unitario NUMERIC(10, 2)  NOT NULL,
    subtotal        NUMERIC(10, 2)  GENERATED ALWAYS AS (cantidad * precio_unitario) STORED
);

CREATE TABLE historial_estado_pedido (
    id              SERIAL          PRIMARY KEY,
    pedido_id       INT             NOT NULL REFERENCES pedidos (id) ON DELETE CASCADE,
    usuario_id      INT             NOT NULL REFERENCES usuarios (id),
    estado_anterior estado_pedido,
    estado_nuevo    estado_pedido   NOT NULL,
    observacion     VARCHAR(300),
    cambiado_en     TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE VIEW v_pedidos_pendientes AS
    SELECT
        p.id,
        p.total,
        p.pago_recibido,
        p.notas,
        p.fecha_pedido,
        u.nombre || ' ' || u.apellido AS usuario,
        u.correo
    FROM pedidos p
    JOIN usuarios u ON u.id = p.usuario_id
    WHERE p.estado = 'pendiente'
    ORDER BY p.fecha_pedido ASC;

CREATE VIEW v_resumen_pedidos_usuario AS
    SELECT
        u.id                            AS usuario_id,
        u.nombre || ' ' || u.apellido   AS usuario,
        COUNT(p.id)                     AS total_pedidos,
        SUM(p.total)                    AS total_gastado,
        MAX(p.fecha_pedido)             AS ultimo_pedido
    FROM usuarios u
    LEFT JOIN pedidos p ON p.usuario_id = u.id
    GROUP BY u.id, u.nombre, u.apellido;

CREATE OR REPLACE FUNCTION fn_actualizar_total_pedido()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE pedidos
    SET total = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM detalle_pedido
        WHERE pedido_id = COALESCE(NEW.pedido_id, OLD.pedido_id)
    ),
    actualizado_en = NOW()
    WHERE id = COALESCE(NEW.pedido_id, OLD.pedido_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_total
AFTER INSERT OR UPDATE OR DELETE ON detalle_pedido
FOR EACH ROW EXECUTE FUNCTION fn_actualizar_total_pedido();

CREATE INDEX idx_pedidos_usuario ON pedidos (usuario_id);
CREATE INDEX idx_pedidos_estado  ON pedidos (estado);
CREATE INDEX idx_pedidos_fecha   ON pedidos (fecha_pedido);
CREATE INDEX idx_detalle_pedido  ON detalle_pedido (pedido_id);

-- ============================================================
-- ██████╗ ██╗   ██╗██████╗ ██╗████████╗ ██████╗ ██████╗ ██╗ █████╗
-- ██╔══██╗██║   ██║██╔══██╗██║╚══██╔══╝██╔═══██╗██╔══██╗██║██╔══██╗
-- ██████╔╝██║   ██║██║  ██║██║   ██║   ██║   ██║██████╔╝██║███████║
-- ██╔═══╝ ██║   ██║██║  ██║██║   ██║   ██║   ██║██╔══██╗██║██╔══██║
-- ██║     ╚██████╔╝██████╔╝██║   ██║   ╚██████╔╝██║  ██║██║██║  ██║
-- ╚═╝      ╚═════╝ ╚═════╝ ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝
--  MÓDULO 4: AUDITORÍA
--  Tablas: auditoria_log, errores_log, accesos_log
--  Vistas: v_auditoria_pedidos, v_accesos_recientes
--  Triggers: trg_auditoria_*
-- ============================================================

CREATE TABLE auditoria_log (
    id               SERIAL      PRIMARY KEY,
    usuario_id       INT         REFERENCES usuarios (id),
    tabla            VARCHAR(80) NOT NULL,
    operacion        VARCHAR(10) NOT NULL CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE')),
    registro_id      INT         NOT NULL,
    datos_anteriores JSONB,
    datos_nuevos     JSONB,
    ip               VARCHAR(45),
    creado_en        TIMESTAMP   NOT NULL DEFAULT NOW()
);

CREATE TABLE errores_log (
    id          SERIAL      PRIMARY KEY,
    usuario_id  INT         REFERENCES usuarios (id),
    modulo      VARCHAR(80) NOT NULL,
    mensaje     TEXT        NOT NULL,
    detalle     TEXT,
    ip          VARCHAR(45),
    creado_en   TIMESTAMP   NOT NULL DEFAULT NOW()
);

CREATE TABLE accesos_log (
    id          SERIAL      PRIMARY KEY,
    usuario_id  INT         NOT NULL REFERENCES usuarios (id),
    accion      VARCHAR(20) NOT NULL CHECK (accion IN ('login', 'logout', 'intento_fallido')),
    ip          VARCHAR(45),
    dispositivo VARCHAR(255),
    creado_en   TIMESTAMP   NOT NULL DEFAULT NOW()
);

CREATE VIEW v_auditoria_pedidos AS
    SELECT
        a.id,
        a.operacion,
        a.registro_id       AS pedido_id,
        a.datos_anteriores,
        a.datos_nuevos,
        a.ip,
        a.creado_en,
        u.nombre || ' ' || u.apellido AS usuario
    FROM auditoria_log a
    LEFT JOIN usuarios u ON u.id = a.usuario_id
    WHERE a.tabla = 'pedidos'
    ORDER BY a.creado_en DESC;

CREATE VIEW v_accesos_recientes AS
    SELECT
        al.id,
        al.accion,
        al.ip,
        al.dispositivo,
        al.creado_en,
        u.nombre || ' ' || u.apellido AS usuario,
        u.correo
    FROM accesos_log al
    JOIN usuarios u ON u.id = al.usuario_id
    ORDER BY al.creado_en DESC
    LIMIT 100;

CREATE OR REPLACE FUNCTION fn_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO auditoria_log (
        tabla,
        operacion,
        registro_id,
        datos_anteriores,
        datos_nuevos
    ) VALUES (
        TG_TABLE_NAME,
        TG_OP,
        COALESCE(NEW.id, OLD.id),
        CASE WHEN TG_OP = 'INSERT' THEN NULL ELSE to_jsonb(OLD) END,
        CASE WHEN TG_OP = 'DELETE' THEN NULL ELSE to_jsonb(NEW) END
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auditoria_usuarios
AFTER INSERT OR UPDATE OR DELETE ON usuarios
FOR EACH ROW EXECUTE FUNCTION fn_auditoria();

CREATE TRIGGER trg_auditoria_pedidos
AFTER INSERT OR UPDATE OR DELETE ON pedidos
FOR EACH ROW EXECUTE FUNCTION fn_auditoria();

CREATE TRIGGER trg_auditoria_productos
AFTER INSERT OR UPDATE OR DELETE ON productos
FOR EACH ROW EXECUTE FUNCTION fn_auditoria();

CREATE INDEX idx_auditoria_tabla   ON auditoria_log (tabla);
CREATE INDEX idx_auditoria_usuario ON auditoria_log (usuario_id);
CREATE INDEX idx_auditoria_fecha   ON auditoria_log (creado_en);
CREATE INDEX idx_accesos_usuario   ON accesos_log (usuario_id);
CREATE INDEX idx_accesos_fecha     ON accesos_log (creado_en);
CREATE INDEX idx_errores_modulo    ON errores_log (modulo);
