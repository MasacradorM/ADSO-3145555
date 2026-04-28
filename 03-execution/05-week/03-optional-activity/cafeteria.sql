-- Crear base de datos
CREATE DATABASE cafeteria;
USE cafeteria;

-- 1. Clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    correo VARCHAR(100),
    telefono VARCHAR(20)
);

INSERT INTO clientes (nombre, correo, telefono)
VALUES ('Juan Perez', 'juan@mail.com', '3001234567');

-- 2. Empleados
CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    cargo VARCHAR(50),
    salario DECIMAL(10,2)
);

INSERT INTO empleados (nombre, cargo, salario)
VALUES ('Maria Lopez', 'Barista', 1500000);

-- 3. Categorías
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

INSERT INTO categorias (nombre)
VALUES ('Bebidas calientes');

-- 4. Productos
CREATE TABLE productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    precio DECIMAL(10,2),
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

INSERT INTO productos (nombre, precio, id_categoria)
VALUES ('Café Americano', 5000, 1);

-- 5. Proveedores
CREATE TABLE proveedores (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    telefono VARCHAR(20)
);

INSERT INTO proveedores (nombre, telefono)
VALUES ('Proveedor Café S.A', '3100000000');

-- 6. Inventario
CREATE TABLE inventario (
    id_inventario INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    stock INT,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

INSERT INTO inventario (id_producto, stock)
VALUES (1, 100);

-- 7. Métodos de pago
CREATE TABLE metodos_pago (
    id_metodo INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50)
);

INSERT INTO metodos_pago (tipo)
VALUES ('Efectivo');

-- 8. Pedidos
CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_empleado INT,
    fecha DATETIME,
    id_metodo INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    FOREIGN KEY (id_metodo) REFERENCES metodos_pago(id_metodo)
);

INSERT INTO pedidos (id_cliente, id_empleado, fecha, id_metodo)
VALUES (1, 1, NOW(), 1);

-- 9. Detalle del pedido
CREATE TABLE detalle_pedido (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario)
VALUES (1, 1, 2, 5000);

-- 10. Compras
CREATE TABLE compras (
    id_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_proveedor INT,
    fecha DATETIME,
    total DECIMAL(10,2),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

INSERT INTO compras (id_proveedor, fecha, total)
VALUES (1, NOW(), 200000);

-- 11. Detalle compra
CREATE TABLE detalle_compra (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_compra INT,
    id_producto INT,
    cantidad INT,
    costo DECIMAL(10,2),
    FOREIGN KEY (id_compra) REFERENCES compras(id_compra),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

INSERT INTO detalle_compra (id_compra, id_producto, cantidad, costo)
VALUES (1, 1, 50, 3000);
