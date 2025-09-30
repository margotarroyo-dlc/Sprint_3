				  # PRUEBA SQL - SPRIT 3
                -- ---------- -------------------------------
-- Curso: Data analytics_2025
-- Alumna: Margot Hilda Arroyo De la Cruz 	
-- Revision P2P: Ekaterina			

    
    # Base de Datos:
		USE transactions;
		SHOW TABLES;
											# Nivel 1 #
-- --------------------------------------------------------------------------------------------------------------
# Ejercicio 1
-- Tu tarea es diseñar y crear una tabla llamada "credit_card" que almacene detalles cruciales sobre las tarjetas 
-- de crédito. La nueva tabla debe ser capaz de identificar de forma única cada tarjeta y establecer una relación 
-- adecuada con las otras dos tablas ("transaction" y "company"). Después de crear la tabla será necesario que 
-- ingreses la información del documento denominado "datos_introducir_credit". Recuerda mostrar el diagrama y 
-- realizar una breve descripción del mismo.
	
		# Paso 1: Creacion de tabla
		CREATE TABLE credit_card (
			id VARCHAR(15) NOT NULL PRIMARY KEY,
			iban VARCHAR (45) NULL,
			pan VARCHAR(45) NULL,
			pin CHAR(4) NULL,
			cvv CHAR(3) NULL,
			expiring_date VARCHAR(8) NULL
		);
		# Paso 2: Ingresar datos "datos_introducir_sprint3_credit"
				# Verificacion e introduccion de datos:
				  SHOW COLUMNS FROM credit_card;
				  SELECT * FROM credit_card;     
                  
		# Paso 3: Generar relación: 
        -- La relación será de "muchos a uno", donde muchas transacciones pueden estar asociadas a una sola tarjeta.
        -- Mediante "fk_transaction_creditcard" se asegura que no se pueda insertar o actualizar un credit_card_id 
        -- en "transaction" que no exista en "credit_card". Evitando tener transacciones con tarjetas inexistentes.
        
		 ALTER TABLE transaction
	     ADD  FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);
         
          
# Ejercicio 2
-- El departamento de Recursos Humanos ha identificado un error en el número de cuenta asociado a su tarjeta de 
-- crédito con ID CcU-2938. La información que debe mostrarse para este registro es: TR323456312213576817699999. 
-- Recuerda mostrar que el cambio se realizó.
	
    # Ver el valor actual del dato
		SELECT id, iban
		FROM credit_card
		WHERE id="CcU-2938";
        
	# Modificar el valor de la celda
		UPDATE credit_card
        SET iban="TR323456312213576817699999"
        WHERE id="CcU-2938";
        
	# verificar
 		SELECT id, iban
		FROM credit_card
		WHERE id="CcU-2938";     

# Ejercicio 3
-- En la tabla "transaction" ingresa un nuevo usuario con la siguiente información:
	# Verificar si existe la compañia
		SELECT *
		FROM company
		WHERE id="b-9999"; 
        
	# Insertar compañia
		INSERT INTO 
		company(id) 
		VALUES ("b-9999" );
	# Insertar tarjeta:
		INSERT INTO credit_card (id)
		VALUES ("CcU-9999");
        
	# Insertar transaccion
		INSERT INTO transaction(id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined) 
		VALUES ("108B1D1D-5B23-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", 9999,	829.999, -117.999, now(), 111.11, 0 );
        
	# verificar
 		SELECT *
		FROM transactions.transaction
		WHERE id="108B1D1D-5B23-A76C-55EF-C568E49A99DD"; 
         
# Ejercicio 4
-- Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_card. Recuerda mostrar el 
-- cambio realizado.

	ALTER TABLE credit_card
    DROP COLUMN pan;
    
    # verificar
    DESCRIBE credit_card;

											# Nivel 2
-- --------------------------------------------------------------------------------------------------------------
# Ejercicio 1
-- Elimina de la tabla transacción el registro con ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de datos.

	DELETE FROM transaction
    WHERE id="000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";
    
    #verificar
    SELECT * 
    FROM transaction
    WHERE id="000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";

# Ejercicio 2
-- La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias efectivas. 
-- Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones. Será 
-- necesaria que crees una vista llamada VistaMarketing que contenga la siguiente información: Nombre de la compañía.
-- Teléfono de contacto. País de residencia. Media de compra realizado por cada compañía. Presenta la vista creada, 
-- ordenando los datos de mayor a menor promedio de compra.

	#creando vista
    CREATE VIEW VistaMarketing AS
	SELECT 
		c.company_name AS nombre,
        c.phone AS telefono,
        c.country AS pais,
        ROUND(AVG(t.amount),2) AS media_compra 
	FROM company c
    JOIN transaction t ON c.id=t.company_id
    GROUP BY nombre, telefono, pais
	ORDER BY media_compra DESC;
    
    # verificar
    SELECT * FROM VistaMarketing;

# Ejercicio 3
-- Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"
	SELECT * 
    FROM VistaMarketing
    WHERE Pais="Germany";

											# Nivel 3
-- --------------------------------------------------------------------------------------------------------------
# Ejercicio 1
-- La próxima semana tendrás una nueva reunión con los gerentes de marketing. Un compañero de tu equipo realizó 
-- modificaciones en la base de datos, pero no recuerda cómo las realizó. Te pide que le ayudes a dejar los comandos 
-- ejecutados para obtener el siguiente diagrama:

	# Paso 1: Generar tabla user con el código "estructura datos user.sgl"
		CREATE TABLE IF NOT EXISTS user (
			id INT PRIMARY KEY,  -- La columna referenciada debe ser del mismo tipo de dato a la que hará referencia (transaction.user_id)
			name VARCHAR(100),
			surname VARCHAR(100),
			phone VARCHAR(150),
			email VARCHAR(150),
			birth_date VARCHAR(100),
			country VARCHAR(150),
			city VARCHAR(150),
			postal_code VARCHAR(100),
			address VARCHAR(255)    
		);
        
    # Paso 2: Introducir datos "datos_introducir_user"
	  -- verificar 
      SELECT * FROM user;
      SELECT * FROM transaction;
      
    #  Paso 3: Para hacer la vinculación con las se debe crear el usuario creado en el ejercicio 3 del Nivel 1.
		INSERT INTO user (id)
		VALUES ("9999");
        
    # Paso 4: Generar la relacion
      ALTER TABLE transaction
	  ADD  FOREIGN KEY (user_id) REFERENCES user(id);
   
   
      
	# Paso 5: Generar diagrama
        
# Ejercicio 2
-- La empresa también le pide crear una vista llamada "InformeTecnico" que contenga la siguiente información:
-- ID de la transacción
-- Nombre del usuario/a
-- Apellido del usuario/a
-- IBAN de la tarjeta de crédito usada.
-- Nombre de la compañía de la transacción realizada.
-- Asegúrese de incluir información relevante de las tablas que conocerá y utilice alias para cambiar de 
-- nombre columnas según sea necesario.

	#creando vista
    CREATE VIEW InformeTecnico AS
	SELECT 
		t.id AS id_transaccion,
        u.name AS nombre_usuario,
        u.surname AS apellido_usuario,
        cr.iban AS iban_tarjeta,
        c.company_name AS nombre_compañia
	FROM user u
    JOIN transaction t ON u.id=t.user_id
    JOIN credit_card cr ON t.credit_card_id=cr.id
    JOIN company c ON t.company_id=c.id
    ORDER BY id_transaccion DESC;

    # verificar
    SELECT * FROM InformeTecnico;



