

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

SELECT 
    customer.customer_id,            
    customer.first_name,
    customer.last_name,
    COUNT(rental.rental_id) AS total_alquileres
FROM customer
INNER JOIN rental                    
ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name;



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


SELECT actor.first_name, actor.last_name
FROM actor
INNER JOIN film_actor
      ON actor.actor_id = film_actor.actor_id
INNER JOIN film
      ON film_actor.film_id = film.film_id
WHERE film.title = 'Indian Love';



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


/* Queremos TODOS los actores incluso si no tienen películas*/
/*LEFT JOIN Trae todos los de la izquierda aunque no tengan coincidencia*/
/* Si no encuentran coincidencia NULL por eso filtramos IS NULL*/



-- =========================================
-- EJERCICIO: 16 Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
-- =========================================


SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010;


-- =========================================
-- EJERCICIO: 17 Encuentra el título de todas las películas que son de la misma categoría que "Family"
-- =========================================



SELECT film.title
FROM film 
INNER JOIN film_category
     ON film.film_id = film_category.film_id
INNER JOIN category
	ON film_category.category_id = category.category_id
WHERE category.name = 'Family';
   


-- =========================================
-- EJERCICIO: 18 Muestra el nombre y apellido de los actores que aparecen en más de 10 películas
-- =========================================


SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS total_peliculas
FROM actor
INNER JOIN film_actor
    ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(film_actor.film_id) > 10;


/* HAVING es como un WHERE pero para grupos. Aquí filtra los actores cuyo recuento es mayor que 10. 
Regla fácil: WHERE filtra filas individuales, HAVING filtra grupos.*/



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


SELECT category.name, AVG(film.length) AS promedio_duracion
FROM category
INNER JOIN film_category
    ON category.category_id = film_category.category_id
INNER JOIN film
	ON film_category.film_id = film.film_id
GROUP BY category.name
HAVING AVG(film.length) > 120;


-- =========================================
-- EJERCICIO:  21 Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de 
-- películas en las que han actuado.
-- =========================================



SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS total_peliculas
FROM actor
INNER JOIN film_actor
    ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(film_actor.film_id) >= 5;


-- =========================================
-- EJERCICIO: 22  Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta 
-- para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.*/  -- SUBCONSULTAS
-- =========================================

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

--  /* es una query dentro de otra query.La subconsulta (lo que va dentro de los paréntesis) 
-- /* se ejecuta primero y devuelve una lista de IDs.La consulta exterior usa esa lista con IN(...)*/



-- =========================================
-- EJERCICIO: 23 Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos 
-- de la lista de actores.
-- =========================================


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


-- La subconsulta obtiene los IDs de actores que SÍ actúan en Horror. El NOT IN excluye a esos actores.



-- =========================================
-- EJERCICIO: 24 Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla `film`.*/

-- =========================================


SELECT film.title
FROM film
INNER JOIN film_category
    ON film.film_id = film_category.film_id
INNER JOIN category
    ON film_category.category_id = category.category_id
WHERE category.name = 'Comedy'
AND film.length > 180;


