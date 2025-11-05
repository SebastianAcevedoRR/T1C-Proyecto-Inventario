CREATE database farmaciaacevedo;
USE farmaciaacevedo;

-- 1.1 Tabla de sucursales
CREATE TABLE sucursales (
    id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
    sucursal ENUM ('NORTE', 'CENTRO','SUR') NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(20)
);

-- Insertamos sucursales
INSERT INTO sucursales (sucursal, direccion, telefono) VALUES 
('NORTE', 'Av. Pedro Aguirre Cerda 8251, Antofagasta', 962797420),
('CENTRO', '14 de Febrero 2001, Antofagasta', 962797420 ),
('SUR', 'AV. Angamos 0222, Antofagasta', '962797420');


-- 1.2 Tabla de rol
CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol ENUM ('Administrador', 'Bodeguero','Quimico farmaceutico') NOT NULL,
    descripcion TEXT
);

-- Insertamos rol
INSERT INTO rol (nombre_rol, description) VALUES
('Administrador', 'Acceso total al sistema, configuración y gestión de usuarios'),
('Bodeguero', 'Encargado de gestionar el inventario y movimientos de producto'),
('Quimico farmaceutico y auxiliares', 'Responsable de validar productos y supervisar stock');

-- 1.3 Tabla de usuarios
CREATE TABLE actor (
    id_actor INT AUTO_INCREMENT PRIMARY KEY,
    rut VARCHAR(20) NOT NULL UNIQUE, -- Formato: 12345678-9
    nombre_completo VARCHAR(100) NOT NULL, -- Formato: Nombre y apellido
    correo VARCHAR(100) NOT NULL UNIQUE,
    rol_id INT NOT NULL,
    sucursal_id INT NOT NULL,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    contraseña VARCHAR(255) NOT NULL, -- Se almacenará como hash
    FOREIGN KEY (rol_id) REFERENCES rol(id_rol),
    FOREIGN KEY (sucursal_id) REFERENCES rol (id_sucursal)
);
-- Insertamos actores (los usuarios del sistema)
INSERT INTO actor (rut, nombre_completo, correo, rol_id, id_sucursal, usuario, contraseña) VALUES
('12345678-9', 'Sebastian Acevedo', 'sebastian@farmacia.cl', 1, 1, 'sebaacevedo', 'panconqueso123'),
('98765432-1', 'Gabriel Lyon', 'lyon@farmacia.cl', 2, 2, 'gabriellyon', 'mastermind123'),
('11223344-5','Valentina Araya', 'donomar@farmacia.cl', 3, 3, 'Valearaya', 'omarpresidente123');



-- 1.4 Tabla de proveedores (Registra los datos de cada proveedor. Relacionado con productos.)
CREATE TABLE proveedor (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    rut_proveedor VARCHAR(12) UNIQUE NOT NULL, -- Ej: 12345678-9
    telefono VARCHAR(20),
    correo VARCHAR(100),
    direccion VARCHAR(255)
);
-- Insertamos proveedores
INSERT INTO proveedor (nombre, rut_proveedor, telefono, correo, direccion) VALUES
('Laboratorios Chile', '76543210-5', '225678900', 'contacto@labchile.cl', 'Av. Providencia 123, Santiago');



-- 1.5 Tabla de categorías (Clasifica los productos por tipo terapéutico)
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria ENUM ('Analgésicos y antiinflamatorios', 'Antibióticos y antivirales','Antihipertensivos y cardiovasculares', 'Antidiabéticos y endocrinos', 'Gastrointestinales','Salud mental (ansiolíticos, antidepresivos)	', 'Dermatológicos y tópicos','Pediátricos', 'Respiratorios') NOT NULL,
    descripcion TEXT
);
-- Insertamos categorias
INSERT INTO categoria (nombre_categoria, descripcion) VALUES
('Antibióticos y antivirales', 'Medicamentos para tratar infecciones bacterianas y virales.');


-- 1.6 Tabla de productos  (Medicamento gestionado. Tiene relación con proveedor y categoría)
CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    codigo_producto VARCHAR(50) UNIQUE NOT NULL, -- SKU o código interno
    nombre VARCHAR(100) NOT NULL,
    formato VARCHAR (50) NOT NULL,
    dosis VARCHAR (50) NOT NULL,
    categoria_id INT NOT NULL,
    proveedor_id INT NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categoria(id_categoria),
    FOREIGN KEY (proveedor_id) REFERENCES proveedor(id_proveedor)
);
-- Insertamos productos
INSERT INTO producto (codigo_producto, nombre, formato, dosis, categoria_id, proveedor_id) VALUES
('ABX-100', 'Amoxicilina 500mg', 'Cápsulas', '500mg', 1, 1);



-- 1.7 Tabla de lotes (Permite controlar stock, precios y vencimiento por lote de producto.)

CREATE TABLE lote (
    id_lote INT AUTO_INCREMENT PRIMARY KEY,
    precio_compra DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_actual INT DEFAULT 0,
    stock_minimo INT DEFAULT 0,
    fecha_vencimiento DATE NOT NULL,
    id_producto INT NOT NULL,
    id_sucursal INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

-- insertamos lotes
INSERT INTO lote (precio_compra, precio_venta, stock_actual, stock_minimo, fecha_vencimiento, id_producto, id_sucursal) VALUES
(1200, 1800, 50, 10, '2026-06-30', 1, 1);






-- 1.8 Tabla de documentos vinculados a movimientos
-- Esta tabla almacena los documentos vinculados a movimientos de inventario, como boletas, notas de crédito,
-- devoluciones o guías de traslado. Permite mantener trazabilidad documental de cada operación registrada.
-- Cada documento puede estar asociado a un único movimiento de inventario.
CREATE TABLE documento (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,
    tipo_documento ENUM('boleta', 'nota_credito', 'devolucion', 'traslado', 'ajuste_manual') NOT NULL,
    numero_referencia VARCHAR(100) NOT NULL, -- Ej: número de boleta o código interno
    fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    observacion TEXT
);

-- insertamos un documento
INSERT INTO documento (tipo_documento, numero_referencia, observacion) VALUES
('boleta', 'BOL-20251102-001', 'Venta realizada en sucursal NORTE');



-- 1.9 Tabla de movimientos de inventario
-- Registra cada operación que afecta el inventario: entradas, salidas, ajustes, devoluciones o transferencias.
-- Cada movimiento está vinculado a un lote específico, a un producto (para facilitar consultas), y al actor que lo ejecutó.
-- Incluye campos para trazabilidad como stock antes/después, motivo, estado del movimiento y documento vinculado.
-- Esta tabla es clave para el control de inventario, auditoría y generación de reportes.

CREATE TABLE movimiento_inventario (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_lote INT NOT NULL,
    id_producto INT NOT NULL,
    tipo_movimiento ENUM('entrada', 'salida', 'ajuste', 'devolucion', 'transferencia') NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    fecha_movimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    actor_id INT NOT NULL,
    motivo VARCHAR(255),
    documento_id INT, -- FK hacia documento
    stock_previo DECIMAL(10,2),
    stock_posterior DECIMAL(10,2),
    estado ENUM('confirmado', 'pendiente', 'anulado') DEFAULT 'confirmado',
    FOREIGN KEY (id_lote) REFERENCES lote(id_lote),
    FOREIGN KEY (actor_id) REFERENCES actor(id_actor),
    FOREIGN KEY (documento_id) REFERENCES documento(id_documento)
);

-- insertamos tabla auditoria
INSERT INTO movimiento_inventario (id_lote, id_producto, tipo_movimiento, cantidad, actor_id, motivo, documento_id, stock_previo, stock_posterior, estado) VALUES
(1, 1, 'salida', 5, 2, 'Venta directa al cliente', 1, 50, 45, 'confirmado');


-- 2.0 Tabla AUDITORIA
-- Registra todas las acciones relevantes realizadas por los actores del sistema, incluyendo operaciones CRUD,
-- logins, movimientos de inventario y otras acciones críticas. Permite trazabilidad completa de cambios y accesos.
-- Cada registro se asocia a un actor y a una entidad afectada, con los valores antes y después del cambio.

CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    actor_id INT NOT NULL,
    entidad_afectada VARCHAR(100) NOT NULL, -- Ej: 'producto', 'movimiento_inventario'
    id_registro_afectado INT NOT NULL,
    accion ENUM('CREAR', 'MODIFICAR', 'ELIMINAR', 'LOGIN', 'MOVIMIENTO') NOT NULL,
    fecha_accion DATETIME DEFAULT CURRENT_TIMESTAMP,
    ip_equipo VARCHAR(45),
    FOREIGN KEY (actor_id) REFERENCES actor(id_actor)
);

-- insertamos una auditoria
INSERT INTO auditoria (actor_id, entidad_afectada, id_registro_afectado, accion, ip_equipo) VALUES
(2, 'movimiento_inventario', 1, 'CREAR', '192.168.1.10');



-- 2.1 Tabla REPORTE
-- Representa una consulta generada por un actor del sistema, ya sea para auditoría, estadísticas o gestión de inventario.
-- Permite registrar el tipo de reporte, los parámetros utilizados y el formato de salida. Facilita el seguimiento de uso del sistema.

CREATE TABLE reporte (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    tipo_reporte ENUM('inventario', 'ventas', 'auditoria', 'trazabilidad') NOT NULL,
    parametros_utilizados TEXT,
    fecha_generacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    auditoria_id INT NOT NULL,
    formato_salida ENUM('PDF', 'Excel') NOT NULL,
    FOREIGN KEY (auditoria_id) REFERENCES auditoria(id_auditoria)
);

-- insertamos un reporte 
INSERT INTO reporte (tipo_reporte, parametros_utilizados, auditoria_id, formato_salida) VALUES
('inventario', 'Sucursal=NORTE; Fecha=2025-11-02', 1, 'PDF');






