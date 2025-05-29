Create database if not exists CarritoDeCompraPCComponentes;

Use CarritoDeCompraPCComponentes;

-- TABLAS --

-- Tabla de categorías (CPU, GPU, RAM, etc.)
CREATE TABLE categorias (
    categoria_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Tabla de proveedores
CREATE TABLE proveedores (
    proveedor_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    email VARCHAR(100)
);

-- Tabla de productos (componentes)
CREATE TABLE productos (
    producto_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    categoria_id INT,
    proveedor_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(proveedor_id)
);

-- Tabla de clientes
CREATE TABLE clientes (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    direccion TEXT
);

-- Tabla de pedidos
CREATE TABLE pedidos (
    pedido_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2),
    estado ENUM('Pendiente', 'Enviado', 'Entregado', 'Cancelado') DEFAULT 'Pendiente',
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- Tabla de detalles del pedido (productos por pedido)
CREATE TABLE detalle_pedido (
    detalle_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT,
    producto_id INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id),
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);

-- Agregar Contenido a las Tablas --

-- Categorías
INSERT INTO categorias (nombre, descripcion) VALUES
('CPU', 'Procesadores de distintas gamas y marcas'),
('GPU', 'Tarjetas gráficas para gaming, diseño y uso profesional'),
('RAM', 'Memorias de acceso aleatorio DDR4, DDR5'),
('Motherboard', 'Placas base compatibles con distintas arquitecturas'),
('Almacenamiento', 'Discos SSD, HDD y NVMe'),
('Fuente de poder', 'Fuentes certificadas de distintas potencias'),
('Gabinetes', 'Gabinetes para PCs de escritorio');

-- Proveedores
INSERT INTO proveedores (nombre, direccion, telefono, email) VALUES
('TechWorld S.A.', 'Av. Tecnología 123, Ciudad', '555-1234', 'ventas@techworld.com'),
('CompuGlobal', 'Calle Hardware 45, Centro', '555-5678', 'contacto@compuglobal.com'),
('PCMaster Pro', 'Ruta 9, KM 20', '555-7890', 'info@pcmasterpro.com'),
('HardZone Distribuidora', 'Av. Gamer 99, San Tech', '555-8910', 'ventas@hardzone.com'),
('NextGen Tech', 'Parque Industrial 200, TecnoCity', '555-6677', 'info@nextgentech.com'),
('ByteStore S.A.', 'Calle Silicon 808, Digitalia', '555-4545', 'contacto@bytestore.com');

-- Productos
INSERT INTO productos (nombre, descripcion, precio, stock, categoria_id, proveedor_id) VALUES
('Intel Core i7-12700K', 'Procesador de 12 núcleos y 20 hilos', 420.00, 10, 1, 1),
('AMD Ryzen 5 7600X', 'Procesador AM5 de 6 núcleos', 310.00, 15, 1, 2),
('NVIDIA RTX 4070', 'Tarjeta gráfica de última generación 12GB', 599.99, 5, 2, 1),
('Corsair Vengeance 16GB DDR5', 'Memoria RAM 2x8GB 5200MHz', 130.00, 20, 3, 2),
('ASUS ROG Strix B650E-F', 'Motherboard para AM5 con WiFi 6E', 260.00, 8, 4, 3),
('Kingston NV2 1TB NVMe', 'Disco SSD M.2 PCIe Gen4', 85.00, 25, 5, 3),
('EVGA 750W Gold', 'Fuente de poder 80 Plus Gold', 110.00, 12, 6, 2),
('Gabinete NZXT H510', 'Gabinete ATX con ventana lateral', 99.00, 10, 7, 1),
('AMD Ryzen 9 7900X', 'Procesador AM5 de 12 núcleos y alto rendimiento', 480.00, 7, 1, 4),
('Intel Core i9-13900K', 'Procesador de gama alta para creadores y gamers', 620.00, 5, 1, 5),
('NVIDIA RTX 4080', 'Tarjeta gráfica premium con Ray Tracing', 1199.00, 3, 2, 4),
('Gigabyte GeForce RTX 4060 Ti', 'GPU eficiente para gamers de gama media', 399.99, 9, 2, 2),
('G.SKILL Trident Z RGB 32GB DDR5', 'RAM 2x16GB 6000MHz con iluminación RGB', 210.00, 14, 3, 3),
('MSI B650 Tomahawk', 'Placa base compatible con Ryzen serie 7000', 185.00, 11, 4, 5),
('Samsung 980 PRO 2TB NVMe', 'SSD M.2 PCIe Gen4 de alto rendimiento', 179.99, 10, 5, 6),
('Western Digital Blue 2TB HDD', 'Disco duro mecánico para almacenamiento masivo', 65.00, 20, 5, 4),
('Corsair RM850x', 'Fuente de poder modular 850W 80 Plus Gold', 140.00, 6, 6, 3),
('Cooler Master HAF 700 EVO', 'Gabinete torre completa con flujo de aire optimizado', 279.00, 4, 7, 6),
('Intel Core i5-12400F', 'CPU de gama media ideal para gaming económico', 180.00, 18, 1, 1),
('AMD Radeon RX 6700 XT', 'Tarjeta gráfica de alto rendimiento para 1440p', 449.00, 6, 2, 5),
('Patriot Viper Steel 16GB DDR4', 'Memoria RAM 3200MHz CL16', 75.00, 30, 3, 2),
('ASRock B550M Pro4', 'Placa madre micro-ATX para Ryzen', 110.00, 13, 4, 3),
('Crucial P3 500GB NVMe', 'SSD económico PCIe Gen3', 42.00, 50, 5, 4),
('Thermaltake Smart 600W', 'Fuente de poder básica para sistemas de entrada', 49.99, 17, 6, 2),
('NZXT H5 Flow', 'Gabinete con buena ventilación y diseño compacto', 89.00, 15, 7, 1);

-- Clientes
INSERT INTO clientes (nombre, apellido, email, telefono, direccion) VALUES
('Juan', 'Pérez', 'juanperez@gmail.com', '555-1111', 'Calle Uno 123'),
('María', 'García', 'mariag@hotmail.com', '555-2222', 'Av. Siempre Viva 742'),
('Carlos', 'López', 'clopez@mail.com', '555-3333', 'Diagonal 80 N° 1001'),
('Lucía', 'Martínez', 'lucia.martinez@correo.com', '555-4444', 'Barrio Las Palmas 55'),
('Sofía', 'Ramírez', 'sofia.ramirez@email.com', '555-6666', 'Calle Gamer 404');

-- Pedidos
INSERT INTO pedidos (cliente_id, fecha_pedido, total, estado) VALUES
(1, NOW(), 730.00, 'Pendiente'),   -- Juan Pérez
(2, NOW(), 195.00, 'Enviado'),     -- María García
(3, NOW(), 109.00, 'Entregado'),   -- Carlos López
(4, NOW(), 674.00, 'Pendiente'),   -- Lucía Martínez
(5, NOW(), 361.99, 'Enviado'),     -- Sofía Ramírez
(2, NOW(), 624.00, 'Entregado'),   -- María García
(1, NOW(), 224.00, 'Pendiente');   -- Juan Pérez

-- Detalle de pedidos
-- Pedido 1 de Juan Pérez
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 420.00),
(1, 4, 2, 130.00),

-- Pedido 2 de María García
(2, 6, 1, 85.00),
(2, 7, 1, 110.00),

-- Pedido 3 de Carlos López
(3, 8, 1, 99.00),
(3, 5, 1, 260.00);

-- Pedido 4: Lucía Martínez
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario) VALUES
(4, 12, 1, 480.00),  -- AMD Ryzen 9 7900X
(4, 14, 1, 130.00),  -- Corsair Vengeance DDR5
(4, 6, 1, 85.00);    -- Kingston NV2 1TB

-- Pedido 5: Sofía Ramírez
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario) VALUES
(5, 24, 1, 180.00),  -- Intel i5-12400F
(5, 27, 1, 49.99),   -- Thermaltake 600W
(5, 28, 1, 89.00),   -- NZXT H5 Flow
(5, 25, 1, 42.00);   -- Crucial P3

-- Pedido 6: María García
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario) VALUES
(6, 20, 1, 620.00);  -- Intel i9-13900K

-- Pedido 7: Juan Pérez
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario) VALUES
(7, 26, 1, 75.00),   -- Patriot RAM
(7, 23, 1, 110.00),  -- ASRock B550M
(7, 25, 1, 42.00);   -- Crucial P3
