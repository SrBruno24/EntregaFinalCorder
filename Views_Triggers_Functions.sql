USE CarritoDeCompraPCComponentes;

-- VIEWS --

-- 1. Vista: Pedidos con nombre del cliente y total
CREATE OR REPLACE VIEW vw_pedidos_clientes AS
SELECT 
    p.pedido_id,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    p.fecha_pedido,
    p.estado,
    p.total
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id;

-- 2. Vista: Productos con stock bajo (menos de 10 unidades)
CREATE OR REPLACE VIEW vw_stock_bajo AS
SELECT 
    producto_id,
    nombre,
    stock
FROM productos
WHERE stock < 10;

-- 3. Vista: Productos más vendidos (cantidad total por producto)
CREATE OR REPLACE VIEW vw_productos_mas_vendidos AS
SELECT 
    dp.producto_id,
    pr.nombre,
    SUM(dp.cantidad) AS total_vendido
FROM detalle_pedido dp
JOIN productos pr ON dp.producto_id = pr.producto_id
GROUP BY dp.producto_id, pr.nombre
ORDER BY total_vendido DESC;

-- STORED PROCEDURES --

-- 1. SP: Insertar un nuevo cliente
DELIMITER //
CREATE PROCEDURE sp_insertar_cliente(
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_direccion TEXT
)
BEGIN
    INSERT INTO clientes (nombre, apellido, email, telefono, direccion)
    VALUES (p_nombre, p_apellido, p_email, p_telefono, p_direccion);
END;
//
DELIMITER ;

-- 2. SP: Cambiar el estado de un pedido
DELIMITER //
CREATE PROCEDURE sp_cambiar_estado_pedido(
    IN p_pedido_id INT,
    IN p_nuevo_estado ENUM('Pendiente', 'Enviado', 'Entregado', 'Cancelado')
)
BEGIN
    UPDATE pedidos
    SET estado = p_nuevo_estado
    WHERE pedido_id = p_pedido_id;
END;
//
DELIMITER ;

--  TRIGGERS --

-- 1. Trigger: Reducir stock automáticamente al insertar detalle de pedido
DELIMITER //
CREATE TRIGGER trg_reducir_stock
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE productos
    SET stock = stock - NEW.cantidad
    WHERE producto_id = NEW.producto_id;
END;
//
DELIMITER ;

-- 2. Trigger: Verificar stock disponible antes de insertar detalle de pedido
DELIMITER //
CREATE TRIGGER trg_verificar_stock
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    DECLARE stock_actual INT;
    SELECT stock INTO stock_actual FROM productos WHERE producto_id = NEW.producto_id;

    IF stock_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock para este producto.';
    END IF;
END;
//
DELIMITER ;

--  FUNCIONES --

-- 1. Función: Calcular el total de productos en un pedido
DELIMITER //
CREATE FUNCTION fn_total_productos_en_pedido(p_pedido_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT SUM(cantidad) INTO total
    FROM detalle_pedido
    WHERE pedido_id = p_pedido_id;
    RETURN IFNULL(total, 0);
END;
//
DELIMITER ;

-- 2. Función: Verificar si un cliente tiene pedidos pendientes
DELIMITER //
CREATE FUNCTION fn_tiene_pedidos_pendientes(p_cliente_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE count_pendientes INT;
    SELECT COUNT(*) INTO count_pendientes
    FROM pedidos
    WHERE cliente_id = p_cliente_id AND estado = 'Pendiente';
    RETURN count_pendientes > 0;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_total_pedidos_por_cliente(p_cliente_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM pedidos
    WHERE cliente_id = p_cliente_id;
    RETURN total;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_total_gastado_por_cliente(p_cliente_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(total) INTO total
    FROM pedidos
    WHERE cliente_id = p_cliente_id;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_stock_producto(p_producto_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    SELECT stock INTO cantidad
    FROM productos
    WHERE producto_id = p_producto_id;
    RETURN cantidad;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_precio_total_pedido(p_pedido_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE suma DECIMAL(10,2);
    SELECT SUM(cantidad * precio_unitario) INTO suma
    FROM detalle_pedido
    WHERE pedido_id = p_pedido_id;
    RETURN IFNULL(suma, 0);
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_nombre_cliente(p_cliente_id INT)
RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN
    DECLARE nombre_completo VARCHAR(200);
    SELECT CONCAT(nombre, ' ', apellido) INTO nombre_completo
    FROM clientes
    WHERE cliente_id = p_cliente_id;
    RETURN nombre_completo;
END //
DELIMITER ;