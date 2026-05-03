-- CAPOSNET POS placeholder
-- ============================================================
--  CAPOSNET POS - BASE DE DATOS COMPLETA v3 (18 MODULOS)
--  Crear desde cero: ejecutar completo en MySQL
-- ============================================================
DROP DATABASE IF EXISTS veteran;
CREATE DATABASE veteran CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE veteran;
SET FOREIGN_KEY_CHECKS = 0;

-- MODULO 18: TIENDAS Y CAJAS
CREATE TABLE tiendas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ruc VARCHAR(20), ruc1 VARCHAR(20) NOT NULL,
    ruc2 VARCHAR(20), ruc3 VARCHAR(20),
    direccion VARCHAR(200), ciudad VARCHAR(100),
    estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE cajas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tienda_id INT NOT NULL, nombre VARCHAR(50) NOT NULL,
    estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cajas_tienda FOREIGN KEY (tienda_id) REFERENCES tiendas(id)
) ENGINE=InnoDB;

-- MODULO 16: ROLES Y USUARIOS
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200), estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL, username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, email VARCHAR(100), telefono VARCHAR(20),
    rol_id INT NOT NULL, tienda_id INT NOT NULL, estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_usr_rol    FOREIGN KEY (rol_id)    REFERENCES roles(id),
    CONSTRAINT fk_usr_tienda FOREIGN KEY (tienda_id) REFERENCES tiendas(id)
) ENGINE=InnoDB;

-- MODULO 3: CATALOGOS
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(200), estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE subcategorias (
    id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200), categoria_id INT NOT NULL, estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_sub_cat FOREIGN KEY (categoria_id) REFERENCES categorias(id)
) ENGINE=InnoDB;

CREATE TABLE subsubcategorias (
    id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200), subcategoria_id INT NOT NULL, estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_subsub FOREIGN KEY (subcategoria_id) REFERENCES subcategorias(id)
) ENGINE=InnoDB;

CREATE TABLE marcas (
    id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL UNIQUE,
    estado TINYINT(1) NOT NULL DEFAULT 1, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE unidades (
    id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL,
    abreviatura VARCHAR(10) NOT NULL, estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- MODULO 3: PRODUCTOS
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_barras VARCHAR(50) NOT NULL UNIQUE, nombre VARCHAR(150) NOT NULL,
    descripcion TEXT, precio_compra DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    precio_venta DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    stock INT NOT NULL DEFAULT 0, stock_minimo INT NOT NULL DEFAULT 0,
    subsubcategoria_id INT NOT NULL, marca_id INT, unidad_id INT,
    estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_prod_ssc   FOREIGN KEY (subsubcategoria_id) REFERENCES subsubcategorias(id),
    CONSTRAINT fk_prod_marca FOREIGN KEY (marca_id)  REFERENCES marcas(id),
    CONSTRAINT fk_prod_uni   FOREIGN KEY (unidad_id) REFERENCES unidades(id)
) ENGINE=InnoDB;

-- MODULO 2: CLIENTES
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_documento VARCHAR(20) NOT NULL DEFAULT 'DNI',
    num_documento VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(150) NOT NULL, apellidos VARCHAR(100),
    direccion VARCHAR(200), telefono VARCHAR(20), email VARCHAR(100),
    estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- MODULO 1: VENTAS
CREATE TABLE series_comprobante (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_comprobante VARCHAR(30) NOT NULL UNIQUE, serie VARCHAR(10) NOT NULL,
    numero_actual INT NOT NULL DEFAULT 0, estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL, usuario_id INT NOT NULL,
    serie_comprobante_id INT NOT NULL, caja_id INT NOT NULL,
    numero_comprobante VARCHAR(20) NOT NULL,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    igv DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    metodo_pago VARCHAR(30) NOT NULL DEFAULT 'Efectivo',
    estado VARCHAR(20) NOT NULL DEFAULT 'Completada',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_vta_cli   FOREIGN KEY (cliente_id)           REFERENCES clientes(id),
    CONSTRAINT fk_vta_usr   FOREIGN KEY (usuario_id)           REFERENCES usuarios(id),
    CONSTRAINT fk_vta_serie FOREIGN KEY (serie_comprobante_id) REFERENCES series_comprobante(id),
    CONSTRAINT fk_vta_caja  FOREIGN KEY (caja_id)              REFERENCES cajas(id)
) ENGINE=InnoDB;

CREATE TABLE detalle_ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL, producto_id INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL, subtotal DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_dv_vta  FOREIGN KEY (venta_id)    REFERENCES ventas(id) ON DELETE CASCADE,
    CONSTRAINT fk_dv_prod FOREIGN KEY (producto_id) REFERENCES productos(id)
) ENGINE=InnoDB;

-- MODULO 6: COTIZACIONES
CREATE TABLE cotizaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL, usuario_id INT NOT NULL,
    numero VARCHAR(30) NOT NULL UNIQUE,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento TIMESTAMP NULL,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    igv DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    estado INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cot_cli FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    CONSTRAINT fk_cot_usr FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
) ENGINE=InnoDB;

CREATE TABLE detalle_cotizaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cotizacion_id INT NOT NULL, producto_id INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL, subtotal DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_dcot_cot  FOREIGN KEY (cotizacion_id) REFERENCES cotizaciones(id) ON DELETE CASCADE,
    CONSTRAINT fk_dcot_prod FOREIGN KEY (producto_id)   REFERENCES productos(id)
) ENGINE=InnoDB;

-- TESORERIA: CXC
CREATE TABLE cuentas_cobrar (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL, cliente_id INT NOT NULL,
    numero_documento VARCHAR(30),
    monto_total DECIMAL(10,2) NOT NULL, monto_pagado DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    saldo_pendiente DECIMAL(10,2) NOT NULL,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento TIMESTAMP NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cxc_vta FOREIGN KEY (venta_id)   REFERENCES ventas(id),
    CONSTRAINT fk_cxc_cli FOREIGN KEY (cliente_id) REFERENCES clientes(id)
) ENGINE=InnoDB;

CREATE TABLE movimientos_cxc (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cuenta_cobrar_id INT NOT NULL, tipo VARCHAR(30) NOT NULL DEFAULT 'ABONO',
    monto DECIMAL(10,2) NOT NULL, metodo_pago VARCHAR(30), referencia VARCHAR(100),
    usuario_id INT NOT NULL, fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observacion TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mcxc_cta FOREIGN KEY (cuenta_cobrar_id) REFERENCES cuentas_cobrar(id),
    CONSTRAINT fk_mcxc_usr FOREIGN KEY (usuario_id)       REFERENCES usuarios(id)
) ENGINE=InnoDB;

-- MODULO 9: DISTRIBUCION
CREATE TABLE transportistas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL, apellidos VARCHAR(100),
    dni VARCHAR(15), telefono VARCHAR(20), licencia VARCHAR(30),
    categoria VARCHAR(5), tipo_documento VARCHAR(10) DEFAULT 'DNI',
    num_documento VARCHAR(15),
    estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE agencias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL, ruc VARCHAR(11),
    ciudad VARCHAR(100), telefono VARCHAR(20),
    email VARCHAR(100), contacto VARCHAR(100),
    direccion VARCHAR(200), estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE rutas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL, origen VARCHAR(100), destino VARCHAR(100),
    agencia_id INT, distancia_km DECIMAL(8,2) DEFAULT 0,
    tiempo_minutos INT DEFAULT 0, descripcion TEXT,
    estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ruta_agencia FOREIGN KEY (agencia_id) REFERENCES agencias(id)
) ENGINE=InnoDB;

CREATE TABLE vehiculos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(20) NOT NULL UNIQUE, descripcion VARCHAR(100),
    marca VARCHAR(50), modelo VARCHAR(50), anio YEAR, color VARCHAR(30),
    tipo VARCHAR(20) DEFAULT 'CAMION',
    capacidad_kg DECIMAL(8,2) DEFAULT 0, capacidad_m3 DECIMAL(8,2) DEFAULT 0,
    transportista_id INT, estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_veh_trans FOREIGN KEY (transportista_id) REFERENCES transportistas(id)
) ENGINE=InnoDB;

-- MODULO 6: GUIAS Y DESPACHOS
CREATE TABLE guias_remision (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT, cliente_id INT NOT NULL, usuario_id INT NOT NULL,
    serie VARCHAR(10) NOT NULL, numero VARCHAR(20) NOT NULL,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_traslado TIMESTAMP NULL, motivo_traslado VARCHAR(100),
    transportista_id INT, estado INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_gr_vta   FOREIGN KEY (venta_id)         REFERENCES ventas(id),
    CONSTRAINT fk_gr_cli   FOREIGN KEY (cliente_id)       REFERENCES clientes(id),
    CONSTRAINT fk_gr_usr   FOREIGN KEY (usuario_id)       REFERENCES usuarios(id),
    CONSTRAINT fk_gr_trans FOREIGN KEY (transportista_id) REFERENCES transportistas(id)
) ENGINE=InnoDB;

CREATE TABLE despachos_productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT, guia_remision_id INT, cliente_id INT NOT NULL, usuario_id INT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    direccion_destino VARCHAR(300), transportista_id INT,
    fecha_programada TIMESTAMP NULL, fecha_entrega TIMESTAMP NULL,
    observaciones TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_desp_vta   FOREIGN KEY (venta_id)         REFERENCES ventas(id),
    CONSTRAINT fk_desp_guia  FOREIGN KEY (guia_remision_id) REFERENCES guias_remision(id),
    CONSTRAINT fk_desp_cli   FOREIGN KEY (cliente_id)       REFERENCES clientes(id),
    CONSTRAINT fk_desp_usr   FOREIGN KEY (usuario_id)       REFERENCES usuarios(id),
    CONSTRAINT fk_desp_trans FOREIGN KEY (transportista_id) REFERENCES transportistas(id)
) ENGINE=InnoDB;

-- LISTAS DE PRECIOS
CREATE TABLE listas_precios (
    id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL,
    descripcion TEXT, tienda_id INT NOT NULL, es_default TINYINT(1) NOT NULL DEFAULT 0,
    estado TINYINT(1) NOT NULL DEFAULT 1, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_lp_tienda FOREIGN KEY (tienda_id) REFERENCES tiendas(id)
) ENGINE=InnoDB;

CREATE TABLE detalle_lista_precios (
    id INT AUTO_INCREMENT PRIMARY KEY, lista_precio_id INT NOT NULL,
    producto_id INT NOT NULL, precio_especial DECIMAL(10,2) NOT NULL,
    descuento_pct DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_lista_prod (lista_precio_id, producto_id),
    CONSTRAINT fk_dlp_lista FOREIGN KEY (lista_precio_id) REFERENCES listas_precios(id) ON DELETE CASCADE,
    CONSTRAINT fk_dlp_prod  FOREIGN KEY (producto_id)     REFERENCES productos(id)
) ENGINE=InnoDB;

-- MODULO 8: COMPRAS Y CXP
CREATE TABLE proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_documento VARCHAR(20) NOT NULL DEFAULT 'RUC',
    num_documento VARCHAR(20) NOT NULL UNIQUE, razon_social VARCHAR(200) NOT NULL,
    contacto VARCHAR(100), telefono VARCHAR(20), email VARCHAR(100),
    direccion VARCHAR(200), estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE compras (
    id INT AUTO_INCREMENT PRIMARY KEY, proveedor_id INT NOT NULL,
    usuario_id INT NOT NULL, numero_factura VARCHAR(50),
    fecha_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    igv DECIMAL(10,2) NOT NULL DEFAULT 0.00, total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    estado VARCHAR(20) NOT NULL DEFAULT 'Recibida', observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_comp_prov FOREIGN KEY (proveedor_id) REFERENCES proveedores(id),
    CONSTRAINT fk_comp_usr  FOREIGN KEY (usuario_id)   REFERENCES usuarios(id)
) ENGINE=InnoDB;

CREATE TABLE detalle_compras (
    id INT AUTO_INCREMENT PRIMARY KEY, compra_id INT NOT NULL,
    producto_id INT NOT NULL, cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL, subtotal DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_dc_comp FOREIGN KEY (compra_id)   REFERENCES compras(id) ON DELETE CASCADE,
    CONSTRAINT fk_dc_prod FOREIGN KEY (producto_id) REFERENCES productos(id)
) ENGINE=InnoDB;

CREATE TABLE cuentas_pagar (
    id INT AUTO_INCREMENT PRIMARY KEY, compra_id INT NOT NULL,
    proveedor_id INT NOT NULL, monto_total DECIMAL(10,2) NOT NULL,
    monto_pagado DECIMAL(10,2) NOT NULL DEFAULT 0.00, saldo_pendiente DECIMAL(10,2) NOT NULL,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento TIMESTAMP NULL, estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cxp_comp FOREIGN KEY (compra_id)    REFERENCES compras(id),
    CONSTRAINT fk_cxp_prov FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
) ENGINE=InnoDB;

-- MODULO 4: INVENTARIOS / KARDEX
CREATE TABLE tipos_movimiento_inv (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL, tipo ENUM('ENTRADA','SALIDA') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE kardex (
    id INT AUTO_INCREMENT PRIMARY KEY, producto_id INT NOT NULL,
    tipo_movimiento_id INT NOT NULL, cantidad INT NOT NULL,
    stock_anterior INT NOT NULL, stock_actual INT NOT NULL,
    referencia VARCHAR(100), usuario_id INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_kar_prod FOREIGN KEY (producto_id)        REFERENCES productos(id),
    CONSTRAINT fk_kar_tipo FOREIGN KEY (tipo_movimiento_id) REFERENCES tipos_movimiento_inv(id)
) ENGINE=InnoDB;

-- MODULO 5: TESORERIA
CREATE TABLE cuentas_bancarias (
    id INT AUTO_INCREMENT PRIMARY KEY, banco VARCHAR(100) NOT NULL,
    numero_cuenta VARCHAR(30) NOT NULL, tipo_cuenta VARCHAR(30) DEFAULT 'CORRIENTE',
    moneda VARCHAR(5) DEFAULT 'PEN', saldo_actual DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    tienda_id INT, estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cb_tienda FOREIGN KEY (tienda_id) REFERENCES tiendas(id)
) ENGINE=InnoDB;

CREATE TABLE movimientos_caja (
    id INT AUTO_INCREMENT PRIMARY KEY, caja_id INT NOT NULL,
    tipo ENUM('INGRESO','EGRESO') NOT NULL, monto DECIMAL(10,2) NOT NULL,
    concepto VARCHAR(200), referencia VARCHAR(100), usuario_id INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mcj_caja FOREIGN KEY (caja_id) REFERENCES cajas(id)
) ENGINE=InnoDB;

CREATE TABLE movimientos_bancarios (
    id INT AUTO_INCREMENT PRIMARY KEY, cuenta_bancaria_id INT NOT NULL,
    tipo ENUM('DEPOSITO','RETIRO','TRANSFERENCIA') NOT NULL,
    monto DECIMAL(12,2) NOT NULL, descripcion VARCHAR(200),
    referencia VARCHAR(100), fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mb_cta FOREIGN KEY (cuenta_bancaria_id) REFERENCES cuentas_bancarias(id)
) ENGINE=InnoDB;

-- MODULO 13: PROMOCIONES
CREATE TABLE promociones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL, descripcion TEXT,
    tipo VARCHAR(50) NOT NULL DEFAULT 'DESCUENTO_PORCENTAJE',
    valor DECIMAL(10,2) NOT NULL DEFAULT 0.00, codigo VARCHAR(50),
    fecha_inicio DATE, fecha_fin DATE,
    scope VARCHAR(20) NOT NULL DEFAULT 'TODO',
    estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- MODULO 10: TIENDA ONLINE
CREATE TABLE secciones_tienda (
    id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL,
    descripcion TEXT, orden INT DEFAULT 0, visible TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- MODULO 11: PEDIDOS ONLINE
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY, cliente_id INT,
    estado VARCHAR(30) NOT NULL DEFAULT 'NUEVO',
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    igv DECIMAL(10,2) NOT NULL DEFAULT 0.00, total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    metodo_pago VARCHAR(30) DEFAULT 'Efectivo', observacion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_ped_cli FOREIGN KEY (cliente_id) REFERENCES clientes(id)
) ENGINE=InnoDB;

CREATE TABLE detalle_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY, pedido_id INT NOT NULL,
    producto_id INT NOT NULL, cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL, subtotal DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_dp_ped  FOREIGN KEY (pedido_id)   REFERENCES pedidos(id) ON DELETE CASCADE,
    CONSTRAINT fk_dp_prod FOREIGN KEY (producto_id) REFERENCES productos(id)
) ENGINE=InnoDB;

-- MODULO 14: VENTA CAMPO
CREATE TABLE zonas_venta (
    id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL,
    descripcion TEXT, color VARCHAR(10) DEFAULT '#f97316',
    estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE vendedores_campo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL, apellidos VARCHAR(100),
    dni VARCHAR(12), telefono VARCHAR(15), zona_id INT,
    estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vc_zona FOREIGN KEY (zona_id) REFERENCES zonas_venta(id)
) ENGINE=InnoDB;

CREATE TABLE rutas_campo (
    id INT AUTO_INCREMENT PRIMARY KEY, vendedor_id INT, zona_id INT,
    fecha_ruta DATE, observacion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rc_vend FOREIGN KEY (vendedor_id) REFERENCES vendedores_campo(id),
    CONSTRAINT fk_rc_zona FOREIGN KEY (zona_id)     REFERENCES zonas_venta(id)
) ENGINE=InnoDB;

-- MODULO 15: DELIVERY - REPARTIDORES
CREATE TABLE repartidores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL, apellidos VARCHAR(100),
    dni VARCHAR(12), telefono VARCHAR(15),
    vehiculo VARCHAR(50) DEFAULT 'Moto', placa VARCHAR(20),
    estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- MODULO 17: CONTABILIDAD
CREATE TABLE plan_cuentas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE, nombre VARCHAR(150) NOT NULL,
    tipo VARCHAR(30), nivel TINYINT NOT NULL DEFAULT 1,
    cuenta_padre_id INT, estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pc_padre FOREIGN KEY (cuenta_padre_id) REFERENCES plan_cuentas(id)
) ENGINE=InnoDB;

CREATE TABLE centros_costos (
    id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL,
    descripcion TEXT, color VARCHAR(10) DEFAULT '#f97316',
    estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE asientos_contables (
    id INT AUTO_INCREMENT PRIMARY KEY, descripcion VARCHAR(200) NOT NULL,
    fecha DATE NOT NULL, referencia VARCHAR(100),
    centro_costo_id INT, usuario_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ac_cc  FOREIGN KEY (centro_costo_id) REFERENCES centros_costos(id),
    CONSTRAINT fk_ac_usr FOREIGN KEY (usuario_id)      REFERENCES usuarios(id)
) ENGINE=InnoDB;

CREATE TABLE detalle_asientos (
    id INT AUTO_INCREMENT PRIMARY KEY, asiento_id INT NOT NULL,
    plan_cuenta_id INT NOT NULL, tipo ENUM('DEBE','HABER') NOT NULL,
    monto DECIMAL(12,2) NOT NULL DEFAULT 0.00, descripcion VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_da_asi  FOREIGN KEY (asiento_id)     REFERENCES asientos_contables(id) ON DELETE CASCADE,
    CONSTRAINT fk_da_cta  FOREIGN KEY (plan_cuenta_id) REFERENCES plan_cuentas(id)
) ENGINE=InnoDB;

-- MODULO 18: DISPOSITIVOS
CREATE TABLE dispositivos (
    id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL, ip VARCHAR(20), serie VARCHAR(100),
    tienda_id INT NOT NULL, estado TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_disp_tienda FOREIGN KEY (tienda_id) REFERENCES tiendas(id)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- DATOS INICIALES
-- ============================================================

-- Tiendas
INSERT INTO tiendas (id,nombre,ruc,ruc1,ruc2,ruc3,direccion,ciudad) VALUES
(1,'Tienda Central', '10123456789','10123456789','10123456780','10123456781','Av. Principal 123','Lima'),
(2,'Tienda Norte',   '20123456789','20123456789','20123456780','20123456781','Av. Norte 456','Lima'),
(3,'Tienda Sur',     '30123456789','30123456789','30123456780','30123456781','Av. Sur 789','Lima');

-- Cajas
INSERT INTO cajas (id,tienda_id,nombre) VALUES
(1,1,'Caja 1 Central'),(2,1,'Caja 2 Central'),(3,2,'Caja Norte'),(4,3,'Caja Sur');

-- Roles
INSERT INTO roles (id,nombre,descripcion) VALUES
(1,'Administrador','Acceso total al sistema.'),
(2,'Almacen','Gestion de inventario.'),
(3,'Vendedor','Realiza ventas.'),
(4,'Cajero','Opera la caja.'),
(5,'Contabilidad','Reportes financieros.'),
(6,'Supervisor','Supervision de ventas.');

-- Usuarios
INSERT INTO usuarios (nombres,username,password,email,rol_id,tienda_id) VALUES
('Administrador General','admin','admin123','admin@caposnet.com',1,1),
('Vendedor 1','vendedor1','venta123','vendedor1@caposnet.com',3,1),
('Vendedor 2','vendedor2','venta123','vendedor2@caposnet.com',3,1),
('Cajero 1','cajero1','caja123','cajero1@caposnet.com',4,1),
('Almacenero','almacen1','alma123','almacen@caposnet.com',2,1),
('Contador','contador1','cont123','contador@caposnet.com',5,1);

-- Categorias
INSERT INTO categorias (id,nombre) VALUES (1,'Ropa'),(2,'Calzado'),(3,'Accesorios');
INSERT INTO subcategorias (id,nombre,categoria_id) VALUES
(1,'Polos',1),(2,'Pantalones',1),(3,'Casacas',1),
(4,'Zapatillas',2),(5,'Botas',2),(6,'Gorras',3);
INSERT INTO subsubcategorias (id,nombre,subcategoria_id) VALUES
(1,'Oversize',1),(2,'Slim Fit',1),(3,'Regular',1),(4,'Jean',2),(5,'Jogger',2),
(6,'Cargo',2),(7,'Bomber',3),(8,'Cortaviento',3),(9,'Running',4),(10,'Casual',4),
(11,'Urbanas',5),(12,'Militar',5),(13,'Snapback',6),(14,'Dad Hat',6);
INSERT INTO marcas (nombre) VALUES ('Veteran'),('Adidas'),('Nike'),('Sin Marca');
INSERT INTO unidades (nombre,abreviatura) VALUES ('Unidad','UND'),('Par','PAR'),('Caja','CJA');

-- Productos
INSERT INTO productos (codigo_barras,nombre,precio_compra,precio_venta,stock,subsubcategoria_id,marca_id,unidad_id) VALUES
('7501000001','Polo Oversize Negro',25.00,49.90,100,1,1,1),
('7501000002','Polo Oversize Blanco',25.00,49.90,80,1,1,1),
('7501000003','Polo Slim Fit Azul',22.00,44.90,60,2,1,1),
('7501000004','Jean Clasico Azul',35.00,79.90,50,4,1,1),
('7501000005','Jogger Negro Streetwear',30.00,69.90,45,5,1,1),
('7501000006','Cargo Beige Militar',38.00,85.00,30,6,1,1),
('7501000007','Casaca Bomber Verde',55.00,119.90,25,7,1,1),
('7501000008','Cortaviento Impermeable',60.00,129.90,20,8,1,1),
('7501000009','Zapatilla Running Pro',70.00,149.90,35,9,1,2),
('7501000010','Zapatilla Casual Urban',50.00,99.90,40,10,1,2),
('7501000011','Bota Urbana Cuero',80.00,169.90,15,11,1,2),
('7501000012','Gorra Snapback Veteran',12.00,29.90,90,13,1,1),
('7501000013','Gorra Dad Hat Classic',10.00,24.90,70,14,1,1);

-- Clientes
INSERT INTO clientes (tipo_documento,num_documento,nombres,apellidos,direccion) VALUES
('DNI','00000000','Cliente General','',  'Sin direccion'),
('DNI','12345678','Juan','Perez Garcia','Av. Los Pinos 123'),
('RUC','20123456789','Empresa SAC','',  'Jr. Comercio 456'),
('DNI','87654321','Maria','Lopez Diaz', 'Calle Las Flores 789');

-- Series comprobante
INSERT INTO series_comprobante (id,tipo_comprobante,serie,numero_actual) VALUES
(1,'Factura','F001',2),(2,'Boleta','B001',7),(3,'Nota de Venta','NV01',0);

-- Tipos movimiento inventario
INSERT INTO tipos_movimiento_inv (nombre,tipo) VALUES
('Compra a proveedor','ENTRADA'),('Devolucion de cliente','ENTRADA'),
('Ajuste positivo','ENTRADA'),('Venta','SALIDA'),
('Devolucion a proveedor','SALIDA'),('Ajuste negativo','SALIDA');

-- Transportistas
INSERT INTO transportistas (nombres,apellidos,dni,telefono,licencia) VALUES
('Carlos','Rios Paredes','45678901','987654321','A-IIa-12345'),
('Luis','Mamani Torres','56789012','976543210','A-IIb-67890');

-- Agencias
INSERT INTO agencias (nombre,ruc,ciudad,telefono) VALUES
('Olva Courier','20456789012','Lima','01-5001000'),
('Shalom','20567890123','Lima','01-6001000');

-- Rutas
INSERT INTO rutas (nombre,origen,destino,agencia_id,distancia_km,tiempo_minutos) VALUES
('Lima - Callao','Lima Centro','Callao',1,12.5,35),
('Lima - Surco','Lima Centro','Santiago de Surco',1,18.0,45),
('Lima - SJL','Lima Centro','San Juan de Lurigancho',2,22.0,55);

-- Vehiculos
INSERT INTO vehiculos (placa,descripcion,marca,tipo,capacidad_kg,transportista_id) VALUES
('ABC-123','Camion pequeno','Toyota','CAMION',500,1),
('XYZ-456','Moto delivery','Honda','MOTO',30,2);

-- Listas de precios
INSERT INTO listas_precios (nombre,descripcion,tienda_id,es_default) VALUES
('Precios Estandar','Lista de precios por defecto',1,1),
('Precios Mayorista','Precios para mayoristas',1,0);

-- Zonas de venta campo
INSERT INTO zonas_venta (nombre,descripcion,color) VALUES
('Zona Norte','Lima Norte: Comas, Los Olivos','#3b82f6'),
('Zona Sur','Lima Sur: Chorrillos, SJM','#10b981'),
('Zona Este','Lima Este: Ate, SJL','#f59e0b'),
('Zona Centro','Cercado, La Victoria, Rimac','#f97316'),
('Zona Callao','Callao y zona portuaria','#7c3aed');

-- Vendedores campo
INSERT INTO vendedores_campo (nombres,apellidos,dni,telefono,zona_id) VALUES
('Pedro','Huanca Mamani','72345001','981001001',1),
('Rosa','Quispe Torres','62345002','981001002',2),
('Jorge','Condori Flores','52345003','981001003',3);

-- Repartidores delivery
INSERT INTO repartidores (nombres,apellidos,dni,telefono,vehiculo,placa) VALUES
('Miguel','Torres Quispe','74521036','987001001','Moto','XYZ-001'),
('Sandra','Flores Ramos','83456712','987001002','Bicicleta',NULL),
('Roberto','Caceres Lazo','62398017','987001003','Moto','ABC-123');

-- Promociones
INSERT INTO promociones (nombre,descripcion,tipo,valor,codigo,fecha_inicio,fecha_fin,scope,estado) VALUES
('Descuento Bienvenida 10%','Para nuevos clientes','DESCUENTO_PORCENTAJE',10.00,'BIENVENIDA10',CURDATE(),DATE_ADD(CURDATE(),INTERVAL 30 DAY),'TODO',1),
('Liquidacion Temporada','S/20 en compras mayores a S/100','DESCUENTO_MONTO',20.00,'LIQUID20',CURDATE(),DATE_ADD(CURDATE(),INTERVAL 15 DAY),'TODO',1),
('2x1 en Gorras','Dos gorras al precio de una','2x1',0.00,'2X1GORRA',CURDATE(),DATE_ADD(CURDATE(),INTERVAL 7 DAY),'CATEGORIA',0);

-- Plan de cuentas PCGE Peru
INSERT INTO plan_cuentas (codigo,nombre,tipo,nivel) VALUES
('1',    'ACTIVO',                    'ACTIVO',    1),
('1.1',  'Activo Corriente',          'ACTIVO',    2),
('1.1.1','Caja y Bancos',             'ACTIVO',    3),
('1.1.2','Cuentas por Cobrar',        'ACTIVO',    3),
('1.1.3','Inventarios',               'ACTIVO',    3),
('1.2',  'Activo No Corriente',       'ACTIVO',    2),
('1.2.1','Inmuebles y Equipos',       'ACTIVO',    3),
('2',    'PASIVO',                    'PASIVO',    1),
('2.1',  'Pasivo Corriente',          'PASIVO',    2),
('2.1.1','Cuentas por Pagar',         'PASIVO',    3),
('2.1.2','Tributos por Pagar (IGV)',  'PASIVO',    3),
('3',    'PATRIMONIO',                'PATRIMONIO',1),
('3.1',  'Capital Social',            'PATRIMONIO',2),
('3.2',  'Resultados Acumulados',     'PATRIMONIO',2),
('4',    'INGRESOS',                  'INGRESO',   1),
('4.1',  'Ventas',                    'INGRESO',   2),
('4.1.1','Ventas de Mercaderia',      'INGRESO',   3),
('4.1.2','Descuentos Concedidos',     'INGRESO',   3),
('5',    'COSTOS Y GASTOS',           'GASTO',     1),
('5.1',  'Costo de Ventas',           'GASTO',     2),
('5.1.1','Costo Mercaderia Vendida',  'GASTO',     3),
('5.2',  'Gastos Operativos',         'GASTO',     2),
('5.2.1','Gastos de Personal',        'GASTO',     3),
('5.2.2','Gastos de Transporte',      'GASTO',     3),
('5.2.3','Gastos de Publicidad',      'GASTO',     3);

-- Centros de costos
INSERT INTO centros_costos (nombre,descripcion,color) VALUES
('Administracion','Gastos administrativos generales','#3b82f6'),
('Ventas','Costos del area de ventas','#f97316'),
('Logistica','Distribucion y transporte','#10b981'),
('Marketing','Publicidad y promociones','#7c3aed'),
('Operaciones','Produccion y operaciones','#f59e0b');

-- Dispositivos
INSERT INTO dispositivos (nombre,tipo,ip,tienda_id,estado) VALUES
('POS Central Caja 1','CAJA','192.168.1.10',1,1),
('Impresora Termica 80mm','IMPRESORA','192.168.1.20',1,1),
('Lector Codigo Barras USB','ESCANER',NULL,1,1),
('Tablet Ventas Mostrador','TABLET','192.168.1.30',1,1);

-- Proveedores demo
INSERT INTO proveedores (tipo_documento,num_documento,razon_social,telefono,email) VALUES
('RUC','20601234567','Textiles Lima S.A.C.','01-4001000','ventas@textlima.com'),
('RUC','20712345678','Importaciones del Sur E.I.R.L.','01-5002000','info@imsur.com');

-- Ventas de prueba
INSERT INTO ventas (cliente_id,usuario_id,serie_comprobante_id,caja_id,numero_comprobante,fecha_venta,subtotal,igv,total,metodo_pago,estado)
SELECT 1,id,2,1,'B001-000001',NOW(),42.29,7.61,49.90,'Efectivo','Completada' FROM usuarios WHERE username='vendedor1' LIMIT 1;
INSERT INTO detalle_ventas (venta_id,producto_id,cantidad,precio_unitario,subtotal)
SELECT LAST_INSERT_ID(),1,1,49.90,49.90;

INSERT INTO ventas (cliente_id,usuario_id,serie_comprobante_id,caja_id,numero_comprobante,fecha_venta,subtotal,igv,total,metodo_pago,estado)
SELECT 2,id,1,1,'F001-000001',NOW(),100.00,18.00,118.00,'Tarjeta','Completada' FROM usuarios WHERE username='vendedor1' LIMIT 1;
INSERT INTO detalle_ventas (venta_id,producto_id,cantidad,precio_unitario,subtotal)
SELECT LAST_INSERT_ID(),4,1,79.90,79.90;

-- CXC de prueba
INSERT INTO cuentas_cobrar (venta_id,cliente_id,numero_documento,monto_total,monto_pagado,saldo_pendiente,fecha_vencimiento,estado)
SELECT id,2,'F001-000001',118.00,0.00,118.00,DATE_ADD(NOW(),INTERVAL 30 DAY),'PENDIENTE'
FROM ventas WHERE numero_comprobante='F001-000001' LIMIT 1;

-- Pedidos online demo
INSERT INTO pedidos (cliente_id,estado,subtotal,igv,total,metodo_pago) VALUES
(2,'NUEVO',      42.29, 7.61, 49.90,'Yape'),
(3,'EN_PROCESO', 84.58,15.22, 99.80,'Tarjeta'),
(1,'ENVIADO',   127.03,22.87,149.90,'Efectivo'),
(2,'ENTREGADO',  67.71,12.19, 79.90,'Plin'),
(4,'CANCELADO',  25.34, 4.56, 29.90,'Efectivo');

-- Secciones tienda online
INSERT INTO secciones_tienda (nombre,descripcion,orden,visible) VALUES
('Novedades','Productos nuevos y destacados',1,1),
('Ofertas','Productos en descuento',2,1),
('Mas vendidos','Los productos mas populares',3,1);

-- Cotizacion demo
INSERT INTO cotizaciones (cliente_id,usuario_id,numero,fecha_vencimiento,subtotal,igv,total,estado)
SELECT 2,id,'COT-2026-001',DATE_ADD(NOW(),INTERVAL 15 DAY),84.58,15.22,99.80,1
FROM usuarios WHERE username='vendedor1' LIMIT 1;

-- ============================================================
-- VERIFICACION FINAL
-- ============================================================
SELECT CONCAT('Tablas creadas: ', COUNT(*)) AS resultado
FROM information_schema.tables WHERE table_schema = DATABASE();

SELECT table_name AS Tabla, table_rows AS Filas
FROM information_schema.tables
WHERE table_schema = DATABASE()
ORDER BY table_name;
