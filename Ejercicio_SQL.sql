

-- =========================
-- EJERCICIOS EXAMEN MÓDULO 2  SQL
-- =========================

/*Base de Datos Sakila:**

Para este ejercicio utilizaremos la bases de datos Sakila que hemos estado utilizando durante el repaso de SQL. 
Es una base de datos de ejemplo que simula una tienda de alquiler de películas. Contiene tablas como `film` (películas), 
`actor` (actores), `customer` (clientes), `rental` (alquileres), `category` (categorías), entre otras. 
Estas tablas contienen información sobre películas, actores, clientes, alquileres y más, y se utilizan para realizar consultas y 
análisis de datos en el contexto de una tienda de alquiler de películas.*/


-- =========================================
-- EJERCICIO: 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados
-- =========================================


USE sakila;                          

SELECT DISTINCT title                                                            
FROM film;

/* DISTINCT "sin repetidos". Sin él,si una película aparece dos veces en la tabla,la verías dos veces.*/


-- =========================================
-- EJERCICIO: 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
-- =========================================

SELECT title                        
FROM film                           
WHERE rating = 'PG-13';             

-- Selecciono lo que quiero ver con TITLE
-- WHERE filtra filas. Solo devuelve las películas donde la condición rating sea exactamente 'PG-13'


-- =========================================
-- EJERCICIO: 3 Encuentra el título y la descripción de todas las películas que contengan la cadena de caracteres "amazing" en su descripción.
-- =========================================


SELECT title , description                 
FROM film
WHERE description LIKE '%amazing%';     

       
-- LIKE sirve para buscar texto.=“que tenga la palabra AMAZING en cualquier parte”.
-- Los % son comodines (= cualquier cosa antes y después).


-- =========================================
-- EJERCICIO: 4 Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

-- =========================================


SELECT title
FROM film
WHERE length > 120;                                   

 -- length = duración y >  mayor que
 
 

-- =========================================
-- EJERCICIO: 5 Recupera los nombres y apellidos de todos los actores.
-- =========================================

 -- Ahora hay que seleccionar desde ACTOR


SELECT first_name, last_name                                 
FROM actor;


-- =========================================
-- EJERCICIO: 6 Encuentra el nombre y apellidos de los actores que tengan "Gibson" en su apellido.
-- =========================================


SELECT last_name
FROM actor
WHERE last_name LIKE '%Gibson%';

SELECT last_name
FROM actor
WHERE last_name = 'Gibson'; 



-- =========================================
-- EJERCICIO: 7 Encuentra los nombres y apellidos de los actores que tengan un actor_id entre 10 y 20.
-- =========================================


SELECT first_name, last_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;
 
 
  -- BETWEEN 10 AND 20 incluye el 10 y el 20. Es lo mismo que actor_id >= 10 AND actor_id <= 20.
  
  
  
-- =========================
-- EJERCICIO 8 Encuentra el título de las películas en la tabla `film` que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
-- =========================

  
  SELECT title
  FROM film
  WHERE rating NOT IN ("PG-13", "R");                
  
  -- NOT IN (...) excluye los valores de la lista.
  
  
  -- =========================
     /*EJERCICIO  9 Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto 
     con el recuento.*/
-- =========================

  
  SELECT rating, COUNT(*) AS total_peliculas     
  FROM film
  GROUP BY rating;                               
  
  -- COUNT(*) CUENTA cuántas hay en cada grupo.
  -- GROUP BY rating AGRUPA todas las filas por clasificación
  
  
  
-- =========================================
-- EJERCICIO: 10 Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
-- su nombre y apellido junto con la cantidad de películas alquiladas.*/   -- JOINS UNIR TABLAS
-- =========================================
  
 
  /*  IMPORTANTE: cómo pensar los JOIN

Pensar siempre:

1. ¿Qué quiero mostrar?
Nombre cliente + número alquileres.

2. ¿Dónde está cada dato?
nombre → customer
alquileres → rental

3. ¿Cómo se conectan?
Por customer_id   */
  
  
-- Unimos customer y rental por su columna en común (customer_id).  Luego contamos los alquileres de cada cliente.
-- customer.customer_id = rental.customer_id

-- customer → rental

SELECT 
    customer.customer_id,            
    customer.first_name,
    customer.last_name,
    COUNT(rental.rental_id) AS total_alquileres
FROM customer
INNER JOIN rental                    
ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name;


-- Quiero ver: el id del cliente, el nombre del cliente, el apellido del cliente, cuenta cuántos alquileres tiene cada cliente,  le pongo ese nombre a la columna
-- Empiezo desde la tabla customer
-- Uno customer con rental por customer_id,  porque es la columna que tienen en común. Así sé qué alquileres pertenecen a qué cliente
-- Agrupa los resultados por cliente. Así COUNT cuenta los alquileres de cada cliente por separado. 
-- Sin esto contaría todos los alquileres de todos los clientes juntos.


-- =====================================================
-- EJERCICIO N° 11 Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con 
-- el recuento de alquileres.
-- ES MÁS DIFÍCIL PORQUE CONECTA MÁS TABLAS
-- CONSULTAS MULTITABLA EN SQL
-- -----------------------------------------------------
-- Descripción:
-- Mostrar el nombre de cada categoría y el total
-- de alquileres realizados.
--
-- Tablas utilizadas:
-- - category
-- - film_category
-- - film
-- - inventory
-- - rental
-- =====================================================
-- category → film_category → film → inventory → rental


SELECT category.name,                                         
       COUNT(rental.rental_id) AS total_alquileres            
FROM category                                                 
INNER JOIN film_category                                      
    ON category.category_id = film_category.category_id       
INNER JOIN film                                                 
    ON film_category.film_id = film.film_id              
INNER JOIN inventory                                          
    ON film.film_id = inventory.film_id                     
INNER JOIN rental                                             
    ON inventory.inventory_id = rental.inventory_id          
GROUP BY category.name;                                      




-- el nombre de la categoría
-- cuenta cuántos alquileres hay en cada categoría
-- Dice desde qué tabla empiezo, category
-- primer puente.  conecto categoría con sus películas
-- las une por la columna que tienen en común, que es category_id
-- segundo puente. Une la tabla film_category con la tabla film
-- las une por film_id. Ya tenemos categoría + película juntas
-- tercer puente. Une la tabla film con la tabla inventory, necesito pasar por inventario para llegar a alquileres
-- las une por film_id.El inventario es necesario porque es el puente entre película y alquiler
-- cuarto puente. Une la tabla inventory con la tabla rental
-- las une por inventory_id
-- Agrupa todos los resultados por nombre de categoría


 
-- =========================================
-- EJERCICIO: 12 Encuentra el promedio de duración de las películas para cada clasificación de la tabla `film` y muestra 
-- la clasificación junto con el promedio de duración.TOTAL DE ALQUILERES POR CATEGORÍA
-- =========================================


SELECT rating, AVG (length) AS promedio_duracion        
FROM film
GROUP BY rating;

-- AVG () CALCULA LA MEDIA



-- =========================================
-- EJERCICIO: 13 Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
-- TABLAS NECESARIAS : ACTOR, FILM_ACTOR Y FILM 
-- =========================================

-- actor → film_actor → film

SELECT actor.first_name, actor.last_name                        
FROM actor                                                     
INNER JOIN film_actor                                           
      ON actor.actor_id = film_actor.actor_id                   
INNER JOIN film
      ON film_actor.film_id = film.film_id                      
WHERE film.title = 'Indian Love';                              
                                                                


-- Quiero ver el nombre y apellido del actor
-- Empiezo desde la tabla actor
-- Uno actor con film_actor por actor_id
-- film_actor es la tabla puente que conecta actores con películas
-- Uno film_actor con film por film_id, actores + películas juntos
-- Filtro para quedarme SOLO con la película que se llama "Indian Love"
-- Sin este WHERE me devolvería actores de TODAS las películas


-- =========================================
-- EJERCICIO:14 Muestra el título de todas las películas que contengan la cadena de caracteres "dog" o "cat" en su descripción.
-- =========================================

SELECT title
FROM film
WHERE description LIKE '%dog%'
OR description LIKE '%cat%';

-- =========================================
-- EJERCICIO: 15 Hay algún actor o actriz que no aparezca en ninguna película en la tabla `film_actor`.  USAMOS LEFT JOIN 
-- =========================================


SELECT actor.first_name, actor.last_name                  
FROM actor                                                
LEFT JOIN film_actor                                           
	ON actor.actor_id = film_actor.actor_id
WHERE film_actor.film_id IS NULL;                             

-- Quiero ver el id, nombre y apellido del actor
-- Empiezo desde la tabla actor
-- LEFT JOIN trae TODOS los actores, tengan películas o no 
-- Este WHERE filtra SOLO los que tienen film_id vacío 

/* Queremos TODOS los actores incluso si no tienen películas*/
/*LEFT JOIN Trae todos los de la izquierda aunque no tengan coincidencia*/
/* Si no encuentran coincidencia NULL por eso filtramos IS NULL*/

/* ¿Por qué LEFT JOIN y no INNER JOIN?

"Con INNER JOIN solo me devolvería actores que SÍ tienen películas, y precisamente busco los que NO tienen ninguna. 
Con LEFT JOIN traigo todos los actores y luego con el WHERE film_actor.film_id IS NULL me quedo solo con los que no tienen película"*/


-- =========================================
-- EJERCICIO: 16 Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
-- =========================================


SELECT title                                      
FROM film                                         
WHERE release_year BETWEEN 2005 AND 2010;         

-- Quiero ver solo el título de la película
-- La información está en la tabla film
-- es la columna del año de lanzamiento, filtra años desde 2005 hasta 2010, AMBOS INCLUIDOS.

 
-- =========================================
-- EJERCICIO: 17 Encuentra el título de todas las películas que son de la misma categoría que "Family"
-- =========================================

-- film → film_category → category

SELECT film.title                                            -- Quiero ver el título de la película
FROM film                                                    -- Empiezo desde la tabla film
INNER JOIN film_category                                     -- film_category es la tabla puente entre películas y categorías
     ON film.film_id = film_category.film_id                 -- Uno film con film_category por film_id
INNER JOIN category                                          -- TABLA PUENTE 
	ON film_category.category_id = category.category_id      -- Uno film_category con category por category_id
WHERE category.name = 'Family';                              -- Filtro para quedarme SOLO con las películas de la categoría "Family"
                                                             -- Sin este WHERE me devolvería películas de TODAS las categorías
                                                             
                                                             
-- Necesito film_category porque film y category no están conectadas directamente
-- "Porque film y category no tienen una conexión directa. film_category es la tabla puente que las une,
-- tiene tanto el film_id como el category_id"

-- "La columna que se repite en dos tablas es el ON del JOIN"


-- =========================================
-- EJERCICIO: 18 Muestra el nombre y apellido de los actores que aparecen en más de 10 películas
-- =========================================

-- EL CAMINO : actor → film_actor

-- cuenta cuántas películas tiene cada actor, le pongo ese nombre a la columna del resultado 
-- Necesito film_actor porque ahí está la relación actor-película
-- Uno actor con film_actor por actor_id 
-- Agrupa los resultados por actor
-- Filtra y se queda solo con actores que tienen más de 10 películas
-- Usamos HAVING y no WHERE porque estamos filtrando un grupo
-- Así el COUNT cuenta las películas de cada actor por separado

SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS total_peliculas  
FROM actor                                                                                      
INNER JOIN film_actor                                          
    ON actor.actor_id = film_actor.actor_id                    
GROUP BY actor.actor_id, actor.first_name, actor.last_name     
HAVING COUNT(film_actor.film_id) > 10;                         
															  

/* HAVING es como un WHERE pero para grupos. Aquí filtra los actores cuyo recuento es mayor que 10. 
Regla fácil: WHERE filtra filas individuales, HAVING filtra grupos.*/

-- "Uso HAVING porque quiero filtrar después de haber contado las películas de cada actor. 
-- WHERE no puede usar COUNT porque se ejecuta antes de agrupar"

-- =========================================
-- EJERCICIO: 19 Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla `film`.
-- =========================================


SELECT title
FROM film
WHERE rating = 'R' 
AND length > 120;



-- =========================================
-- EJERCICIO: 20 Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos 
-- y muestra el nombre de la categoría junto con el promedio de duración.
-- =========================================

-- category → film_category → film
   

SELECT category.name, AVG(film.length) AS promedio_duracion
FROM category
INNER JOIN film_category
    ON category.category_id = film_category.category_id
INNER JOIN film
	ON film_category.film_id = film.film_id
GROUP BY category.name
HAVING AVG(film.length) > 120;


--  nombre de la categoría
--  promedio de duración de las películas
-- AVG significa media — suma todas las duraciones y las divide entre el número de películas
-- Empiezo desde category
-- Uno category con film_category por category_id
-- Uno film_category con film por film_id
-- Agrupa por categoría. Así AVG calcula el promedio de duración de cada categoría por separado.
-- Filtra y se queda solo con categorías cuyo promedio es mayor a 120 minutos.VUsamos HAVING porque filtramos después de agrupar.



-- =========================================
-- EJERCICIO:  21 Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de 
-- películas en las que han actuado.
-- =========================================

-- actor → film_actor


SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS total_peliculas
FROM actor
INNER JOIN film_actor
    ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(film_actor.film_id) >= 5;


-- Quiero ver nombre, apellido y cuántas películas tiene cada actor
-- Empiezo desde actor
-- Uno actor con film_actor por actor_id para poder contar las películas
-- Agrupa por actor para que COUNT cuente las películas de cada uno por separado
-- Filtra solo los actores con 5 o más películas, >=5 porque el 5 también cuenta


-- =========================================
-- EJERCICIO: 22  Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta 
-- para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.*/  -- SUBCONSULTAS
-- =========================================


-- film → inventory → (subconsulta rental)
-- Primero encontrar rentals que duran más de 5 días. Luego obtener películas.

SELECT title                                     										
FROM film                                        
INNER JOIN inventory
    ON film.film_id = inventory.film_id
WHERE inventory.inventory_id IN (                
    SELECT inventory_id
    FROM rental
    WHERE DATEDIFF(return_date, rental_date) > 5
);


-- Quiero ver los títulos de las películas
-- Uno film con inventory por film_id
-- Filtra solo los inventory_id que están dentro de la lista que devuelve la subconsulta
-- La subconsulta : DATEDIFF(return_date, rental_date) → calcula la diferencia en días entre la fecha de devolución y la fecha de alquiler.
-- > 5 → filtra solo los alquileres de más de 5 días
-- Esta subconsulta devuelve una lista de rental_id



--  /* es una query dentro de otra query.La subconsulta (lo que va dentro de los paréntesis) 
-- /* se ejecuta primero y devuelve una lista de IDs.La consulta exterior usa esa lista con IN(...)*/



-- =========================================
-- EJERCICIO: 23 Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos 
-- de la lista de actores.
-- =========================================

-- film_actor → film → film_category → category


SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (
    SELECT actor.actor_id
    FROM actor
    INNER JOIN film_actor
        ON actor.actor_id = film_actor.actor_id
    INNER JOIN film_category
        ON film_actor.film_id = film_category.film_id
    INNER JOIN category
        ON film_category.category_id = category.category_id
    WHERE category.name = 'Horror'
);

-- Quiero ver nombre y apellido de la tabla actor
-- Excluye los actores que están dentro de la lista de la subconsulta. NOT IN significa "que NO esté en esta lista".
-- El camino de la subconsulta : actor → film_actor → film_category → category
-- La subconsulta : Esta subconsulta devuelve los actor_id de todos los actores que SÍ han actuado en películas de Horror
-- Paso 1 — La subconsulta busca actores que SÍ están en Horror:
-- Paso 2 — La consulta exterior excluye esos actores:

-- La subconsulta obtiene los IDs de actores que SÍ actúan en Horror. El NOT IN excluye a esos actores.

-- Uso NOT IN con subconsulta porque primero necesito obtener la lista de actores que SÍ están en Horror, y luego excluirlos.



-- =========================================
-- EJERCICIO: 24 Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla `film`.*/

-- =========================================

-- film → film_category → category

SELECT film.title
FROM film
INNER JOIN film_category
    ON film.film_id = film_category.film_id
INNER JOIN category
    ON film_category.category_id = category.category_id
WHERE category.name = 'Comedy'
AND film.length > 180;


-- Quiero ver el título de la película
-- Empiezo desde film
-- Uno film con film_category por film_id
-- Uno film_category con category por category_id
-- c.name = 'Comedy' → solo películas de comedia
-- Filtro dos condiciones a la vez con AND : category.name = 'Comedy' → solo películas de comedia
-- f.length > 180 → solo las que duran más de 180 minutos. Las dos tienen que cumplirse a la vez.

-- ¿Por qué AND y no OR?

-- "Con AND las dos condiciones tienen que cumplirse a la vez. Con OR bastaría con que se cumpla una. 
-- Aquí necesito que sea comedia Y que dure más de 180 minutos, por eso AND"
