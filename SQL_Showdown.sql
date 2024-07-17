/* 1. Selecciona las columnas DisplayName, Location y Reputation de los usuarios con mayor reputaci�n. Ordena los resultados por la columna Reputation de forma descendente y presenta los resultados en una tabla mostrando solo las columnas DisplayName, Location y Reputation. */

SELECT DisplayName, Location, Reputation
FROM Users
ORDER BY Reputation DESC;

/* 2. Selecciona la columna Title de la tabla Posts junto con el DisplayName de los usuarios que lo publicaron para aquellos posts que tienen un propietario. Para lograr esto une las tablas Posts y Users utilizando OwnerUserId para obtener el nombre del usuario que public� cada post. Presenta los resultados en una tabla mostrando las columnas Title y DisplayName */

SELECT p.Title, u.DisplayName
FROM Posts p
INNER JOIN Users u ON p.OwnerUserId = u.Id
WHERE p.OwnerUserId IS NOT NULL;

/* 3. Calcula el promedio de Score de los Posts por cada usuario y muestra el DisplayName del usuario junto con el promedio de Score. Para esto agrupa los posts por OwnerUserId, calcula el promedio de Score para cada usuario y muestra el resultado junto con el nombre del usuario. Presenta los resultados en una tabla mostrando las columnas DisplayName y el promedio de Score */

SELECT u.DisplayName, AVG(p.Score) AS AverageScore
FROM Users u
INNER JOIN Posts p ON u.Id = p.OwnerUserId
GROUP BY u.Id, u.DisplayName;

/* 4.  Encuentra el DisplayName de los usuarios que han realizado m�s de 100 comentarios en total. Para esto utiliza una subconsulta para calcular el total de comentarios por usuario y luego filtra aquellos usuarios que hayan realizado m�s de 100 comentarios en total. Presenta los resultados en una tabla mostrando el DisplayName de los usuarios */

SELECT u.DisplayName
FROM Users u
WHERE u.Id IN (
    SELECT UserId
    FROM Comments
    GROUP BY UserId
    HAVING COUNT(*) > 100
);

/* 5.  Actualiza la columna Location de la tabla Users cambiando todas las ubicaciones vac�as por "Desconocido". Utiliza una consulta de actualizaci�n para cambiar las ubicaciones vac�as. Muestra un mensaje indicando que la actualizaci�n se realiz� correctamente. */

UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = '';

PRINT 'Actualizaci�n de ubicaciones completada.';

/* 6. Elimina todos los comentarios realizados por usuarios con menos de 100 de reputaci�n. Utiliza una consulta de eliminaci�n para eliminar todos los comentarios realizados y muestra un mensaje indicando cu�ntos comentarios fueron eliminados */

DELETE FROM Comments
WHERE UserId IN (
    SELECT Id
    FROM Users
    WHERE Reputation < 100
);

PRINT 'Se eliminaron ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' comentarios.';

/* 7. Para cada usuario, muestra el n�mero total de publicaciones (Posts), comentarios (Comments) y medallas (Badges) que han realizado. Utiliza uniones (JOIN) para combinar la informaci�n de las tablas Posts, Comments y Badges por usuario. Presenta los resultados en una tabla mostrando el DisplayName del usuario junto con el total de publicaciones, comentarios y medallas */

SELECT 
    u.DisplayName,
    COALESCE(p.PostCount, 0) AS TotalPosts,
    COALESCE(c.CommentCount, 0) AS TotalComments,
    COALESCE(b.BadgeCount, 0) AS TotalBadges
FROM Users u
LEFT JOIN (
    SELECT OwnerUserId, COUNT(*) AS PostCount
    FROM Posts
    GROUP BY OwnerUserId
) p ON u.Id = p.OwnerUserId
LEFT JOIN (
    SELECT UserId, COUNT(*) AS CommentCount
    FROM Comments
    GROUP BY UserId
) c ON u.Id = c.UserId
LEFT JOIN (
    SELECT UserId, COUNT(*) AS BadgeCount
    FROM Badges
    GROUP BY UserId
) b ON u.Id = b.UserId
ORDER BY (COALESCE(p.PostCount, 0) + COALESCE(c.CommentCount, 0) + COALESCE(b.BadgeCount, 0)) DESC;

/* 8. Muestra las 10 publicaciones m�s populares basadas en la puntuaci�n (Score) de la tabla Posts. Ordena las publicaciones por puntuaci�n de forma descendente y selecciona solo las 10 primeras. Presenta los resultados en una tabla mostrando el Title de la publicaci�n y su puntuaci�n */

SELECT TOP 10 Title, Score
FROM Posts
ORDER BY Score DESC;

/* 9. Muestra los 5 comentarios m�s recientes de la tabla Comments. Ordena los comentarios por fecha de creaci�n de forma descendente y selecciona solo los 5 primeros. Presenta los resultados en una tabla mostrando el Text del comentario y la fecha de creaci�n */

SELECT TOP 5 Text, CreationDate
FROM Comments
ORDER BY CreationDate DESC;